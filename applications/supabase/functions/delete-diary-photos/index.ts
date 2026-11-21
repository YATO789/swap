// どの日記からも指されなくなった日記の写真を、R2 から消す。
// diaries の update・delete のトリガー（delete_unused_diary_photos）から pg_net で呼ばれる。
// 写真を差し替えた・外したとき、日記を消したとき、日記帳やアカウントを消して日記ごと消えたときに呼ばれる。
//
// 受け取る: {"paths": ["diaries/{ユーザーID}/{UUID}.jpg", ...]}
//
// JWT なしで呼ぶので、トリガーが apikey ヘッダーに付けた Secret Key で確かめる（_shared/push.ts の withSecretKey）。
// 呼ばれるまでの間にまたどこかの日記が指すようになった写真は、消さずに残す。
// R2 は、もうない写真を消しても成功を返すので、同じパスで何度呼ばれてもよい。

import { supabase, withSecretKey } from "../_shared/push.ts";
import { objectUrl, r2 } from "../_shared/r2.ts";

/** 日記の写真のパスの形。diaries.photo_path の check と同じ。ほかのフォルダは消さない。 */
const photoPathPattern = /^diaries\/[0-9a-f-]{36}\/[0-9a-f-]{36}\.(jpg|png)$/;

/** 一度に DB で確かめる・R2 に消しに行く数。アカウントを消したときは多くなるので分ける。 */
const chunkSize = 100;

Deno.serve(withSecretKey(async (req) => {
  const { paths } = await req.json().catch(() => ({}));
  if (
    !Array.isArray(paths) ||
    !paths.every((path) => typeof path === "string" && photoPathPattern.test(path))
  ) {
    return new Response("paths must be diary photo paths", { status: 400 });
  }

  let deleted = 0;
  for (let start = 0; start < paths.length; start += chunkSize) {
    const chunk: string[] = paths.slice(start, start + chunkSize);
    for (const path of await unused(chunk)) {
      const response = await r2.fetch(objectUrl(path), { method: "DELETE" });
      if (!response.ok) {
        throw new Error(`${path} を消せませんでした（${response.status}）`);
      }
      deleted++;
    }
  }
  return new Response(`deleted ${deleted}`);
}));

/** [paths] のうち、今どの日記も指していない写真。 */
async function unused(paths: string[]) {
  const { data, error } = await supabase
    .from("diaries")
    .select("photo_path")
    .in("photo_path", paths)
    .returns<{ photo_path: string }[]>();
  if (error) throw error;
  const used = new Set(data.map(({ photo_path: path }) => path));
  return paths.filter((path) => !used.has(path));
}
