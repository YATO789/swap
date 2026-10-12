-- Swap! の最初のスキーマ。
-- 日記の日付（date）は、端末で「朝4時区切り」で計算した日付をそのまま入れる。
-- 書いた時刻（written_at・posted_at）は端末の時計を信じず、サーバーの now() にする。

-- テーブル --------------------------------------------------------------------

-- 表示名。ログインした Apple アカウント（auth.users）と 1対1。初回設定で作る。
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 15),
  created_at timestamptz not null default now()
);

create table public.diary_books (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 15),
  -- アイコンは名前の最初の1文字。アプリの runes.take(1) と同じくコードポイント単位。
  icon text generated always as (left(name, 1)) stored,
  -- 表紙の色（0xAARRGGBB）。int4 に収まらないので bigint。null なら決まったグレー。
  cover_color bigint check (cover_color between 0 and 4294967295),
  -- 大文字と小文字を区別する。読み間違えやすい 0/O/o・1/I/l は使わない。
  invite_code text not null unique check (invite_code ~ '^[A-HJ-NP-Za-kmnp-z2-9]{7}$'),
  created_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.diary_book_members (
  diary_book_id uuid not null references public.diary_books (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (diary_book_id, user_id)
);
create index on public.diary_book_members (user_id);

-- 記録（「今なにしてる」）。どの日記帳に出すかは post_diary_books に持つ。
create table public.posts (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  message text not null check (char_length(message) between 1 and 100),
  posted_at timestamptz not null default now()
);
create index on public.posts (author_id, posted_at);

create table public.post_diary_books (
  post_id uuid not null references public.posts (id) on delete cascade,
  diary_book_id uuid not null references public.diary_books (id) on delete cascade,
  primary key (post_id, diary_book_id)
);
create index on public.post_diary_books (diary_book_id);

-- 日記。日記帳と日付ごとに1人1つ。
-- 本文は diary_contents に分ける。ロック中でも「誰が何時に書いたか」は見せ、本文だけ伏せるため。
create table public.diaries (
  id uuid primary key default gen_random_uuid(),
  diary_book_id uuid not null references public.diary_books (id) on delete cascade,
  author_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  date date not null,
  -- 最初に書いた時刻。編集しても変わらない。
  written_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (author_id, diary_book_id, date)
);
create index on public.diaries (diary_book_id, date);

create table public.diary_contents (
  diary_id uuid primary key references public.diaries (id) on delete cascade,
  -- 空ならタイトルなし。
  title text not null default '' check (char_length(title) <= 40),
  body text not null check (char_length(body) between 1 and 1000)
);

-- ブロック。ブロックした人の記録と日記は見えなくなる（App Store ガイドライン 1.2）。
create table public.blocks (
  blocker_id uuid not null default auth.uid() references public.profiles (id) on delete cascade,
  blocked_id uuid not null references public.profiles (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id),
  check (blocker_id <> blocked_id)
);

-- 通報。運営が Supabase の管理画面で見る。アプリからは書くだけ。
create table public.reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid default auth.uid() references public.profiles (id) on delete set null,
  target_type text not null check (target_type in ('post', 'diary', 'user')),
  target_id uuid not null,
  reason text not null default '' check (char_length(reason) <= 500),
  created_at timestamptz not null default now()
);

-- RLS から使う判定 -------------------------------------------------------------
-- 同じテーブルを読むポリシーは無限に再帰するので、security definer の関数に切り出す。

create function public.is_member(p_diary_book_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.diary_book_members
    where diary_book_id = p_diary_book_id and user_id = (select auth.uid())
  );
$$;

-- [p_user_id] と同じ日記帳に入っているか。プロフィールを見せてよい相手。
create function public.shares_diary_book(p_user_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1
    from public.diary_book_members mine
    join public.diary_book_members theirs using (diary_book_id)
    where mine.user_id = (select auth.uid()) and theirs.user_id = p_user_id
  );
$$;

create function public.is_blocked(p_user_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.blocks
    where blocker_id = (select auth.uid()) and blocked_id = p_user_id
  );
$$;

-- 記録が、自分の入っている日記帳のどれかに出ているか。
create function public.is_post_visible(p_post_id uuid) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.post_diary_books
    where post_id = p_post_id and public.is_member(diary_book_id)
  );
$$;

-- 自分もその日記帳にその日の日記を書いたか。他の人の日記の本文を読めるかはこれで決まる。
create function public.wrote_diary_on(p_diary_book_id uuid, p_date date) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.diaries
    where diary_book_id = p_diary_book_id
      and date = p_date
      and author_id = (select auth.uid())
  );
