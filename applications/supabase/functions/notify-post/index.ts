// 記録が書かれたら、同じ日記帳の人の端末に FCM でプッシュ通知を送る。
// posts への insert のトリガー（notify_post）から pg_net で呼ばれる。
//
// JWT なしで呼べるので、受け取るのは記録の id だけにして、中身は service role で DB から読む。
// 同じ id で何度呼ばれても、post_notifications に入れられた最初の1回だけ送る。
// 途中で失敗して1台にも送れなかったときは印を外すので、もう一度呼べば送り直せる。
//
// 環境変数 FIREBASE_SERVICE_ACCOUNT に、Firebase コンソールの「プロジェクトの設定 > サービス アカウント」で
// 作った秘密鍵の JSON を1行にして（jq -c .）入れておく。
// ローカルは functions/.env に FIREBASE_SERVICE_ACCOUNT='...' と書き、本番は supabase secrets set で入れる。

import { createClient } from "npm:@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library@9";

type ServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

Deno.serve(async (req) => {
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
});

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
    .select("message, author_id, profiles(display_name)")
    .eq("id", postId)
    .single();
  if (postError) throw postError;

  const recipients = await findRecipients(postId, post.author_id);
  const tokens = await findTokens([...recipients.keys()]);
  if (tokens.length === 0) return { sent: 0, failed: 0 };

  // .env から読むと private_key の \n が本物の改行になり、そのままでは JSON として読めない。
  // JSON は1行で入れているので、改行は private_key の中にしかない。
  const serviceAccount: ServiceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!.replaceAll("\n", "\\n"),
  );
  const accessToken = await fetchAccessToken(serviceAccount);
  const results = await Promise.all(
    tokens.map(({ token, user_id: userId }) =>
      send(serviceAccount.project_id, accessToken, {
        token,
        notification: {
          title: post.profiles?.display_name ?? "",
          body: post.message,
        },
        // 通知を開いたときに、その記録が出ている日記帳へ移れるようにする。
        data: { post_id: postId, diary_book_id: recipients.get(userId)! },
        apns: { payload: { aps: { sound: "default" } } },
      })
    ),
  );

  // アプリを消した端末などのトークンは、もう届かないので消しておく。
  const staleTokens = tokens
    .filter((_, i) => results[i] === "unregistered")
    .map(({ token }) => token);
  if (staleTokens.length > 0) {
    await supabase.from("push_tokens").delete().in("token", staleTokens);
  }

  return {
    sent: results.filter((r) => r === "sent").length,
    failed: results.filter((r) => r === "failed").length,
  };
}

/**
 * 記録が出ている日記帳のメンバーのうち、通知を送る人。
 * 書いた本人と、書いた人をブロックしている人には送らない。
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

  const { data: blocks, error: blocksError } = await supabase
    .from("blocks")
    .select("blocker_id")
    .eq("blocked_id", authorId);
  if (blocksError) throw blocksError;
  const blockers = new Set(blocks.map((b) => b.blocker_id));

  const recipients = new Map<string, string>();
  for (const { user_id: userId, diary_book_id: diaryBookId } of members) {
    if (blockers.has(userId) || recipients.has(userId)) continue;
    recipients.set(userId, diaryBookId);
  }
  return recipients;
}

async function findTokens(userIds: string[]) {
  if (userIds.length === 0) return [];
  const { data, error } = await supabase
    .from("push_tokens")
    .select("token, user_id")
    .in("user_id", userIds);
  if (error) throw error;
  return data;
}

async function fetchAccessToken(serviceAccount: ServiceAccount) {
  const jwt = new JWT({
    email: serviceAccount.client_email,
    key: serviceAccount.private_key,
    scopes: ["https://www.googleapis.com/auth/firebase.messaging"],
  });
  const { access_token } = await jwt.authorize();
  return access_token!;
}

/** FCM HTTP v1 API で1台に送る。 */
async function send(
  projectId: string,
  accessToken: string,
  message: Record<string, unknown>,
): Promise<"sent" | "unregistered" | "failed"> {
  const res = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify({ message }),
    },
  );
  if (res.ok) return "sent";

  const body = await res.text();
  console.error(`FCM に送れませんでした: ${res.status} ${body}`);
  return body.includes('"UNREGISTERED"') ? "unregistered" : "failed";
}
