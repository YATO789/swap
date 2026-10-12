-- 日記帳のアイコンの1文字は、アプリが名前から作る。DB には持たない。

-- 返す列が変わるので、作り直す。
drop function public.find_diary_book_by_code(text);

alter table public.diary_books drop column icon;

-- 招待コードの日記帳を、参加する前に見せるための情報。見つからなければ 0 行。
create function public.find_diary_book_by_code(p_code text)
returns table (
  id uuid,
  name text,
  cover_color bigint,
  member_names text[],
  already_joined boolean
)
language sql stable security definer set search_path = ''
as $$
  select
    b.id,
    b.name,
    b.cover_color,
    array(
      select p.display_name
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at
    ),
    exists (
      select 1 from public.diary_book_members m
      where m.diary_book_id = b.id and m.user_id = (select auth.uid())
    )
  from public.diary_books b
  where b.invite_code = btrim(p_code)
    and (select auth.uid()) is not null;
$$;

revoke execute on function public.find_diary_book_by_code(text) from public, anon;
grant execute on function public.find_diary_book_by_code(text) to authenticated;