$$;

-- 自分の日記を書いたり直したりできる日か。アプリでは今日と昨日（朝4時区切り）だけだが、
-- サーバーは端末のタイムゾーンを知らないので、UTC の日付から前後に余裕を持たせる。
create function public.is_editable_date(p_date date) returns boolean
language sql stable set search_path = ''
as $$
  select p_date between (now() at time zone 'utc')::date - 2
                    and (now() at time zone 'utc')::date + 1;
$$;

-- RLS ------------------------------------------------------------------------

alter table public.profiles enable row level security;
alter table public.diary_books enable row level security;
alter table public.diary_book_members enable row level security;
alter table public.posts enable row level security;
alter table public.post_diary_books enable row level security;
alter table public.diaries enable row level security;
alter table public.diary_contents enable row level security;
alter table public.blocks enable row level security;
alter table public.reports enable row level security;

create policy "同じ日記帳の人のプロフィールを読める" on public.profiles
for select to authenticated
using (id = (select auth.uid()) or public.shares_diary_book(id));

create policy "自分のプロフィールを作れる" on public.profiles
for insert to authenticated
with check (id = (select auth.uid()));

create policy "自分のプロフィールを直せる" on public.profiles
for update to authenticated
using (id = (select auth.uid()));

-- 日記帳の作成と参加は関数（create_diary_book・join_diary_book）からだけ。
create policy "参加している日記帳を読める" on public.diary_books
for select to authenticated
using (public.is_member(id));

create policy "参加している日記帳の名前と表紙を変えられる" on public.diary_books
for update to authenticated
using (public.is_member(id));

create policy "参加している日記帳のメンバーを読める" on public.diary_book_members
for select to authenticated
using (public.is_member(diary_book_id));

create policy "日記帳から抜けられる" on public.diary_book_members
for delete to authenticated
using (user_id = (select auth.uid()));

create policy "自分の記録と、日記帳に出ている記録を読める" on public.posts
for select to authenticated
using (
  author_id = (select auth.uid())
  or (public.is_post_visible(id) and not public.is_blocked(author_id))
);

create policy "自分の記録を書ける" on public.posts
for insert to authenticated
with check (author_id = (select auth.uid()));

create policy "自分の記録を消せる" on public.posts
for delete to authenticated
using (author_id = (select auth.uid()));

create policy "参加している日記帳の記録の出し先を読める" on public.post_diary_books
for select to authenticated
using (public.is_member(diary_book_id));

create policy "自分の記録を参加している日記帳に出せる" on public.post_diary_books
for insert to authenticated
with check (
  public.is_member(diary_book_id)
  and exists (
    select 1 from public.posts
    where id = post_id and author_id = (select auth.uid())
  )
);

create policy "参加している日記帳の日記を読める" on public.diaries
for select to authenticated
using (
  public.is_member(diary_book_id)
  and (author_id = (select auth.uid()) or not public.is_blocked(author_id))
);

create policy "今日か昨日の自分の日記を書ける" on public.diaries
for insert to authenticated
with check (
  author_id = (select auth.uid())
  and public.is_member(diary_book_id)
  and public.is_editable_date(date)
);

create policy "今日か昨日の自分の日記を直せる" on public.diaries
for update to authenticated
using (author_id = (select auth.uid()) and public.is_editable_date(date));

create policy "自分の日記を消せる" on public.diaries
for delete to authenticated
using (author_id = (select auth.uid()));

-- diaries の select ポリシーも効くので、参加していない日記帳やブロックした人の本文は読めない。
create policy "自分も書いた日の日記の本文を読める" on public.diary_contents
for select to authenticated
using (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id
      and (
        d.author_id = (select auth.uid())
        or public.wrote_diary_on(d.diary_book_id, d.date)
      )
  )
);

create policy "今日か昨日の自分の日記の本文を書ける" on public.diary_contents
for insert to authenticated
with check (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id
      and d.author_id = (select auth.uid())
      and public.is_editable_date(d.date)
  )
);

create policy "今日か昨日の自分の日記の本文を直せる" on public.diary_contents
for update to authenticated
using (
  exists (
    select 1 from public.diaries d
    where d.id = diary_id
      and d.author_id = (select auth.uid())
      and public.is_editable_date(d.date)
  )
);

create policy "自分のブロックを読める" on public.blocks
for select to authenticated
using (blocker_id = (select auth.uid()));

