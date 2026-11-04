-- 日記のタイトルは、自分がその日の日記を書く前でも見せる。本文だけを伏せる。
-- タイトルを「続きを読みたくなる予告」にするため、diary_contents から diaries に移す。

alter table public.diaries
  add column title text not null default '' check (char_length(title) <= 40);

update public.diaries d
set title = c.title
from public.diary_contents c
where c.diary_id = d.id;

alter table public.diary_contents drop column title;

-- save_diary の on conflict でタイトルを書き換えるので、update を許す列に足す。
grant update (updated_at, title) on public.diaries to authenticated;

-- 自分の日記を書く。もう書いていればタイトルと本文を書き換える（書いた時刻は変えない）。
create or replace function public.save_diary(
  p_diary_book_id uuid,
  p_date date,
  p_title text,
  p_body text
)
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_id uuid;
begin
  insert into public.diaries (diary_book_id, date, title)
  values (p_diary_book_id, p_date, p_title)
  on conflict (author_id, diary_book_id, date)
  do update set title = excluded.title, updated_at = now()
  returning id into v_id;

  insert into public.diary_contents (diary_id, body)
  values (v_id, p_body)
  on conflict (diary_id) do update set body = excluded.body;
  return v_id;
end;
$$;
