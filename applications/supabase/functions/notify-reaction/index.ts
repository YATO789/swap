// 記録にリアクションが付いたら、記録を書いた人の端末に FCM でプッシュ通知を送る。
// post_reactions への insert のトリガー（notify_reaction）から pg_net で呼ばれる。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのはリアクションを見分ける値だけにして、絵文字や名前は service role で DB から読む。
// 同じリアクションで何度呼ばれても（外して付け直しても）、reaction_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

type Reaction = { post_id: string; diary_book_id: string; user_id: string };

Deno.serve(withSecretKey(async (req) => {
  const body = await req.json().catch(() => ({}));
  if (
    typeof body.post_id !== "string" ||
    typeof body.diary_book_id !== "string" ||
    typeof body.user_id !== "string"
  ) {
    return new Response("post_id, diary_book_id and user_id are required", {
      status: 400,
    });
  }
  const reaction: Reaction = {
    post_id: body.post_id,
    diary_book_id: body.diary_book_id,
    user_id: body.user_id,
  };

  const { data: claimed, error: claimError } = await supabase
    .from("reaction_notifications")
    .upsert(reaction, {
      onConflict: "post_id,diary_book_id,user_id",
      ignoreDuplicates: true,
    })
    .select();
  // 記録の出し先や人がない（消された・id が違う）と外部キーで失敗する。
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
    .from("reaction_notifications")
    .delete()
    .eq("post_id", reaction.post_id)
    .eq("diary_book_id", reaction.diary_book_id)
    .eq("user_id", reaction.user_id);
  if (error) console.error(`送った印を外せませんでした: ${error.message}`);
}

/** リアクションを記録を書いた人の端末に送り、送れた台数と送れなかった台数を返す。 */
async function notify(reaction: Reaction) {
  // 送る前に外していたら送らない。付け替えていたら今の絵文字で送る。
  const { data: current, error: currentError } = await supabase
    .from("post_reactions")
    .select("emoji, profiles(display_name)")
    .eq("post_id", reaction.post_id)
    .eq("diary_book_id", reaction.diary_book_id)
    .eq("user_id", reaction.user_id)
    // DB の型を生成していないと、多対一の profiles も配列として型が付くので、実際の形を書く。
    .maybeSingle<{ emoji: string; profiles: { display_name: string } }>();
  if (currentError) throw currentError;
  if (current === null) return { sent: 0, failed: 0 };

  // post_reactions は出し先（post_diary_books）に外部キーを向けていて posts を埋め込めないので、別に読む。
  const { data: post, error: postError } = await supabase
    .from("posts")
    .select("author_id")
    .eq("id", reaction.post_id)
    .single();
  if (postError) throw postError;

  // 書いた人がその日記帳を抜けていたら、記録もリアクションも見えないので送らない。
  const authorId: string = post.author_id;
  const { data: author, error: authorError } = await supabase
    .from("diary_book_members")
    .select("user_id")
    .eq("diary_book_id", reaction.diary_book_id)
    .eq("user_id", authorId)
    .maybeSingle();
  if (authorError) throw authorError;
  if (author === null) return { sent: 0, failed: 0 };

  return await pushToUsers(
    new Map([[authorId, reaction.diary_book_id]]),
    {
      title: current.profiles.display_name,
      body: `あなたの記録に${current.emoji}を付けたよ`,
    },
    { post_id: reaction.post_id },
  );
}
