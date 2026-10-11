# swap

## プロトタイプ

`/Users/yato/Developer/flutter_apps/daylog_playground` はこのアプリのプロトタイプです。
仕様や実装方針を確認するときに参照してください。

## アーキテクチャ（native-app）

- 単純な CRUD など、Repository のメソッドを呼び出すだけの処理には UseCase を作らない。
- 複数の Repository をまたぐ処理や、複数の処理を組み合わせるアプリケーションロジックが必要な場合は UseCase を作る。
- 1つのページでしか使わない部品は、そのページのディレクトリの `components/`（例: `lib/screens/pages/home_page/components/`）に置く。
- 複数のページや部品から使う部品だけを `lib/screens/components/` に置く。使う場所が1つになったらページの `components/` に移す。
