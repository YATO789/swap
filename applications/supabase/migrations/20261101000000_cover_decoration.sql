-- 日記帳の表紙の飾り（絵文字・文字・名前とらくがき）。形は docs/cover_decoration.md。
-- 中身はアプリが読むときに確かめるので、ここでは大きさだけを抑える。

-- null なら飾りなし。
alter table public.diary_books
  add column cover_decoration jsonb
  check (pg_column_size(cover_decoration) < 65536);

-- 名前と表紙の色と同じく、メンバーなら変えられる（更新のポリシーは今のままで足りる）。
grant update (cover_decoration) on public.diary_books to authenticated;
