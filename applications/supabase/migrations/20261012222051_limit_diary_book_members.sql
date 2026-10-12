-- 1冊の日記帳に入れる人数を8人までにする。

-- 招待コードで日記帳に参加する。コードが違えば null。もう参加していれば何もせずその id を返す。
-- 1冊に入れるのは8人まで。アプリの maxDiaryBookMembers と合わせる。
create or replace function public.join_diary_book(p_code text)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_id uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  -- 同時に参加して8人を超えないように、日記帳の行を押さえてから数える。
  select id into v_id from public.diary_books
  where invite_code = btrim(p_code)
  for update;
  if v_id is null then
    return null;
  end if;

  if not exists (
    select 1 from public.diary_book_members
    where diary_book_id = v_id and user_id = (select auth.uid())
  ) and (
    select count(*) from public.diary_book_members where diary_book_id = v_id
  ) >= 8 then
    raise exception 'diary book is full';
  end if;

  insert into public.diary_book_members (diary_book_id, user_id)
  values (v_id, (select auth.uid()))
  on conflict do nothing;
  return v_id;
end;
$$;
