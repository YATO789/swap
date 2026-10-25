// 記録が書かれたら、同じ日記帳の人の端末に FCM でプッシュ通知を送る。
// posts への insert のトリガー（notify_post）から pg_net で呼ばれる。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのは記録の id だけにして、中身は service role で DB から読む。
// 同じ id で何度呼ばれても、post_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

Deno.serve(withSecretKey(async (req) => {
  const { post_id: postId } = await req.json().catch(() => ({}));
  if (typeof postId !== "string") {
    return new Response("post_id is required", { status: 400 });
  }

  const { data: claimed, error: claimError } = await supabase
    .from("post_notifications")
    .upsert({ post_id: postId }, { onConflict: "post_id", ignoreDuplicates: true })
    .select();
  // 記録がない（消された・id が違う）と外部キーで失敗する。
  if (claimError) return new Response(claimError.message, { status: 404 });
  if (claimed.length === 0) return new Response("already sent");

  // 1台にも送れなかったときは印を外して、同じ id でもう一度呼べば送り直せるようにする。
  try {
    const { sent, failed } = await notify(postId);
    if (sent === 0 && failed > 0) await unclaim(postId);
    return new Response(`sent to ${sent}`);
  } catch (e) {
    await unclaim(postId);
    throw e;
  }
}));

async function unclaim(postId: string) {
  const { error } = await supabase
    .from("post_notifications")
    .delete()
    .eq("post_id", postId);
  if (error) console.error(`送った印を外せませんでした: ${error.message}`);
}

/** 記録を同じ日記帳の人の端末に送り、送れた台数と送れなかった台数を返す。 */
async function notify(postId: string) {
  const { data: post, error: postError } = await supabase
    .from("posts")
    .select("author_id, profiles(display_name)")
    .eq("id", postId)
    // DB の型を生成していないと、多対一の profiles も配列として型が付くので、実際の形を書く。
    .single<{
      author_id: string;
      profiles: { display_name: string };
    }>();
  if (postError) throw postError;

  const recipients = await findRecipients(postId, post.author_id);
  return await pushToUsers(
    recipients,
    { title: post.profiles.display_name, body: "新しい記録を書いたよ" },
    { post_id: postId },
  );
}

/**
 * 記録が出ている日記帳のメンバーのうち、通知を送る人。
 * 書いた本人には送らない。
 * 値は、その人も入っている日記帳のうちの1つ。
 */
async function findRecipients(
  postId: string,
  authorId: string,
): Promise<Map<string, string>> {
  const { data: diaryBooks, error: diaryBooksError } = await supabase
    .from("post_diary_books")
    .select("diary_book_id")
    .eq("post_id", postId);
  if (diaryBooksError) throw diaryBooksError;

  const { data: members, error: membersError } = await supabase
    .from("diary_book_members")
    .select("user_id, diary_book_id")
    .in("diary_book_id", diaryBooks.map((b) => b.diary_book_id))
    .neq("user_id", authorId);
  if (membersError) throw membersError;

  const recipients = new Map<string, string>();
  for (const { user_id: userId, diary_book_id: diaryBookId } of members) {
    if (recipients.has(userId)) continue;
    recipients.set(userId, diaryBookId);
  }
  return recipients;
}
