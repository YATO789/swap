-- 記録にコメントが付いたら、Edge Function（notify-comment）からプッシュ通知を送る。
-- 送る相手は、記録を書いた人と、その記録（日記帳ごと）にもうコメントした人。コメントした本人には送らない。
-- コメントは1件ごとに新しい内容なので、リアクションのように最初の1回に絞らず、書かれるたびに送る。

-- Edge Function の URL と Secret Key は、記録・日記・参加・リアクションの通知と同じ Vault の値を使う。
-- 入っていなければ通知は送らず、コメントは書ける。
create function public.notify_comment() returns trigger
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
    url := v_url || '/notify-comment',
    body := jsonb_build_object('comment_id', new.id),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'apikey', v_secret_key
    )
  );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.notify_comment() from public, anon, authenticated;

create trigger notify_comment
after insert on public.post_comments
for each row execute function public.notify_comment();
