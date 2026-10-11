-- 自分のアカウントを消す（App Store ガイドライン 5.1.1(v)）。
-- auth.users を消すと、プロフィール・参加・記録・日記・ブロックが on delete cascade で消え、
-- 誰もいなくなった日記帳も delete_empty_diary_book トリガーで消える。通報は送った人だけ空になる。
-- auth.users はアプリから触れないので、security definer にする。
create function public.delete_account() returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  delete from auth.users where id = (select auth.uid());
end;
$$;

revoke execute on function public.delete_account() from public, anon;
grant execute on function public.delete_account() to authenticated;
