// 記録にコメントが付いたら、記録を書いた人と、その記録にもうコメントした人の端末に FCM でプッシュ通知を送る。
// コメントした本人には送らない。post_comments への insert のトリガー（notify_comment）から pg_net で呼ばれる。
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 受け取るのはコメントの id だけにして、本文や名前は service role で DB から読む。
// コメントはリアクションと同じく日記帳ごとに分かれているので、送るのもその日記帳のコメントした人だけにする。
//
// FCM に送る部分は _shared/push.ts にある。

import { pushToUsers, supabase, withSecretKey } from "../_shared/push.ts";

Deno.serve(withSecretKey(async (req) => {
  const body = await req.json().catch(() => ({}));
  if (typeof body.comment_id !== "string") {
    return new Response("comment_id is required", { status: 400 });
  }

  const { sent } = await notify(body.comment_id);
  return new Response(`sent to ${sent}`);
}));

/** コメントを知らせ、送れた台数と送れなかった台数を返す。 */
async function notify(commentId: string) {
  // 送る前に消していたら送らない。
  const { data: comment, error: commentError } = await supabase
    .from("post_comments")
    .select("post_id, diary_book_id, user_id, message, profiles(display_name)")
    .eq("id", commentId)
    // DB の型を生成していないと、多対一の profiles も配列として型が付くので、実際の形を書く。
    .maybeSingle<{
      post_id: string;
      diary_book_id: string;
      user_id: string;
      message: string;
      profiles: { display_name: string };
    }>();
  if (commentError) throw commentError;
  if (comment === null) return { sent: 0, failed: 0 };

  // post_comments は出し先（post_diary_books）に外部キーを向けていて posts を埋め込めないので、別に読む。
  const { data: post, error: postError } = await supabase
    .from("posts")
    .select("author_id, profiles(display_name)")
    .eq("id", comment.post_id)
    .single<{ author_id: string; profiles: { display_name: string } }>();
  if (postError) throw postError;

  // 同じ記録（この日記帳）にもうコメントした人。
  const { data: commenters, error: commentersError } = await supabase
    .from("post_comments")
    .select("user_id")
    .eq("post_id", comment.post_id)
    .eq("diary_book_id", comment.diary_book_id);
  if (commentersError) throw commentersError;

  const others = new Set(commenters.map((c: { user_id: string }) => c.user_id));
  others.delete(post.author_id);
  others.delete(comment.user_id);

  // 日記帳を抜けた人には、記録もコメントも見えないので送らない。
  const candidates = [post.author_id, ...others].filter((id) =>
    id !== comment.user_id
  );
  if (candidates.length === 0) return { sent: 0, failed: 0 };
  const { data: members, error: membersError } = await supabase
    .from("diary_book_members")
    .select("user_id")
    .eq("diary_book_id", comment.diary_book_id)
    .in("user_id", candidates);
  if (membersError) throw membersError;
  const memberIds = new Set(members.map((m: { user_id: string }) => m.user_id));

  const name = comment.profiles.display_name;
  const data = { post_id: comment.post_id };
  const results = [];

  // 記録を書いた人には「あなたの記録に」、ほかのコメントした人には「〇〇の記録に」と書く。
  if (post.author_id !== comment.user_id && memberIds.has(post.author_id)) {
    results.push(
      await pushToUsers(
        new Map([[post.author_id, comment.diary_book_id]]),
        { title: name, body: `あなたの記録にコメント：${comment.message}` },
        data,
      ),
    );
  }
  const otherRecipients = [...others].filter((id) => memberIds.has(id));
  if (otherRecipients.length > 0) {
    results.push(
      await pushToUsers(
        new Map(otherRecipients.map((id) => [id, comment.diary_book_id])),
        {
          title: name,
          body: `${post.profiles.display_name}の記録にコメント：${comment.message}`,
        },
        data,
      ),
    );
  }

  return {
    sent: results.reduce((sum, r) => sum + r.sent, 0),
    failed: results.reduce((sum, r) => sum + r.failed, 0),
  };
}
