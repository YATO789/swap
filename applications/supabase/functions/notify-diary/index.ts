// 日記が書かれたら、同じ日記帳の人の端末に FCM でプッシュ通知を送る。
// diaries への insert のトリガー（notify_diary）から pg_net で呼ばれる。
// 書き直し（update）では呼ばれない。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのは日記の id だけにして、中身は service role で DB から読む。
// 同じ id で何度呼ばれても、diary_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// 本文は自分も書いた人しか読めないので、通知にはタイトルも本文も出さない。
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

Deno.serve(withSecretKey(async (req) => {
  const { diary_id: diaryId } = await req.json().catch(() => ({}));
  if (typeof diaryId !== "string") {
    return new Response("diary_id is required", { status: 400 });
  }

  const { data: claimed, error: claimError } = await supabase
    .from("diary_notifications")
    .upsert({ diary_id: diaryId }, { onConflict: "diary_id", ignoreDuplicates: true })
    .select();
  // 日記がない（消された・id が違う）と外部キーで失敗する。
  if (claimError) return new Response(claimError.message, { status: 404 });
  if (claimed.length === 0) return new Response("already sent");

  // 1台にも送れなかったときは印を外して、同じ id でもう一度呼べば送り直せるようにする。
  try {
    const { sent, failed } = await notify(diaryId);
    if (sent === 0 && failed > 0) await unclaim(diaryId);
    return new Response(`sent to ${sent}`);
  } catch (e) {
    await unclaim(diaryId);
    throw e;
  }
}));

async function unclaim(diaryId: string) {
  const { error } = await supabase
    .from("diary_notifications")
    .delete()
    .eq("diary_id", diaryId);
  if (error) console.error(`送った印を外せませんでした: ${error.message}`);
}

/** 日記を同じ日記帳の人の端末に送り、送れた台数と送れなかった台数を返す。 */
async function notify(diaryId: string) {
  const { data: diary, error: diaryError } = await supabase
    .from("diaries")
    .select("author_id, diary_book_id, profiles(display_name)")
    .eq("id", diaryId)
    // DB の型を生成していないと、多対一の profiles も配列として型が付くので、実際の形を書く。
    .single<{
      author_id: string;
      diary_book_id: string;
      profiles: { display_name: string };
    }>();
  if (diaryError) throw diaryError;

  // 書いた本人には送らない。
  const { data: members, error: membersError } = await supabase
    .from("diary_book_members")
    .select("user_id")
    .eq("diary_book_id", diary.diary_book_id)
    .neq("user_id", diary.author_id);
  if (membersError) throw membersError;

  const recipients = new Map<string, string>(
    members.map(({ user_id: userId }) => [userId, diary.diary_book_id] as const),
  );
  return await pushToUsers(
    recipients,
    { title: diary.profiles.display_name, body: "日記を書いたよ" },
    { diary_id: diaryId },
  );
}
