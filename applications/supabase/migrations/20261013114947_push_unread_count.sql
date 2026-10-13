-- アプリのバッジに出す、まだ見ていない通知の数。端末ごとに数える。
-- 通知を送るたびに Edge Function（notify-post）が増やし、アプリを開いたら 0 に戻す。
alter table public.push_tokens add column unread_count integer not null default 0;

-- 持ち主が替わったら、前の人の未読数は引き継がない。
create or replace function public.register_push_token(p_token text) returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'not signed in';
  end if;

  insert into public.push_tokens (token, user_id)
  values (p_token, (select auth.uid()))
  on conflict (token) do update set
    user_id = excluded.user_id,
    updated_at = now(),
    unread_count = case
      when public.push_tokens.user_id = excluded.user_id then public.push_tokens.unread_count
      else 0
    end;
end;
$$;

-- 送る前に、送り先の端末の未読数を1つずつ増やし、増やしたあとの数を返す。
create function public.increment_push_unread_counts(p_tokens text[])
returns table (token text, unread_count integer)
language sql security definer set search_path = ''
as $$
  update public.push_tokens t
  set unread_count = t.unread_count + 1
  where t.token = any (p_tokens)
  returning t.token, t.unread_count;
$$;

-- 送るのは service role の Edge Function だけ。
revoke execute on function public.increment_push_unread_counts(text[]) from public, anon, authenticated;
grant execute on function public.increment_push_unread_counts(text[]) to service_role;

-- アプリを開いたら、この端末の未読数を 0 に戻す。
create function public.reset_push_unread_count(p_token text) returns void
language sql security definer set search_path = ''
as $$
  update public.push_tokens
  set unread_count = 0
  where token = p_token and user_id = (select auth.uid());
$$;

revoke execute on function public.reset_push_unread_count(text) from public, anon;
grant execute on function public.reset_push_unread_count(text) to authenticated;
