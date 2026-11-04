-- アイコンの色。日記帳のメンバーにも見せる。

-- 0xAARRGGBB。null なら決まった見た目（自分は黒、ほかの人は白）。
alter table public.profiles
  add column avatar_color bigint check (avatar_color between 0 and 4294967295);

-- 参加する前の画面でも、メンバーのアイコンを色付きで出せるようにする。
-- 返す列が変わるので作り直す。member_avatar_colors は member_names と同じ順。
drop function public.find_diary_book_by_code(text);

create function public.find_diary_book_by_code(p_code text)
returns table (
  id uuid,
  name text,
  cover_color bigint,
  member_limit smallint,
  member_names text[],
  member_avatar_colors bigint[],
  already_joined boolean
)
language sql stable security definer set search_path = ''
as $$
  select
    b.id,
    b.name,
    b.cover_color,
    b.member_limit,
    array(
      select p.display_name
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at, m.user_id
    ),
    array(
      select p.avatar_color
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at, m.user_id
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
