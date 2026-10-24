-- 招待コードを総当たりで当てられないようにする。
-- 直近24時間に10回間違えた人には、正しいコードでも見つからないと返す。

-- 招待コードを間違えた記録。
-- 読み書きは find_diary_book_by_code と join_diary_book からだけ。
create table public.invite_code_failures (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  failed_at timestamptz not null default now()
);
create index on public.invite_code_failures (user_id, failed_at);

alter table public.invite_code_failures enable row level security;
revoke all on public.invite_code_failures from anon, authenticated;

-- 直近24時間に10回以上間違えていれば true。
create function public.invite_code_locked() returns boolean
language sql stable security definer set search_path = ''
as $$
  select count(*) >= 10
  from public.invite_code_failures
  where user_id = (select auth.uid())
    and failed_at > now() - interval '24 hours';
$$;

-- 間違えたことを記録する。数えなくなった古い行はここで消す。
create function public.record_invite_code_failure() returns void
language plpgsql security definer set search_path = ''
as $$
begin
  delete from public.invite_code_failures
  where user_id = (select auth.uid())
    and failed_at <= now() - interval '24 hours';
  insert into public.invite_code_failures (user_id) values ((select auth.uid()));
end;
$$;

revoke execute on function public.invite_code_locked() from public, anon, authenticated;
revoke execute on function public.record_invite_code_failure() from public, anon, authenticated;

-- 招待コードを1つ作る。かぶるかどうかは使う側で確かめる。
-- 暗号用の乱数を使う。224（56 の 4 倍）以上のバイトは捨てて、どの文字も同じ確率で出るようにする。
create or replace function public.new_invite_code() returns text
language plpgsql volatile set search_path = ''
as $$
declare
  v_chars constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789';
  v_code text := '';
  v_byte int;
begin
  while length(v_code) < 7 loop
    v_byte := get_byte(extensions.gen_random_bytes(1), 0);
    if v_byte < 224 then
      v_code := v_code || substr(v_chars, 1 + v_byte % 56, 1);
    end if;
  end loop;
  return v_code;
end;
$$;

-- 招待コードの日記帳を、参加する前に見せるための情報。見つからなければ 0 行。
-- 間違えたら記録するので plpgsql にする。返す列は変えない。
drop function public.find_diary_book_by_code(text);

create function public.find_diary_book_by_code(p_code text)
returns table (
  id uuid,
  name text,
  cover_color bigint,
  member_limit smallint,
  member_names text[],
  member_avatar_colors bigint[],
  already_joined boolean
)
language plpgsql volatile security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    return;
  end if;

  -- 同時に試して10回を超えないように、同じ人の確認は1つずつ通す。
  perform pg_advisory_xact_lock(hashtext((select auth.uid())::text));
  if public.invite_code_locked() then
    return;
  end if;

  return query
  select
    b.id,
    b.name,
    b.cover_color,
    b.member_limit,
    array(
      select p.display_name
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at, m.user_id
    ),
    array(
      select p.avatar_color
      from public.diary_book_members m
      join public.profiles p on p.id = m.user_id
      where m.diary_book_id = b.id
      order by m.joined_at, m.user_id
    ),
    exists (
      select 1 from public.diary_book_members m
      where m.diary_book_id = b.id and m.user_id = (select auth.uid())
    )
  from public.diary_books b
  where b.invite_code = btrim(p_code);

  if not found then
    perform public.record_invite_code_failure();
  end if;
end;
$$;

revoke execute on function public.find_diary_book_by_code(text) from public, anon;
grant execute on function public.find_diary_book_by_code(text) to authenticated;

-- 招待コードで日記帳に参加する。コードが違えば null。もう参加していれば何もせずその id を返す。
-- 入れるのは日記帳の member_limit 人まで。間違えすぎている間は、正しいコードでも null。
create or replace function public.join_diary_book(p_code text)
returns uuid
language plpgsql security definer set search_path = ''
as $$
declare
  v_id uuid;
  v_member_limit smallint;
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  -- 同時に試して10回を超えないように、同じ人の参加は1つずつ通す。
  perform pg_advisory_xact_lock(hashtext((select auth.uid())::text));
  if public.invite_code_locked() then
    return null;
  end if;

  -- 同時に参加したり上限を変えたりして上限を超えないように、日記帳の行を押さえてから数える。
  select id, member_limit into v_id, v_member_limit from public.diary_books
  where invite_code = btrim(p_code)
  for update;
  if v_id is null then
    perform public.record_invite_code_failure();
    return null;
  end if;

  if not exists (
    select 1 from public.diary_book_members
    where diary_book_id = v_id and user_id = (select auth.uid())
  ) and (
    select count(*) from public.diary_book_members where diary_book_id = v_id
  ) >= v_member_limit then
    raise exception 'diary book is full';
  end if;

  insert into public.diary_book_members (diary_book_id, user_id)
  values (v_id, (select auth.uid()))
  on conflict do nothing;
  return v_id;
end;
$$;
