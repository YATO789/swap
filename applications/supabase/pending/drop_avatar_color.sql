-- アイコンの色をやめる（マイグレーション②）。
-- まだ流さない。色を読まない版のアプリを出し、Remote Config の requiredVersion で
-- 古いアプリを止めてから、migrations/ に日時を付けて移して流す。

alter table public.profiles drop column avatar_color;
