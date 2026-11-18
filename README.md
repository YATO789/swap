https://github.com/user-attachments/assets/07f7ffa3-82de-4944-9df2-7fdaf28cf141


# Swap!

**少人数で回す、交換日記アプリ。**
家族や親しい友だちと「日記帳」を共有し、その日のひとことや1日の終わりの日記を見せ合います。

[![App Store](https://img.shields.io/badge/App_Store-iOS-000000?logo=apple)](https://apps.apple.com/app/id6823869046)
![Flutter](https://img.shields.io/badge/Flutter-Dart_3-02569B?logo=flutter)
![Supabase](https://img.shields.io/badge/Supabase-Postgres_%2B_Edge_Functions-3FCF8E?logo=supabase)
![Firebase](https://img.shields.io/badge/Firebase-FCM_%2F_Remote_Config-FFCA28?logo=firebase)

---

## 目次

- [主な機能](#主な機能)
- [技術スタック](#技術スタック)
- [アプリのアーキテクチャ](#アプリのアーキテクチャ)
- [ディレクトリ構成](#ディレクトリ構成)
- [こだわったところ](#こだわったところ)
- [開発環境の立ち上げ](#開発環境の立ち上げ)

---

## 主な機能

| 機能 | 内容 |
|---|---|
| **日記帳** | 最大 8 人で1冊を共有します。7 文字の招待コードで参加し、作った人は人数の上限やメンバーを管理できます |
| **記録（ひとこと）** | 100 文字までの「今なにしてる」を、複数の日記帳へまとめて投稿できます。iTunes の曲を添えると試聴できます |
| **日記** | 1日1つ、日記帳ごとに書きます。**自分がその日の日記を書くまで、ほかの人の本文は読めません**（交換日記らしさ） |
| **リアクション・コメント** | 記録と日記に絵文字でリアクションでき、記録にはコメントも付けられます |
| **表紙の飾り** | 絵文字・文字・らくがきで日記帳の表紙を自由に飾れます（元に戻す・重なり順の入れ替えに対応） |
| **ページめくり** | 日記帳のページは、自作の GLSL シェーダーで紙のように丸めてめくれます |
| **通知** | 投稿・日記・参加・リアクション・コメントをプッシュ通知で届けます。日記を書く時刻のリマインダーも設定できます |
| **その他** | Sign in with Apple、プロフィール画像、ダークモード、日本語と英語、アップデートの案内（Remote Config） |

---

## 技術スタック

| 領域 | 使っているもの |
|---|---|
| アプリ | Flutter / Dart 3（FVM でバージョンを固定） |
| 状態管理 | Riverpod 3（`riverpod_generator`）+ flutter_hooks |
| ルーティング | go_router + go_router_builder（型安全なルート） |
| モデル | freezed / json_serializable |
| バックエンド | Supabase（PostgreSQL・Auth・Storage・Edge Functions〈Deno〉） |
| 認証 | Sign in with Apple（Supabase Auth） |
| 通知 | Firebase Cloud Messaging（HTTP v1）+ flutter_local_notifications |
| 配信の制御 | Firebase Remote Config（強制アップデートとリリースノート） |
| 描画 | Fragment Shader（GLSL）/ CustomPaint |
| 外部 API | iTunes Search API・Apple Music RSS（曲の検索と試聴） |

---

## アプリのアーキテクチャ

レイヤーを分けた構成で、依存は外側から内側への一方向です。

| レイヤー | 役割 | 例 |
|---|---|---|
| `domains` | 外部に依存しないモデルと業務ルール。freezed で不変にしています | `Diary.isLocked`、`diaryDateOf()`（朝4時で日付を区切る） |
| `infrastructures/datasources` | 外部サービスとの通信だけを受け持ち、API の形のまま（`*Response`）返します | `DiaryBookDatasource`、`ItunesDatasource` |
| `infrastructures/repositories` | Datasource の結果をドメインモデルに変えます。画面は API の形を知りません | `DiaryBookRepository` |
| `usecases` | 複数の Repository をまたぐ処理や、判断を含む処理だけを置きます | `UpdateDiaryBookCoverUseCase`（変わった項目だけを送る） |
| `presentations` | 画面と、画面ごとの状態を持つ Controller（`AsyncNotifier`） | `DiaryBookPageController` |

### 設計のルール

- **UseCase は必要なときだけ作る。** Repository を呼ぶだけの CRUD に UseCase を挟まず、Controller から Repository を直接呼びます。層を形式的に増やさず、ロジックがある所にだけ置きます。
- **部品は使う場所の近くに置く。** 1つのページでしか使わない部品は `pages/<page>/components/` に、複数で使う部品だけを `presentations/components/` に置きます。使う場所が1つに減ったら戻します。
- **依存は Riverpod の Provider で注入する。** Datasource から Controller まで、すべて `@riverpod` で組み立てます。テストでは Provider を差し替えるだけで Supabase を使わずに動かせます。
- **生成コードは `_generated/` にまとめる。** `build.yaml` で出力先を分け、手書きのコードと混ざらないようにしています。

---

## ディレクトリ構成

```text
swap/
├── applications/
│   ├── native-app/                # Flutter アプリ
│   │   ├── lib/
│   │   │   ├── main.dart          # Firebase・Supabase の初期化、flavor の切り替え
│   │   │   ├── domains/           # ドメインモデル（diary / diary_book / post / reaction / profile ...）
│   │   │   ├── usecases/          # 複数の Repository をまたぐ処理
│   │   │   ├── infrastructures/
│   │   │   │   ├── datasources/   # supabase / firebase / itunes / google_form / platform / stores
│   │   │   │   └── repositories/  # Response → ドメインモデル
│   │   │   ├── presentations/
│   │   │   │   ├── pages/         # 画面ごとに page・controller/・components/
│   │   │   │   ├── components/    # 複数の画面で使う部品
│   │   │   │   └── providers/     # アプリ全体で共有する状態（認証・設定・試聴など）
│   │   │   ├── l10n/              # ARB（日本語・英語）と生成された AppLocalizations
│   │   │   ├── theme/             # ライト・ダークのテーマと文字のスタイル
│   │   │   └── utils/
│   │   ├── shaders/page_curl.frag # ページめくりのフラグメントシェーダー
│   │   ├── test/                  # lib と同じ構成のユニット・ウィジェットテスト
│   │   ├── config/                # --dart-define-from-file で渡す環境ごとの設定
│   │   ├── ios/  android/         # dev / prod の flavor
│   │   └── pubspec.yaml
│   └── supabase/
│       ├── migrations/            # スキーマ・RLS・RPC・トリガー（時系列）
│       ├── functions/             # Edge Functions（Deno / TypeScript）
│       │   ├── _shared/push.ts    # FCM 送信と Secret Key の検証
│       │   └── notify-*/          # 通知の種類ごとの関数
│       ├── seed.sql               # ローカル開発用のデータ
│       ├── config.toml
│       └── Makefile               # make start / stop / reset
└── docs/                          # 機能ごとの仕様書（表紙の飾り・プロフィール画像）
```

画面のディレクトリは、どの画面も同じ形にそろえています。

```text
pages/diary_book_page/
├── diary_book_page.dart           # 画面（HookConsumerWidget）
├── controller/
│   └── diary_book_page_controller.dart   # 状態と操作（AsyncNotifier）
└── components/                    # この画面でしか使わない部品
    ├── timeline_view.dart
    ├── diary_section.dart
    └── ...
```

---

## こだわったところ

### ページめくりのシェーダー
日記帳をめくる動きは、`shaders/page_curl.frag` で描いています。折れ目から右側を筒に巻き付け、半周したところから先は裏返して重ねます。裏には表の中身を左右反転でうっすら透かし、下のページには影を落としています。ウィジェットを画像にしてシェーダーに渡すので、ページの中身は普通の Flutter のウィジェットのまま書けます。

### 表紙の飾りのデータ設計
絵文字・文字・らくがきを JSON にバージョン（`v`）付きで保存しています。古いアプリが新しい形式の飾りを壊さないようにしています。保存するときは**変わった項目だけ**を送るので、ほかのメンバーが同時に表紙の色を変えても上書きしません（`UpdateDiaryBookCoverUseCase`）。詳しくは [`docs/cover_decoration.md`](docs/cover_decoration.md) にあります。

### 「1日」の区切り
夜更かしして書いた日記が翌日扱いにならないよう、日付は**朝4時**で区切っています（`diaryDateOf()`）。サーバーは端末のタイムゾーンを知らないため、編集できる日付は UTC の前後に余裕を持たせて判定しています。

### ストレージを節約するプロフィール画像
画像は長い辺 256px・JPEG 品質 75 に縮めて、1人 10〜30KB に抑えています。上書きせず毎回ファイル名を変えるので、CDN のキャッシュを1年にしても古い画像が残りません。詳しくは [`docs/profile_image.md`](docs/profile_image.md) にあります。

### 仕様を先に書く
大きめの機能は、先に `docs/` に仕様（上限の数・保存のタイミング・競合したときの扱い・表示する場所）を書いてから実装しています。

---

## 開発環境の立ち上げ

### 必要なもの
- [FVM](https://fvm.app/)（Flutter のバージョンは `.fvmrc` で固定しています）
- [Supabase CLI](https://supabase.com/docs/guides/cli) と Docker
- Xcode（iOS）

### 1. ローカルの Supabase を起動する

```bash
cd applications/supabase
make start      # 起動
make reset      # migrations と seed.sql から DB を作り直す
```

プッシュ通知も試す場合は、`functions/.env` に Firebase のサービスアカウントの JSON を `FIREBASE_SERVICE_ACCOUNT='...'` として1行で書いておきます。

### 2. アプリを起動する

```bash
cd applications/native-app
fvm flutter pub get
fvm dart run build_runner build -d
fvm flutter run --flavor dev \
  --dart-define-from-file=config/debug.json \
  --dart-define=SUPABASE_URL=http://127.0.0.1:54321 \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<supabase status で出る publishable key>
```

VS Code を使う場合は、`.vscode/launch.json` の「Local-iOS」「Local-Android」から起動できます。

### 本番向けのビルド
`config/prod.example.json` を `config/prod.json` に写して本番の値を入れ、`--flavor prod --dart-define-from-file=config/prod.json` でビルドします（`config/prod.json` は Git に入れません）。

### ブランチ運用
開発は `develop` で進め、リリースのときに `develop` → `main` のプルリクエストをマージし、`vX.Y.Z` のタグを付けます。
