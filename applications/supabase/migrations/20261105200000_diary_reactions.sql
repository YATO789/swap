-- 日記に付ける絵文字のリアクション。1つの日記に1人1つ。
-- 日記は日記帳ごとに1つずつあるので、日記帳で分けなくても、ほかの日記帳の人のリアクションは混ざらない。
-- 日記帳を抜けた人のリアクションは、抜けた人の日記と同じく残す。
create table public.diary_reactions (
  diary_id uuid not null references public.diaries (id) on delete cascade,
  user_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  -- 家族の絵文字のように、いくつもの文字をつないだ絵文字もあるので長めに取る。
  emoji text not null check (char_length(emoji) between 1 and 32),
  -- 付けた（付け替えた）時刻。並べる順に使う。
  created_at timestamptz not null default now(),
  primary key (diary_id, user_id)
);
create index on public.diary_reactions (user_id);

-- 付けた時刻は、アプリから値を渡されてもサーバーの now() にする。
-- 付け替え（upsert の update）でも新しくし、並びの最後に回す。
-- 中身は記録のリアクションと同じ関数を使う。
create trigger set_diary_reaction_created_at
before insert or update on public.diary_reactions
for each row execute function public.set_post_reaction_created_at();

alter table public.diary_reactions enable row level security;

-- diaries の select ポリシーも効くので、見えない日記のリアクションは読めない。
create policy "見える日記のリアクションを読める" on public.diary_reactions
for select to authenticated
using (exists (select 1 from public.diaries d where d.id = diary_id));

-- リアクションを付けられるのは、本文を読めるほかの人の日記だけ。自分の日記には付けない。
create policy "読めるほかの人の日記にリアクションを付けられる" on public.diary_reactions
for insert to authenticated
with check (
  user_id = (select auth.uid())
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id
      and d.author_id <> (select auth.uid())
      and public.wrote_diary_on(d.diary_book_id, d.date)
  )
);

create policy "自分のリアクションを付け替えられる" on public.diary_reactions
for update to authenticated
using (user_id = (select auth.uid()))
with check (
  user_id = (select auth.uid())
  and exists (
    select 1 from public.diaries d
    where d.id = diary_id
      and d.author_id <> (select auth.uid())
      and public.wrote_diary_on(d.diary_book_id, d.date)
  )
);

create policy "自分のリアクションを取り消せる" on public.diary_reactions
for delete to authenticated
using (user_id = (select auth.uid()));
