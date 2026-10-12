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