create policy "ブロックできる" on public.blocks
for insert to authenticated
with check (blocker_id = (select auth.uid()));

create policy "ブロックを外せる" on public.blocks
for delete to authenticated
using (blocker_id = (select auth.uid()));

create policy "通報できる" on public.reports
for insert to authenticated
with check (reporter_id = (select auth.uid()));

-- 変えてよい列だけ更新を許す ----------------------------------------------------
-- 招待コード・作者・日付・書いた時刻は、ポリシーを通っても書き換えさせない。

revoke update on public.diary_books from anon, authenticated;
grant update (name, cover_color) on public.diary_books to authenticated;

revoke update on public.diaries from anon, authenticated;
grant update (updated_at) on public.diaries to authenticated;

revoke update on public.diary_contents from anon, authenticated;
grant update (title, body) on public.diary_contents to authenticated;

revoke update on public.posts, public.post_diary_books, public.diary_book_members
  from anon, authenticated;

-- アプリから呼ぶ関数 -----------------------------------------------------------

-- 日記帳を作って参加する。招待コードはかぶらないものを作る。
create function public.create_diary_book(p_name text, p_cover_color bigint default null)
returns public.diary_books
language plpgsql security definer set search_path = ''
as $$
declare
  v_chars constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789';
  v_code text;
  v_diary_book public.diary_books;
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  loop
    v_code := '';
    for i in 1..7 loop
      v_code := v_code || substr(v_chars, 1 + floor(random() * length(v_chars))::int, 1);
    end loop;
    begin
      insert into public.diary_books (name, cover_color, invite_code, created_by)
      values (btrim(p_name), p_cover_color, v_code, (select auth.uid()))
      returning * into v_diary_book;
      exit;
    exception when unique_violation then
      -- 招待コードがかぶったら作り直す。
    end;
  end loop;

  insert into public.diary_book_members (diary_book_id, user_id)
  values (v_diary_book.id, (select auth.uid()));
  return v_diary_book;
end;
$$;

-- 招待コードの日記帳を、参加する前に見せるための情報。見つからなければ 0 行。
create function public.find_diary_book_by_code(p_code text)
returns table (
  id uuid,
  name text,
  icon text,
  cover_color bigint,
  member_names text[],
  already_joined boolean
)
language sql stable security definer set search_path = ''
as $$
  select
    b.id,
    b.name,
    b.icon,
    b.cover_color,
    array(
      select p.display_name
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at
    ),
    exists (
      select 1 from public.diary_book_members m
      where m.diary_book_id = b.id and m.user_id = (select auth.uid())
    )
  from public.diary_books b
  where b.invite_code = btrim(p_code)
    and (select auth.uid()) is not null;
$$;

-- 招待コードで日記帳に参加する。コードが違えば null。もう参加していれば何もせずその id を返す。
create function public.join_diary_book(p_code text)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_id uuid;
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  select id into v_id from public.diary_books
  where invite_code = btrim(p_code);
  if v_id is null then
    return null;
  end if;

  insert into public.diary_book_members (diary_book_id, user_id)
  values (v_id, (select auth.uid()))
  on conflict do nothing;
  return v_id;
end;
$$;

-- 記録を書いて、選んだ日記帳に出す。RLS はそのまま効く。
create function public.create_post(p_message text, p_diary_book_ids uuid[])
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_id uuid;
begin
  if coalesce(array_length(p_diary_book_ids, 1), 0) = 0 then
    raise exception 'no diary books';
  end if;

  insert into public.posts (message) values (p_message) returning id into v_id;
  insert into public.post_diary_books (post_id, diary_book_id)
  select v_id, unnest(p_diary_book_ids);
  return v_id;
end;
$$;

-- 自分の日記を書く。もう書いていればタイトルと本文を書き換える（書いた時刻は変えない）。
create function public.save_diary(
  p_diary_book_id uuid,
  p_date date,
  p_title text,
  p_body text
)
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_id uuid;
begin
  insert into public.diaries (diary_book_id, date)
  values (p_diary_book_id, p_date)
  on conflict (author_id, diary_book_id, date) do update set updated_at = now()
  returning id into v_id;

  insert into public.diary_contents (diary_id, title, body)
  values (v_id, p_title, p_body)
  on conflict (diary_id) do update set title = excluded.title, body = excluded.body;
  return v_id;
end;
$$;

-- 関数はログインした人だけが呼べるようにする。
revoke execute on all functions in schema public from public, anon;
grant execute on all functions in schema public to authenticated;

