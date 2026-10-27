-- アイコンの色をやめる（マイグレーション②）。色を読むアプリはもう使われていない。

alter table public.profiles drop column avatar_color;
