-- ローカル開発用。make reset のたびに流れる。

-- 記録の通知を送る Edge Function の URL。DB のコンテナからは kong という名前で API に届く。
select vault.create_secret('http://kong:8000/functions/v1', 'functions_url');
