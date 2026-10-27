-- アイコンの画像。日記帳のメンバーにも見せる。
-- アイコンの色はやめるが、色を読む古いアプリのために avatar_color は残す。
-- 強制アップデートで古いアプリを止めてから、次のマイグレーションで消す。

-- 画像は公開バケットに置く。URL を受け取るのは profiles を読める同じ日記帳の人だけ。
-- 端末で 256px の JPEG（スクリーンショットなどは PNG）に縮めてから上げるので、1枚 10〜30KB ほど。
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('avatars', 'avatars', true, 524288, array['image/jpeg', 'image/png']);

-- 自分のフォルダ（{ユーザー ID}/）にだけ置ける。上書きはせず、上げるたびに名前を変える。
-- 見るのは公開 URL なので、読み取りは自分のフォルダだけ（消すときと、アカウント削除で一覧を取るときに使う）。
create policy "自分のアイコンの画像を読める" on storage.objects
for select to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "自分のアイコンの画像を置ける" on storage.objects
for insert to authenticated
with check (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

create policy "自分のアイコンの画像を消せる" on storage.objects
for delete to authenticated
using (
  bucket_id = 'avatars'
  and (storage.foldername(name))[1] = (select auth.uid())::text
);

-- avatars バケットの中のパス（{ユーザー ID}/{ミリ秒の時刻}.jpg）。null なら画像なし。
-- ほかのサーバーの URL やほかの人の画像を指せないように、自分のフォルダの中の形だけを許す。
alter table public.profiles
  add column avatar_path text
  check (avatar_path ~ ('^' || id::text || '/[0-9]+\.(jpg|png)$'));

-- 参加する前の画面でも、メンバーのアイコンの画像を出せるようにする。
-- 返す列が変わるので作り直す。member_avatar_paths は member_names と同じ順。
-- member_avatar_colors は外す。古いアプリは列がなくても動き、参加する画面のアイコンが決まった色になるだけ。
drop function public.find_diary_book_by_code(text);

create function public.find_diary_book_by_code(p_code text)
returns table (
  id uuid,
  name text,
  cover_color bigint,
  member_limit smallint,
  member_names text[],
  member_avatar_paths text[],
  already_joined boolean
)
language plpgsql volatile security definer set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    return;
  end if;

  -- 同時リクエストを制限する
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
      select p.avatar_path
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
