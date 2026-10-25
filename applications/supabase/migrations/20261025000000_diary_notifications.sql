-- 日記を書いたら、同じ日記帳の人に Edge Function（notify-diary）からプッシュ通知を送る。
-- 送るのはその日に初めて書いた（insert した）ときだけで、書き直し（update）では送らない。
-- save_diary の on conflict do update で書き直したときは、after insert のトリガーは動かない。

-- 通知を送った日記。同じ日記で二度送らないように、Edge Function が送る前にここへ入れる。
-- Edge Function は誰でも呼べるので、同じ日記の id で何度呼ばれても送るのは一度だけにする。
create table public.diary_notifications (
  diary_id uuid primary key references public.diaries (id) on delete cascade,
  created_at timestamptz not null default now()
);

-- 読み書きは service role の Edge Function からだけ。
alter table public.diary_notifications enable row level security;

-- Edge Function の URL は、記録の通知（notify_post）と同じ Vault の functions_url を使う。
-- 入っていなければ通知は送らず、日記は書ける。
-- Vault はアプリから読めないので、security definer にする。
create function public.notify_diary() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
begin
  select decrypted_secret into v_url
  from vault.decrypted_secrets
  where name = 'functions_url';
  if v_url is null then
    return null;
  end if;

  perform net.http_post(
    url := v_url || '/notify-diary',
    body := jsonb_build_object('diary_id', new.id),
    headers := '{"Content-Type": "application/json"}'::jsonb
  );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.notify_diary() from public, anon, authenticated;

create trigger notify_diary
after insert on public.diaries
for each row execute function public.notify_diary();
