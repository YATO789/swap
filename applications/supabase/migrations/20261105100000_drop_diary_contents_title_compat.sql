-- 20261104100000_diary_contents_title_compat.sql で一時的に戻した diary_contents.title を消す。
-- 強制アップデートで 1.2.0 以上を必須にし、diary_contents(title, body) で日記を読む 1.1.0 以前のアプリはいなくなった。
-- タイトルは diaries.title だけに持つ。

drop trigger sync_diary_title_to_contents on public.diaries;
drop function public.sync_diary_title_to_contents();

drop trigger copy_diary_title_to_contents on public.diary_contents;
drop function public.copy_diary_title_to_contents();

alter table public.diary_contents drop column title;
