-- 記録に付ける絵文字のリアクション。1つの記録に1人1つ。
-- 記録は複数の日記帳に出せるので、ほかの日記帳の人のリアクションが見えないよう日記帳ごとに分ける。
-- 出し先（post_diary_books）に外部キーを向け、記録をその日記帳から外したらリアクションも消えるようにする。
-- 日記帳を抜けた人のリアクションは、抜けた人の記録と同じく残す。
create table public.post_reactions (
  post_id uuid not null,
  diary_book_id uuid not null,
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  -- 家族の絵文字のように、いくつもの文字をつないだ絵文字もあるので長めに取る。
  emoji text not null check (char_length(emoji) between 1 and 32),
  -- 付けた（付け替えた）時刻。並べる順に使う。
  created_at timestamptz not null default now(),
  primary key (post_id, diary_book_id, user_id),
  foreign key (post_id, diary_book_id)
    references public.post_diary_books (post_id, diary_book_id) on delete cascade
);
create index on public.post_reactions (user_id);

-- 付けた時刻は、アプリから値を渡されてもサーバーの now() にする。
-- 付け替え（upsert の update）でも新しくし、並びの最後に回す。
create function public.set_post_reaction_created_at() returns trigger
language plpgsql set search_path = ''
as $$
begin
  new.created_at := now();
  return new;
end;
$$;

create trigger set_post_reaction_created_at
before insert or update on public.post_reactions
for each row execute function public.set_post_reaction_created_at();

revoke execute on function public.set_post_reaction_created_at() from public, anon, authenticated;

alter table public.post_reactions enable row level security;

create policy "見える記録のリアクションを読める" on public.post_reactions
for select to authenticated
using (public.is_post_visible_in(post_id, diary_book_id));

-- 自分の記録には付けない。
create policy "見えるほかの人の記録にリアクションを付けられる" on public.post_reactions
for insert to authenticated
with check (
  user_id = (select auth.uid())
  and public.is_post_visible_in(post_id, diary_book_id)
  and not exists (
    select 1 from public.posts
    where id = post_id and author_id = (select auth.uid())
  )
);

create policy "自分のリアクションを付け替えられる" on public.post_reactions
for update to authenticated
using (user_id = (select auth.uid()))
with check (
  user_id = (select auth.uid())
  and public.is_post_visible_in(post_id, diary_book_id)
  and not exists (
    select 1 from public.posts
    where id = post_id and author_id = (select auth.uid())
  )
);

create policy "自分のリアクションを取り消せる" on public.post_reactions
for delete to authenticated
using (
  user_id = (select auth.uid())
  and public.is_post_visible_in(post_id, diary_book_id)
);
