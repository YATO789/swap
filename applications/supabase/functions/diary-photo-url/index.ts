// 日記の写真を R2 に上げる・R2 から見るための、期限付き URL（署名付き URL）を出す。
// アプリからログイン情報（JWT）を付けて呼ぶ。R2 の鍵はアプリに持たせず、ここだけが持つ。
//
// 上げる: {"action": "upload", "content_type": "image/jpeg" | "image/png"}
//   → {"path": "diaries/{ユーザーID}/{ランダムな ID}.jpg", "url": "...", "expires_in": 600}
//   写真は呼んだ人のフォルダに置く。日記は1回書くと日記帳ごとに別の行になるので、
//   1回だけ上げて、同じ内容の日記すべての diaries.photo_path に同じ path を書く。
//   どの日記に付けてよいか（今日か昨日の自分の日記だけ）は、photo_path を書くときに diaries の RLS が決める。
// 見る: {"action": "view", "diary_ids": ["...", ...]}
//   → {"urls": {"{日記ID}": "...", ...}, "expires_in": 3600}
//   写真のある日記だけが urls に入る。読めない日記（参加していない日記帳など）は黙って省く。
//
// 誰が何をしてよいかは、呼んだ本人のログイン情報で DB を読み、今の RLS に任せる。
// 写真はタイトルと同じく日記帳のメンバー全員に見せる。
//
// 環境変数（ローカルは functions/.env、本番は supabase secrets set）:
//   R2_ACCOUNT_ID, R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_PRIVATE_BUCKET
// キーは dev 用・prod 用で分け、それぞれ自分の環境のバケットしか触れないようにしてある。

import { createClient, type SupabaseClient } from "npm:@supabase/supabase-js@2";
import { AwsClient } from "npm:aws4fetch@1";

/** 上げる URL の有効期間（秒）。 */
const uploadExpiresIn = 600;

/** 見る URL の有効期間（秒）。アプリは写真を端末にキャッシュするので、短めでよい。 */
const viewExpiresIn = 3600;

/** 一度に URL を出せる日記の数。多すぎる頼みで重くならないようにする。超える分はアプリが分けて頼む。 */
const maxViewDiaries = 100;

const extensions: Record<string, string> = {
  "image/jpeg": "jpg",
  "image/png": "png",
};

const r2 = new AwsClient({
  accessKeyId: Deno.env.get("R2_ACCESS_KEY_ID")!,
  secretAccessKey: Deno.env.get("R2_SECRET_ACCESS_KEY")!,
  service: "s3",
  region: "auto",
});
const bucketUrl = `https://${Deno.env.get("R2_ACCOUNT_ID")}.r2.cloudflarestorage.com/${
  Deno.env.get("R2_PRIVATE_BUCKET")
}`;

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return new Response("method not allowed", { status: 405 });
  }

  // 呼んだ本人として DB を読むクライアント。RLS がそのまま効く。
  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    { global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } } },
  );

  // ログインしているかを確かめる
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) return new Response("not signed in", { status: 401 });

  // 頼み事の種類で分ける
  const body = await req.json().catch(() => ({}));
  switch (body.action) {
    case "upload":
      return await upload(user.id, body);
    case "view":
      return await view(supabase, body);
    default:
      return new Response("action must be upload or view", { status: 400 });
  }
});

async function upload(
  userId: string,
  { content_type: contentType }: Record<string, unknown>,
) {
  // contentType : 「これから上げるファイルが何の種類か」
  const extension = typeof contentType === "string" ? extensions[contentType] : undefined;
  if (!extension) {
    return new Response("content_type must be image/jpeg or image/png", { status: 400 });
  }

  // 上げるたびに名前を変える。同じ名前で上書きすると、端末のキャッシュに古い写真が残るため。
  const path = `diaries/${userId}/${crypto.randomUUID()}.${extension}`;
  const url = await sign("PUT", path, uploadExpiresIn);
  return Response.json({ path, url, expires_in: uploadExpiresIn });
}

async function view(supabase: SupabaseClient,{ diary_ids: diaryIds }: Record<string, unknown>) {
  if (
    !Array.isArray(diaryIds) || diaryIds.length === 0 ||
    diaryIds.length > maxViewDiaries || !diaryIds.every((id) => typeof id === "string")
  ) {
    return new Response(
      `diary_ids must be 1 to ${maxViewDiaries} ids`,
      { status: 400 },
    );
  }

  // 読めない日記は RLS で返ってこないので、そのまま省かれる。
  const { data: diaries, error } = await supabase
    .from("diaries")
    .select("id, photo_path")
    .in("id", diaryIds)
    .not("photo_path", "is", null)
    .returns<{ id: string; photo_path: string }[]>();
  if (error) throw error;

  const urls = Object.fromEntries(
    await Promise.all(
      diaries.map(async ({ id, photo_path: path }) =>
        [id, await sign("GET", path, viewExpiresIn)] as const
      ),
    ),
  );
  return Response.json({ urls, expires_in: viewExpiresIn });
}

/** R2 の [path] に [method] でアクセスできる、[expiresIn] 秒だけ有効な URL を作る。 */
async function sign(method: "GET" | "PUT", path: string, expiresIn: number) {
  const url = new URL(`${bucketUrl}/${path}`);
  url.searchParams.set("X-Amz-Expires", String(expiresIn));
  const signed = await r2.sign(new Request(url, { method }), { aws: { signQuery: true } });
  return signed.url;
}
