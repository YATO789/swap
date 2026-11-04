-- 記録と日記の通知の Edge Function（notify-post・notify-diary）を、Secret Key を持つトリガーからしか呼べないようにする。
-- 関数は verify_jwt = false のままにし、apikey ヘッダーの Secret Key を関数の中で確かめる。
--
-- Secret Key は Vault の notifications_secret_key に入れておく。
-- 環境ごとに違うので migration には書かない。ローカルは seed.sql で入れる。本番はダッシュボードの
-- API Keys で通知専用の Secret Key（notifications）を作り、SQL Editor で
--   select vault.create_secret('sb_secret_...', 'notifications_secret_key');
-- を一度流す。入っていなければ通知は送らず、記録も日記も書ける。

create or replace function public.notify_post() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
  v_secret_key text;
begin
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
    url := v_url || '/notify-post',
    body := jsonb_build_object('post_id', new.id),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'apikey', v_secret_key
    )
  );
  return null;
end;
$$;

create or replace function public.notify_diary() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
  v_secret_key text;
begin
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
    url := v_url || '/notify-diary',
    body := jsonb_build_object('diary_id', new.id),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'apikey', v_secret_key
    )
  );
  return null;
end;
$$;