-- トリガー ----------------------------------------------------------------------

-- 最後の1人が抜けて誰もいなくなった日記帳を消す。日記・本文・記録の出し先も一緒に消える。
-- 残しておくと、招待コードを知っている人が参加して前のメンバーの日記を読めてしまう。
-- 抜けた本人はもう RLS で日記帳を消せないので、security definer にする。
create function public.delete_empty_diary_book() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  -- 最後の2人が同時に抜けると、お互いに相手がまだいると見て、どちらも消さないことがある。
  -- 日記帳の行を先に押さえ、後から来た方が先の退出を見てから数えるようにする。
  perform 1 from public.diary_books where id = old.diary_book_id for update;

  delete from public.diary_books b
  where b.id = old.diary_book_id
    and not exists (
      select 1 from public.diary_book_members m
      where m.diary_book_id = old.diary_book_id
    );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.delete_empty_diary_book() from public, anon, authenticated;

create trigger delete_empty_diary_book
after delete on public.diary_book_members
for each row execute function public.delete_empty_diary_book();

-- アカウント削除 ----------------------------------------------------------------

-- 自分のアカウントを消す（App Store ガイドライン 5.1.1(v)）。
-- auth.users を消すと、プロフィール・参加・記録・日記・ブロックが on delete cascade で消え、
-- 誰もいなくなった日記帳も delete_empty_diary_book トリガーで消える。通報は送った人だけ空になる。
-- auth.users はアプリから触れないので、security definer にする。
create function public.delete_account() returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  delete from auth.users where id = (select auth.uid());
end;
$$;

revoke execute on function public.delete_account() from public, anon;
grant execute on function public.delete_account() to authenticated;

-- プッシュ通知 ------------------------------------------------------------------

-- プッシュ通知の送り先。端末の FCM トークンと、その端末でサインインしている人。
-- 1人が複数の端末を持てるので、トークンを主キーにする。
-- 同じ端末で別のアカウントに入り直すと、同じトークンの持ち主が替わる。
create table public.push_tokens (
  token text primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  updated_at timestamptz not null default now()
);
create index on public.push_tokens (user_id);

-- 読み書きは register_push_token からだけ。送るのは service role の Edge Function。
alter table public.push_tokens enable row level security;

-- 端末のトークンを自分の送り先にする。前に別の人が使っていたトークンなら持ち主を替える。
-- 他の人の行を書き換えるので、security definer にする。
create function public.register_push_token(p_token text) returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  insert into public.push_tokens (token, user_id)
  values (p_token, (select auth.uid()))
  on conflict (token) do update set user_id = excluded.user_id, updated_at = now();
end;
$$;

revoke execute on function public.register_push_token(text) from public, anon;
grant execute on function public.register_push_token(text) to authenticated;

-- 記録の通知 --------------------------------------------------------------------

-- 記録を書いたら、同じ日記帳の人に Edge Function（notify-post）からプッシュ通知を送る。
-- pg_net のリクエストはコミットしてから送られるので、Edge Function からは
-- create_post で一緒に入れた post_diary_books も見える。書き込みが失敗すれば送られない。
create extension if not exists pg_net with schema extensions;

-- 通知を送った記録。同じ記録で二度送らないように、Edge Function が送る前にここへ入れる。
-- Edge Function は誰でも呼べるので、同じ記録の id で何度呼ばれても送るのは一度だけにする。
create table public.post_notifications (
  post_id uuid primary key references public.posts (id) on delete cascade,
  created_at timestamptz not null default now()
);

-- 読み書きは service role の Edge Function からだけ。
alter table public.post_notifications enable row level security;

-- Edge Function の URL（末尾の /functions/v1 まで）は Vault の functions_url に入れておく。
-- 環境ごとに違うので migration には書かない。ローカルは seed.sql で入れる。本番は SQL Editor で
--   select vault.create_secret('https://<project-ref>.supabase.co/functions/v1', 'functions_url');
-- を一度流す。入っていなければ通知は送らず、記録は書ける。
-- Vault はアプリから読めないので、security definer にする。
create function public.notify_post() returns trigger
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
    url := v_url || '/notify-post',
    body := jsonb_build_object('post_id', new.id),
    headers := '{"Content-Type": "application/json"}'::jsonb
  );
  return null;
end;
$$;

-- トリガー専用なので、アプリからは呼ばせない。
revoke execute on function public.notify_post() from public, anon, authenticated;

create trigger notify_post
after insert on public.posts
for each row execute function public.notify_post();
