# ローカルの Supabase を操作する。CLI はこのディレクトリの親を作業ディレクトリとして扱う。
SUPABASE := supabase --workdir ..

.PHONY: update start stop status

# config.toml などの変更を反映する。make だけで実行される。
update: stop start

start:
	$(SUPABASE) start

# データは残したまま止める。
stop:
	$(SUPABASE) stop

status:
	$(SUPABASE) status
