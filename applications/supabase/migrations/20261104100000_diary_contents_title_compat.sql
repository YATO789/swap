-- 一時的な互換のための migration。
-- 1.1.0 以前のアプリは diary_contents(title, body) で日記を読むので、20261103100000 で
-- diary_contents.title を消したあと、日記が読めなくなった。
-- diaries.title を正とし、diary_contents.title にはその写しをトリガーで持たせる。
-- 1.2.0 を必須にして古いアプリがいなくなったら、この列・関数・トリガーを消す。

alter table public.diary_contents
  add column title text not null default '' check (char_length(title) <= 40);

update public.diary_contents c
set title = d.title
from public.diaries d
where d.id = c.diary_id;

-- diary_contents を書くときは、タイトルを diaries から写す（直接書かれた値は使わない）。
create function public.copy_diary_title_to_contents()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  select d.title into new.title from public.diaries d where d.id = new.diary_id;
  new.title := coalesce(new.title, '');
  return new;
end;
$$;
revoke execute on function public.copy_diary_title_to_contents() from public, anon, authenticated;

create trigger copy_diary_title_to_contents
  before insert or update on public.diary_contents
  for each row execute function public.copy_diary_title_to_contents();

-- diaries のタイトルが変わったら、diary_contents の写しも直す。
create function public.sync_diary_title_to_contents()
returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.diary_contents set title = new.title where diary_id = new.id;
  return null;
end;
$$;
revoke execute on function public.sync_diary_title_to_contents() from public, anon, authenticated;

create trigger sync_diary_title_to_contents
  after update of title on public.diaries
  for each row
  when (old.title is distinct from new.title)
  execute function public.sync_diary_title_to_contents();
