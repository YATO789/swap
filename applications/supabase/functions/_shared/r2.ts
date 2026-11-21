// 日記の写真の Edge Function（diary-photo-url・delete-diary-photos）で共通の、R2 の非公開バケットを触る部分。
//
// 環境変数（ローカルは functions/.env、本番は supabase secrets set）:
//   R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_PRIVATE_BUCKET
// キーは dev 用・prod 用で分け、それぞれ自分の環境のバケットしか触れないようにしてある。

import { AwsClient } from "npm:aws4fetch@1";

export const r2 = new AwsClient({
  accessKeyId: Deno.env.get("R2_ACCESS_KEY_ID")!,
  secretAccessKey: Deno.env.get("R2_SECRET_ACCESS_KEY")!,
  service: "s3",
  region: "auto",
});

const bucketUrl = `https://${Deno.env.get("R2_ACCOUNT_ID")}.r2.cloudflarestorage.com/${
  Deno.env.get("R2_PRIVATE_BUCKET")
}`;

/** 非公開バケットの中の [path] の URL。 */
export function objectUrl(path: string) {
  return new URL(`${bucketUrl}/${path}`);
}
