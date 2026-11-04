// 日記帳に人が参加したら、もとからいるメンバーの端末に FCM でプッシュ通知を送る。
// diary_book_members への insert のトリガー（notify_member_joined）から pg_net で呼ばれる。
// 抜けて入り直したときも送る。参加は (diary_book_id, user_id, joined_at) で見分ける。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのは参加を見分ける値だけにして、名前などは service role で DB から読む。
// 同じ参加で何度呼ばれても、member_join_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

type Joined = { diary_book_id: string; user_id: string; joined_at: string };

Deno.serve(withSecretKey(async (req) => {
  const body = await req.json().catch(() => ({}));
  if (
    typeof body.diary_book_id !== "string" ||
    typeof body.user_id !== "string" ||
    typeof body.joined_at !== "string"
  ) {
    return new Response("diary_book_id, user_id and joined_at are required", {
      status: 400,
    });
  }
  const joined: Joined = {
    diary_book_id: body.diary_book_id,
    user_id: body.user_id,
    joined_at: body.joined_at,
  };

  const { data: claimed, error: claimError } = await supabase
    .from("member_join_notifications")
    .upsert(joined, {
      onConflict: "diary_book_id,user_id,joined_at",
      ignoreDuplicates: true,
    })
    .select();
  // 日記帳や人がない（消された・id が違う）と外部キーで失敗する。
  if (claimError) return new Response(claimError.message, { status: 404 });
  if (claimed.length === 0) return new Response("already sent");

  // 1台にも送れなかったときは印を外して、同じ参加でもう一度呼べば送り直せるようにする。
  try {
    const { sent, failed } = await notify(joined);
    if (sent === 0 && failed > 0) await unclaim(joined);
    return new Response(`sent to ${sent}`);
  } catch (e) {
    await unclaim(joined);
    throw e;
  }
}));

async function unclaim(joined: Joined) {
  const { error } = await supabase
    .from("member_join_notifications")
    .delete()
    .eq("diary_book_id", joined.diary_book_id)
    .eq("user_id", joined.user_id)
    .eq("joined_at", joined.joined_at);
  if (error) console.error(`送った印を外せませんでした: ${error.message}`);
}

/** 参加したことを日記帳のほかのメンバーの端末に送り、送れた台数と送れなかった台数を返す。 */
async function notify(joined: Joined) {
  // 送る前に抜けていたら（入り直していれば joined_at が違うので、それも）送らない。
  const { data: member, error: memberError } = await supabase
    .from("diary_book_members")
    .select("profiles(display_name), diary_books(name)")
    .eq("diary_book_id", joined.diary_book_id)
    .eq("user_id", joined.user_id)
    .eq("joined_at", joined.joined_at)
    // DB の型を生成していないと、多対一の profiles・diary_books も配列として型が付くので、実際の形を書く。
    .maybeSingle<{
      profiles: { display_name: string };
      diary_books: { name: string };
    }>();
  if (memberError) throw memberError;
  if (member === null) return { sent: 0, failed: 0 };

  // 参加した本人には送らない。
  const { data: members, error: membersError } = await supabase
    .from("diary_book_members")
    .select("user_id")
    .eq("diary_book_id", joined.diary_book_id)
    .neq("user_id", joined.user_id);
  if (membersError) throw membersError;

  const recipients = new Map<string, string>(
    members.map(({ user_id: userId }) => [userId, joined.diary_book_id] as const),
  );
  return await pushToUsers(
    recipients,
    {
      title: member.profiles.display_name,
      body: `「${member.diary_books.name}」に参加したよ`,
    },
    { member_user_id: joined.user_id },
  );
}
