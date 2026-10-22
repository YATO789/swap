import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part '_generated/push_token_datasource.g.dart';

@riverpod
PushTokenDatasource pushTokenDatasource(Ref ref) {
  return PushTokenDatasource(Supabase.instance.client);
}

/// Supabase の push_tokens テーブルに、FCM トークンを自分の送り先として保存する。
class PushTokenDatasource {
  const PushTokenDatasource(this._client);

  final SupabaseClient _client;

  /// [token] を自分の送り先として保存する。
  Future<void> register(String token) async {
    await _client.rpc<void>(
      'register_push_token',
      params: {'p_token': token},
    );
  }

  /// [token] を自分の送り先から外す。
  Future<void> unregister(String token) async {
    await _client.rpc<void>(
      'unregister_push_token',
      params: {'p_token': token},
    );
  }

  /// [token] の端末の未読数を 0 に戻す。次の通知のバッジは 1 から数え直す。
  Future<void> resetUnreadCount(String token) async {
    await _client.rpc<void>(
      'reset_push_unread_count',
      params: {'p_token': token},
    );
  }
}
