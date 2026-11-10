-- 記録に1曲添えられるようにする。
-- 曲は iTunes Search API で探した曲のうち、表示と試聴に使うぶんだけを写して持つ。
-- あとで配信が止まっても表示が崩れないよう、名前や画像の URL も記録に書いておく。
-- 形は {"id", "title", "artist", "album", "duration_ms", "store_url", "artwork_url", "preview_url"}。
-- artwork_url と preview_url はないこともある。添えていなければ null。
-- キーがないと jsonb_typeof は null になり、チェック制約は null を通してしまうので、全体を coalesce で false にする。
alter table public.posts add column track jsonb check (
  track is null or coalesce(
    jsonb_typeof(track) = 'object'
    and jsonb_typeof(track -> 'id') = 'string'
    and jsonb_typeof(track -> 'title') = 'string'
    and jsonb_typeof(track -> 'artist') = 'string'
    and jsonb_typeof(track -> 'album') = 'string'
    and jsonb_typeof(track -> 'duration_ms') = 'number'
    -- Apple Music の曲のページ。
    and jsonb_typeof(track -> 'store_url') = 'string'
    -- なければ、キーごと省くか null にする。
    and coalesce(jsonb_typeof(track -> 'artwork_url'), 'null') in ('string', 'null')
    and coalesce(jsonb_typeof(track -> 'preview_url'), 'null') in ('string', 'null')
    -- 写すのは表示に使う短い文字だけなので、大きなものを入れられないようにする。
    and octet_length(track::text) <= 3000,
    false
  )
);

-- 曲も一緒に書けるようにする。p_track を省いた古いアプリからの呼び出しもそのまま通す。
drop function public.create_post(text, uuid[]);

create function public.create_post(
  p_message text,
  p_diary_book_ids uuid[],
  p_track jsonb default null
)
returns uuid
language plpgsql security invoker set search_path = ''
as $$
declare
  v_id uuid;
begin
  if coalesce(array_length(p_diary_book_ids, 1), 0) = 0 then
    raise exception 'no diary books';
  end if;

  insert into public.posts (message, track) values (p_message, p_track) returning id into v_id;
  insert into public.post_diary_books (post_id, diary_book_id)
  select v_id, unnest(p_diary_book_ids);
  return v_id;
end;
$$;

revoke execute on function public.create_post(text, uuid[], jsonb) from public, anon;
grant execute on function public.create_post(text, uuid[], jsonb) to authenticated;
