// 記録・日記・参加・リアクション・コメントの通知（notify-post・notify-diary・notify-member-joined・notify-reaction・notify-diary-reaction・notify-comment）で共通の、FCM でプッシュ通知を送る部分。
//
// 環境変数 FIREBASE_SERVICE_ACCOUNT に、Firebase コンソールの「プロジェクトの設定 > サービス アカウント」で
// 作った秘密鍵の JSON を1行にして（jq -c .）入れておく。
// ローカルは functions/.env に FIREBASE_SERVICE_ACCOUNT='...' と書き、本番は supabase secrets set で入れる。

import { createClient } from "npm:@supabase/supabase-js@2";
import { withSupabase } from "npm:@supabase/server@1";
import { JWT } from "npm:google-auth-library@9";

type ServiceAccount = {
  project_id: string;
  client_email: string;
  private_key: string;
};

/*supabase clientの作成*/
export const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

/*Edge Functionを呼び出せる相手を制限する*/
export function withSecretKey(handler: (req: Request) => Promise<Response>) {
  return withSupabase({ auth: "secret:*", cors: "disabled" }, handler);
}

/**
 * [recipients] の人の端末に通知を送り、送れた台数と送れなかった台数を返す。
 * [recipients] の値は、通知を開いたときに移る日記帳の id。
 * [data] は、日記帳の id と一緒に通知に載せる値。
 */
export async function pushToUsers(
  recipients: Map<string, string>,
  notification: { title: string; body: string },
  data: Record<string, string>,
) {
  const tokens = await findTokens([...recipients.keys()]);
  if (tokens.length === 0) return { sent: 0, failed: 0 };

  // .env から読むと private_key の \n が本物の改行になり、そのままでは JSON として読めない。
  // JSON は1行で入れているので、改行は private_key の中にしかない。
  const serviceAccount: ServiceAccount = JSON.parse(
    Deno.env.get("FIREBASE_SERVICE_ACCOUNT")!.replaceAll("\n", "\\n"),
  );
  const accessToken = await fetchAccessToken(serviceAccount);
  const unreadCounts = await incrementUnreadCounts(tokens.map((t) => t.token));
  const results = await Promise.all(
    tokens.map(({ token, user_id: userId }) =>
      send(serviceAccount.project_id, accessToken, {
        token,
        notification,
        // 通知を開いたときに、その日記帳へ移れるようにする。
        data: { ...data, diary_book_id: recipients.get(userId)! },
        apns: {
          payload: {
            aps: { sound: "default", badge: unreadCounts.get(token) ?? 1 },
          },
        },
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

/*push_tokensテーブルを参照して、そのユーザーが登録している端末トークンをすべて取得*/
async function findTokens(userIds: string[]) {
  if (userIds.length === 0) return [];
  const { data, error } = await supabase
    .from("push_tokens")
    .select("token, user_id")
    .in("user_id", userIds);
  if (error) throw error;
  return data;
}

/** 端末ごとの未読数を1つ増やし、バッジに出す数を返す。 */
async function incrementUnreadCounts(tokens: string[]) {
  const { data, error } = await supabase.rpc("increment_push_unread_counts", {
    p_tokens: tokens,
  });
  if (error) throw error;
  return new Map<string, number>(
    data.map((r: { token: string; unread_count: number }) => [
      r.token,
      r.unread_count,
    ]),
  );
}

/*Firebaseのアクセストークンを取得*/
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
