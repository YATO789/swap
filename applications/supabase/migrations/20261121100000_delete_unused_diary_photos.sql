-- どの日記からも指されなくなった日記の写真を、R2 から消す。
--
-- 1枚の写真を複数の日記が指す（1回書くと日記帳ごとに別の行になり、同じパスを持つ）ので、
-- 日記が消えたり写真を差し替えたりしても、ほかの日記がまだ指していれば残す。
-- 日記帳やアカウントを消したときも、日記は on delete cascade で消えるので、このトリガーが拾う。
--
-- 消すのは Edge Function（delete-diary-photos）。R2 の鍵は Edge Function だけが持つので、pg_net で呼ぶ。
-- 呼ぶときの Secret Key は通知と同じもの（Vault の notifications_secret_key）を使う。
-- 入っていなければ呼ばず、写真は R2 に残る。日記の書き換えや削除は止めない。

-- 「ほかにこの写真を指している日記があるか」を引けるようにする。
create index diaries_photo_path_idx on public.diaries (photo_path)
  where photo_path is not null;

create function public.delete_unused_diary_photos() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_paths text[];
  v_url text;
  v_secret_key text;
begin
  -- 文の終わりに呼ばれるので、同じ文で書き換えた・消したほかの日記も反映済みのものを見る。
  select array_agg(distinct old_rows.photo_path) into v_paths
  from old_rows
  where old_rows.photo_path is not null
    and not exists (
      select 1 from public.diaries
      where diaries.photo_path = old_rows.photo_path
    );
  if v_paths is null then
    return null;
  end if;

  select decrypted_secret into v_url
  from vault.decrypted_secrets
  where name = 'functions_url';
  select decrypted_secret into v_secret_key
  from vault.decrypted_secrets
  where name = 'notifications_secret_key';
  if v_url is null or v_secret_key is null then
    return null;
  end if;

  perform net.http_post(
    url := v_url || '/delete-diary-photos',
    body := jsonb_build_object('paths', to_jsonb(v_paths)),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'apikey', v_secret_key
    )
  );
  return null;
end;
$$;

-- 遷移テーブル（old_rows）を使うので、列を絞らず（update of photo_path にせず）文ごとに呼ぶ。
-- タイトルだけの書き換えでは、前の写真をまだ指しているので何もしない。
create trigger delete_unused_diary_photos_on_update
  after update on public.diaries
  referencing old table as old_rows
  for each statement execute function public.delete_unused_diary_photos();

create trigger delete_unused_diary_photos_on_delete
  after delete on public.diaries
  referencing old table as old_rows
  for each statement execute function public.delete_unused_diary_photos();
