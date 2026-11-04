# swap

## プロトタイプ

`/Users/yato/Developer/flutter_apps/daylog_playground` はこのアプリのプロトタイプです。
仕様や実装方針を確認するときに参照してください。

## アーキテクチャ（native-app）

- 単純な CRUD など、Repository のメソッドを呼び出すだけの処理には UseCase を作らない。
- 1つのページでしか使わない部品は、そのページのディレクトリの `components/`（例: `lib/presentations/pages/home_page/components/`）に置く。
- 複数のページや部品から使う部品だけを `lib/presentations/components/` に置く。使う場所が1つになったらページの `components/` に移す。

## 本番の Supabase

- 本番では匿名サインインを有効にしていない（確認済み）。ローカルの `config.toml` の `enable_anonymous_sign_ins = true` と、アプリの kDebugMode 限定の匿名サインインボタンは開発用。本番で匿名サインインが有効になっていないか確かめるよう求めなくてよい。
