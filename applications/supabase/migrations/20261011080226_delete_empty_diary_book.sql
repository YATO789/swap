-- 最後の1人が抜けて誰もいなくなった日記帳を消す。日記・本文・記録の出し先も一緒に消える。
-- 残しておくと、招待コードを知っている人が参加して前のメンバーの日記を読めてしまう。
-- 抜けた本人はもう RLS で日記帳を消せないので、security definer にする。
create function public.delete_empty_diary_book() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  -- 最後の2人が同時に抜けると、お互いに相手がまだいると見て、どちらも消さないことがある。
  -- 日記帳の行を先に押さえ、後から来た方が先の退出を見てから数えるようにする。
  perform 1 from public.diary_books where id = old.diary_book_id for update;

  delete from public.diary_books b
  where b.id = old.diary_book_id
    and not exists (
      select 1 from public.diary_book_members m
      where m.diary_book_id = old.diary_book_id
    );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.delete_empty_diary_book() from public, anon, authenticated;

create trigger delete_empty_diary_book
after delete on public.diary_book_members
for each row execute function public.delete_empty_diary_book();
