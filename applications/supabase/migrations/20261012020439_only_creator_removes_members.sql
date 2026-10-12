-- メンバーを外せるのを、日記帳を作った人（diary_books.created_by）だけにする。
-- 作った人が抜けている間は誰も外せない。招待コードで入り直せばまた外せる。

-- 自分が作った日記帳から、ほかのメンバーを外し、新しい招待コードを返す。
-- 前のコードのままだと外した人がまた参加できるので、招待コードも作り直す。
-- 自分が抜けるときは diary_book_members を直接消す。
create or replace function public.remove_diary_book_member(p_diary_book_id uuid, p_user_id uuid)
returns text
language plpgsql security definer set search_path = ''
as $$
begin
  if p_user_id = (select auth.uid()) then
    raise exception 'cannot remove yourself';
  end if;
  if not public.is_member(p_diary_book_id)
    or not exists (
      select 1 from public.diary_books
      where id = p_diary_book_id and created_by = (select auth.uid())
    )
  then
    raise exception 'not the creator';
  end if;

  delete from public.diary_book_members
  where diary_book_id = p_diary_book_id and user_id = p_user_id;
  return public.regenerate_invite_code(p_diary_book_id);
end;
$$;
