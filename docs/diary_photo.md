# 日記の写真（R2）

日記に写真を付けられるようにする。写真は Cloudflare R2 に置き、日記帳のメンバーにだけ見せる。
あとで記録（投稿）にも写真を付ける予定。

## いまの状況（2026-11-21）

サーバー側（DB の列と Edge Function）をローカルで作り、dev の R2 で動くのを確かめたところ。本番にはまだ出していない。アプリのコードはまだ何も書いていない。

- 2026-11-14: 画像の置き場所を R2 に決め、バケットを4つ作った（どれもまだ非公開）
- 2026-11-21: API トークンを dev 用と prod 用に作り、キーをローカルの `.env` と本番の Supabase に入れた
- 2026-11-21: `diaries.photo_path` のマイグレーションと Edge Function `diary-photo-url` を作り、ローカルで試した

## 決めたこと

### バケット

| バケット | 見せ方 | 入れるもの |
|---|---|---|
| `swap-dev-public` | 公開 | 開発用のアイコン画像 |
| `swap-dev-private` | 非公開 | 開発用の日記・記録の写真 |
| `swap-prod-public` | 公開 | 本番のアイコン画像（今の Supabase の `avatars` から移す） |
| `swap-prod-private` | 非公開 | 本番の日記の写真（あとで記録の写真も） |

- 名前の形は `{アプリ}-{環境}-{見せ方}`。環境は Firebase や flavor と同じ dev / prod
- 公開設定とトークンの権限はバケット単位なので、バケットは見せ方で分ける。中身の種類はフォルダで分ける（`avatars/`、`diaries/{ユーザーID}/`、`posts/` など）
- dev と prod は、開発中の事故で本番のデータを触らないように分ける
- 4つとも位置は自動（アジア太平洋）、ストレージクラスは Standard
- `public` の2つも、r2.dev の URL もカスタムドメインも付けず、今は非公開のまま

### 見せ方

- 日記1件に写真は1枚まで
- 日記は1回書くと、選んだ日記帳それぞれに別の行（別の日記 id）として入る。写真は1回だけ上げて、同じ内容の日記すべてが同じパスを指す。そのため写真は日記ではなく書いた人のフォルダ（`diaries/{ユーザーID}/`）に置く
- 大きさは `image_picker` で長い辺 1440px・JPEG の画質 80 に縮める（1枚 200〜400KB ほど）。iPhone の画面いっぱいに出してもぼやけない大きさ
- 写真はタイトルと同じく、日記帳のメンバー全員に見せる。本文のロック（自分も書いた日だけ読める）はかけない。参加する前に書かれた日記の写真は、日記と同じく見せない
- 写真は非公開バケットに置き、期限付きの URL（署名付き URL）で見せる。上げる URL は10分、見る URL は1時間で切れる
- アイコンは今と同じく公開 URL で見せる
- DB には URL ではなくパスだけを持つ。URL は Datasource で作る

### 期限付き URL を出すところ

Supabase の Edge Function（`diary-photo-url`）で出す。

- 「この日記帳のメンバーか」を、Supabase のログイン情報（JWT）と DB で今の仕組みのまま確かめられる
- Edge Function はもう通知で使っているので、デプロイや秘密の値の管理の仕方が今と同じ
- Cloudflare Workers にすると、Supabase の JWT を確かめる仕組みを新しく作ることになる
- Edge Function から R2 の S3 互換 API を使うので、API トークン（Access Key ID と Secret）が要る。Workers ならバケットを直接つなげるのでトークンは要らない

アプリには鍵を持たせない。

1. アプリが Edge Function に「この写真を上げたい」「この写真を見たい」と頼む
2. Edge Function がメンバーかどうかを確かめ、期限付きの URL を返す
3. アプリはその URL で R2 に直接アップロードしたり、写真を表示したりする

## やること

1. [x] R2 の API トークンを2つ作る（2026-11-21。Account API トークン、権限は「オブジェクト読み取りと書き込み」、無期限）
    - `swap-dev-edge-function`: `swap-dev-public` と `swap-dev-private` だけ
    - `swap-prod-edge-function`: `swap-prod-public` と `swap-prod-private` だけ
    - 使うのはアクセスキー ID とシークレットアクセスキー。「トークンの値」は使わない
2. [x] キーを Supabase の秘密の値に入れる（2026-11-21）
    - ローカル: `applications/supabase/functions/.env`（git の対象外）に dev 用
    - 本番: `supabase secrets set --project-ref styiotanfvyasefqbqcq --env-file <ファイル>` で prod 用
    - 変数は `R2_ACCOUNT_ID`、`R2_ACCESS_KEY_ID`、`R2_SECRET_ACCESS_KEY`、`R2_PUBLIC_BUCKET`、`R2_PRIVATE_BUCKET`
3. [x] 期限付き URL を出す Edge Function を作る（2026-11-21、ローカルのみ）
    - `applications/supabase/functions/diary-photo-url/index.ts`
    - 上げる: `{"action": "upload", "content_type"}` → `{"path", "url", "expires_in"}`。呼んだ人のフォルダに上げる URL を出す。どの日記に付けてよいかは、photo_path を書くときに diaries の RLS が決める
    - 見る: `{"action": "view", "diary_ids": [...]}` → `{"urls": {日記ID: URL}, "expires_in"}`。読めない日記は省く。一度に100件まで
    - 誰が何をしてよいかは、呼んだ本人のログイン情報で DB を読み、今の RLS に任せる
    - `verify_jwt = false` にして、関数の中で `auth.getUser()` でログインを確かめる
    - 署名は `npm:aws4fetch`
4. [x] DB に写真のパスの列を足す（2026-11-21、ローカルのみ）
    - `migrations/20261121000000_diary_photo.sql`: `diaries.photo_path`。`diaries/{書いた人の ID}/{UUID}.(jpg|png)` の形だけ許す（制約の名前は `diaries_check`）
    - 自分の今日か昨日の日記なら、アプリから直接書き換えられる（diaries の update ポリシー）
5. [ ] 本番に出す: `supabase db push` と `supabase functions deploy diary-photo-url`
6. [ ] アプリで日記に写真を付けてアップロードし、表示する
    - 流れ: upload で URL をもらう → `Content-Type` を付けてその URL に PUT → 日記を保存 → 保存した日記すべての `diaries.photo_path` に同じパスを書く
    - 表示: 一覧の日記の id をまとめて view に渡す。一度に100件までなので、超えるときは100件ずつに分けて頼む。キャッシュのキーは URL ではなくパスにする（URL は呼ぶたびに変わる）

## あとで決めること

- アップロードの大きさの上限。今の上げる URL は大きさを縛れない（aws4fetch は Content-Length に署名しない）。身内だけの間はアプリで縮めるだけにする
- 写真を差し替えた・外したとき、日記や日記帳・アカウントを消したときに、R2 の古い写真を消す方法（今は残る）。1枚を複数の日記が指すので、どの日記も指さなくなってから消す
- 写真をどの日記にも付けずに上げることもできる（upload は日記を見ない）。身内だけの間はそのままにする
- アイコンを Supabase の `avatars` から `swap-*-public` に移す時期と、公開バケットのカスタムドメイン
- 記録（投稿）にも写真を付ける時期
