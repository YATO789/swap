-- 日記に写真を1枚付けられるようにする。
-- 写真は Cloudflare R2 の非公開バケット（swap-{dev|prod}-private）に置き、ここには R2 上のパスだけを持つ。
-- 上げる・見るための期限付き URL は Edge Function（diary-photo-url）が出す。
-- 写真はタイトルと同じく日記帳のメンバー全員に見せる（本文のロックはかけない）ので、diaries に持つ。
-- null なら写真なし。
--
-- 日記は1回書くと、選んだ日記帳それぞれに別の行として入る。写真は1回だけ上げて、
-- 同じ内容の日記すべてが同じパスを指すので、パスは日記ではなく書いた人のフォルダに置く。
-- ほかの人の写真やほかのサーバーを指せないように、書いた人のフォルダの中の形だけを許す。
alter table public.diaries
  add column photo_path text
  check (photo_path ~ ('^diaries/' || author_id::text || '/[0-9a-f-]{36}\.(jpg|png)$'));

-- アプリが写真を上げたあとに、自分の日記の photo_path を書き換えられるようにする。
-- 書き換えられるのは「今日か昨日の自分の日記」だけ（diaries の update ポリシー）。
grant update (updated_at, title, photo_path) on public.diaries to authenticated;
