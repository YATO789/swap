-- 記録にリアクションが付いたら、記録を書いた人に Edge Function（notify-reaction）からプッシュ通知を送る。
-- 送るのは新しく付けたとき（insert）だけで、付け替え（update）では送らない。
-- 付けて外してを繰り返しても何度も届かないよう、1人が1つの記録（日記帳ごと）に送るのは最初の1回だけにする。

-- 通知を送ったリアクション。同じリアクションで二度送らないように、Edge Function が送る前にここへ入れる。
-- リアクションを外すと post_reactions の行は消えるが、ここは残したいので、外部キーは出し先と人に向ける。
create table public.reaction_notifications (
  post_id uuid not null,
  diary_book_id uuid not null,
  user_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, diary_book_id, user_id),
  foreign key (post_id, diary_book_id)
    references public.post_diary_books (post_id, diary_book_id) on delete cascade
);
create index on public.reaction_notifications (user_id);

-- 読み書きは service role の Edge Function からだけ。
alter table public.reaction_notifications enable row level security;

-- Edge Function の URL と Secret Key は、記録・日記・参加の通知と同じ Vault の値を使う。
-- 入っていなければ通知は送らず、リアクションは付けられる。
-- もう送ったリアクションなら呼ばない（Edge Function でも確かめる）。
create function public.notify_reaction() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
  v_secret_key text;
begin
  if exists (
    select 1 from public.reaction_notifications
    where post_id = new.post_id
      and diary_book_id = new.diary_book_id
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
    url := v_url || '/notify-reaction',
    body := jsonb_build_object(
      'post_id', new.post_id,
      'diary_book_id', new.diary_book_id,
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
revoke execute on function public.notify_reaction() from public, anon, authenticated;

create trigger notify_reaction
after insert on public.post_reactions
for each row execute function public.notify_reaction();
