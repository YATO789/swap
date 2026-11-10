// 日記にリアクションが付いたら、日記を書いた人の端末に FCM でプッシュ通知を送る。
// diary_reactions への insert のトリガー（notify_diary_reaction）から pg_net で呼ばれる。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのはリアクションを見分ける値だけにして、絵文字や名前は service role で DB から読む。
// 同じリアクションで何度呼ばれても（外して付け直しても）、diary_reaction_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

type Reaction = { diary_id: string; user_id: string };

Deno.serve(withSecretKey(async (req) => {
  const body = await req.json().catch(() => ({}));
  if (typeof body.diary_id !== "string" || typeof body.user_id !== "string") {
    return new Response("diary_id and user_id are required", { status: 400 });
  }
  const reaction: Reaction = { diary_id: body.diary_id, user_id: body.user_id };

  const { data: claimed, error: claimError } = await supabase
    .from("diary_reaction_notifications")
    .upsert(reaction, {
      onConflict: "diary_id,user_id",
      ignoreDuplicates: true,
    })
    .select();
  // 日記や人がない（消された・id が違う）と外部キーで失敗する。
  if (claimError) return new Response(claimError.message, { status: 404 });
  if (claimed.length === 0) return new Response("already sent");

  // 1台にも送れなかったときは印を外して、同じリアクションでもう一度呼べば送り直せるようにする。
  try {
    const { sent, failed } = await notify(reaction);
    if (sent === 0 && failed > 0) await unclaim(reaction);
    return new Response(`sent to ${sent}`);
  } catch (e) {
    await unclaim(reaction);
    throw e;
  }
}));

async function unclaim(reaction: Reaction) {
  const { error } = await supabase
    .from("diary_reaction_notifications")
    .delete()
    .eq("diary_id", reaction.diary_id)
    .eq("user_id", reaction.user_id);
  if (error) console.error(`送った印を外せませんでした: ${error.message}`);
}

/** リアクションを日記を書いた人の端末に送り、送れた台数と送れなかった台数を返す。 */
async function notify(reaction: Reaction) {
  // 送る前に外していたら送らない。付け替えていたら今の絵文字で送る。
  const { data: current, error: currentError } = await supabase
    .from("diary_reactions")
    .select("emoji, profiles(display_name)")
    .eq("diary_id", reaction.diary_id)
    .eq("user_id", reaction.user_id)
    // DB の型を生成していないと、多対一の profiles も配列として型が付くので、実際の形を書く。
    .maybeSingle<{ emoji: string; profiles: { display_name: string } }>();
  if (currentError) throw currentError;
  if (current === null) return { sent: 0, failed: 0 };

  const { data: diary, error: diaryError } = await supabase
    .from("diaries")
    .select("author_id, diary_book_id")
    .eq("id", reaction.diary_id)
    .single<{ author_id: string; diary_book_id: string }>();
  if (diaryError) throw diaryError;

  // 書いた人がその日記帳を抜けていたら、日記もリアクションも見えないので送らない。
  const { data: author, error: authorError } = await supabase
    .from("diary_book_members")
    .select("user_id")
    .eq("diary_book_id", diary.diary_book_id)
    .eq("user_id", diary.author_id)
    .maybeSingle();
  if (authorError) throw authorError;
  if (author === null) return { sent: 0, failed: 0 };

  return await pushToUsers(
    new Map([[diary.author_id, diary.diary_book_id]]),
    {
      title: current.profiles.display_name,
      body: `あなたの日記に${current.emoji}を付けたよ`,
    },
    { diary_id: reaction.diary_id },
  );
}
