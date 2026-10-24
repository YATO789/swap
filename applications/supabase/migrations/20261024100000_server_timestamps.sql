-- 書いた時刻は、アプリから値を渡されてもサーバーの now() にする。
-- 列の default だけだと、posts や diaries に直接 insert すれば好きな時刻を入れられる。
-- diaries.updated_at は save_diary の on conflict で更新するため update を許しているので、
-- 列の権限では防げない。トリガーで上書きする。

create function public.set_posted_at() returns trigger
language plpgsql set search_path = ''
as $$
begin
  new.posted_at := now();
  return new;
end;
$$;

create trigger set_posted_at
before insert on public.posts
for each row execute function public.set_posted_at();

-- 最初に書いた時刻（written_at）は insert のときだけ決め、そのあとは変えない。
create function public.set_diary_times() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if tg_op = 'INSERT' then
    new.written_at := now();
  else
    new.written_at := old.written_at;
  end if;
  new.updated_at := now();
  return new;
end;
$$;

create trigger set_diary_times
before insert or update on public.diaries
for each row execute function public.set_diary_times();

revoke execute on function public.set_posted_at() from public, anon, authenticated;
revoke execute on function public.set_diary_times() from public, anon, authenticated;
