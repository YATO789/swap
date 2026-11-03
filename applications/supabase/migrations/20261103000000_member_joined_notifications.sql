-- 日記帳に人が参加したら、もとからいるメンバーに Edge Function（notify-member-joined）からプッシュ通知を送る。
-- 抜けて入り直したときも送る。入り直すと joined_at が新しくなるので、参加ごとに別のものとして扱う。
-- もう参加している人がコードを入れ直しても、join_diary_book の on conflict do nothing で行が入らないので送らない。

-- 通知を送った参加。同じ参加で二度送らないように、Edge Function が送る前にここへ入れる。
-- 抜けると diary_book_members の行は消えるので、外部キーは日記帳と人に向ける。
create table public.member_join_notifications (
  diary_book_id uuid not null references public.diary_books (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  joined_at timestamptz not null,
  created_at timestamptz not null default now(),
  primary key (diary_book_id, user_id, joined_at)
);
create index on public.member_join_notifications (user_id);

-- 読み書きは service role の Edge Function からだけ。
alter table public.member_join_notifications enable row level security;

-- Edge Function の URL と Secret Key は、記録と日記の通知と同じ Vault の値を使う。
-- 入っていなければ通知は送らず、参加はできる。
-- 日記帳を作った人が入るときのように、ほかにメンバーがいなければ呼ばない。
create function public.notify_member_joined() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  v_url text;
  v_secret_key text;
begin
  if not exists (
    select 1 from public.diary_book_members
    where diary_book_id = new.diary_book_id and user_id <> new.user_id
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
    url := v_url || '/notify-member-joined',
    body := jsonb_build_object(
      'diary_book_id', new.diary_book_id,
      'user_id', new.user_id,
      'joined_at', new.joined_at
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
revoke execute on function public.notify_member_joined() from public, anon, authenticated;

create trigger notify_member_joined
after insert on public.diary_book_members
for each row execute function public.notify_member_joined();
