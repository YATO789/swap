-- 日記帳に入る前に書かれた日記と記録は、入った人に見せない。
-- 入り直すと joined_at も入り直した時刻になるので、それより前は自分が書いたものしか見えない。

-- 自分が指定した日記帳に入った時刻。入っていなければ null。
create function public.my_joined_at(p_diary_book_id uuid) returns timestamptz
language sql stable security definer set search_path = ''
as $$
  select joined_at from public.diary_book_members
  where diary_book_id = p_diary_book_id and user_id = (select auth.uid());
$$;

-- 記録が、指定した日記帳を通して見えるか。
-- 日記帳ごとに判定しないと、昔から入っている日記帳にも出た古い記録が、最近入った日記帳の一覧にも出てしまう。
create function public.is_post_visible_in(p_post_id uuid, p_diary_book_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1
    from public.posts p join public.diary_book_members m
      on m.diary_book_id = p_diary_book_id and m.user_id = (select auth.uid())
    where p.id = p_post_id
      and (p.author_id = (select auth.uid()) or p.posted_at >= m.joined_at)
  );
$$;

-- 記録が、自分の入っている日記帳のどれかを通して見えるか。
create or replace function public.is_post_visible(p_post_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.post_diary_books
    where post_id = p_post_id and public.is_post_visible_in(post_id, diary_book_id)
  );
$$;

revoke execute on function public.my_joined_at(uuid) from public, anon;
grant execute on function public.my_joined_at(uuid) to authenticated;
revoke execute on function public.is_post_visible_in(uuid, uuid) from public, anon;
grant execute on function public.is_post_visible_in(uuid, uuid) to authenticated;

drop policy "参加している日記帳の記録の出し先を読める" on public.post_diary_books;
create policy "入ってからの記録の出し先を読める" on public.post_diary_books
for select to authenticated
using (public.is_post_visible_in(post_id, diary_book_id));

drop policy "参加している日記帳の日記を読める" on public.diaries;
create policy "自分の日記と入ってから書かれた日記を読める" on public.diaries
for select to authenticated
using (
  (author_id = (select auth.uid()) and public.is_member(diary_book_id))
  or written_at >= public.my_joined_at(diary_book_id)
);
