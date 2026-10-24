# swap

## プロトタイプ

`/Users/yato/Developer/flutter_apps/daylog_playground` はこのアプリのプロトタイプです。
仕様や実装方針を確認するときに参照してください。

## アーキテクチャ（native-app）

- 単純な CRUD など、Repository のメソッドを呼び出すだけの処理には UseCase を作らない。
- 1つのページでしか使わない部品は、そのページのディレクトリの `components/`（例: `lib/presentations/pages/home_page/components/`）に置く。
- 複数のページや部品から使う部品だけを `lib/presentations/components/` に置く。使う場所が1つになったらページの `components/` に移す。
