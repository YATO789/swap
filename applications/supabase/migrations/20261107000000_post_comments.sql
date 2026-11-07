-- 記録に付けるコメント。自分の記録には書けない。
-- 記録は複数の日記帳に出せるので、ほかの日記帳の人のコメントが見えないよう、リアクションと同じく日記帳ごとに分ける。
-- 出し先（post_diary_books）に外部キーを向け、記録をその日記帳から外したらコメントも消えるようにする。
-- 日記帳を抜けた人のコメントは、抜けた人の記録やリアクションと同じく残す。
-- 書き直しはできない。消せるのは自分のコメントだけ。
create table public.post_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null,
  diary_book_id uuid not null,
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  -- アプリの maxCommentMessageLength と合わせる。
  message text not null check (char_length(message) between 1 and 100),
  -- 書いた時刻。並べる順に使う。
  created_at timestamptz not null default now(),
  foreign key (post_id, diary_book_id)
    references public.post_diary_books (post_id, diary_book_id) on delete cascade
);
create index on public.post_comments (post_id, diary_book_id, created_at);
create index on public.post_comments (user_id);

-- 書いた時刻は、アプリから値を渡されてもサーバーの now() にする。
create function public.set_post_comment_created_at() returns trigger
language plpgsql set search_path = ''
as $$
begin
  new.created_at := now();
  return new;
end;
$$;

create trigger set_post_comment_created_at
before insert on public.post_comments
for each row execute function public.set_post_comment_created_at();

revoke execute on function public.set_post_comment_created_at() from public, anon, authenticated;

alter table public.post_comments enable row level security;

create policy "見える記録のコメントを読める" on public.post_comments
for select to authenticated
using (public.is_post_visible_in(post_id, diary_book_id));

-- 自分の記録には書かない。
create policy "見えるほかの人の記録にコメントを書ける" on public.post_comments
for insert to authenticated
with check (
  user_id = (select auth.uid())
  and public.is_post_visible_in(post_id, diary_book_id)
  and not exists (
    select 1 from public.posts
    where id = post_id and author_id = (select auth.uid())
  )
);

create policy "自分のコメントを消せる" on public.post_comments
for delete to authenticated
using (
  user_id = (select auth.uid())
  and public.is_post_visible_in(post_id, diary_book_id)
);
