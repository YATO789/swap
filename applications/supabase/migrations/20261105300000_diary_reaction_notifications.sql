-- 日記にリアクションが付いたら、日記を書いた人に Edge Function（notify-diary-reaction）からプッシュ通知を送る。
-- 記録のリアクションの通知（20261105000000_reaction_notifications.sql）と同じく、
-- 送るのは新しく付けたとき（insert）だけで、付け替え（update）では送らず、1人が1つの日記に送るのは最初の1回だけにする。

-- 通知を送ったリアクション。同じリアクションで二度送らないように、Edge Function が送る前にここへ入れる。
-- リアクションを外すと diary_reactions の行は消えるが、ここは残したいので、外部キーは日記と人に向ける。
create table public.diary_reaction_notifications (
  diary_id uuid not null references public.diaries (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (diary_id, user_id)
);
create index on public.diary_reaction_notifications (user_id);

-- 読み書きは service role の Edge Function からだけ。
alter table public.diary_reaction_notifications enable row level security;

-- Edge Function の URL と Secret Key は、ほかの通知と同じ Vault の値を使う。
-- 入っていなければ通知は送らず、リアクションは付けられる。
-- もう送ったリアクションなら呼ばない（Edge Function でも確かめる）。
create function public.notify_diary_reaction() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
  v_secret_key text;
begin
  if exists (
    select 1 from public.diary_reaction_notifications
    where diary_id = new.diary_id
      and user_id = new.user_id
  ) then
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
    url := v_url || '/notify-diary-reaction',
    body := jsonb_build_object(
      'diary_id', new.diary_id,
      'user_id', new.user_id
    ),
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'apikey', v_secret_key
    )
  );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.notify_diary_reaction() from public, anon, authenticated;

create trigger notify_diary_reaction
after insert on public.diary_reactions
for each row execute function public.notify_diary_reaction();
