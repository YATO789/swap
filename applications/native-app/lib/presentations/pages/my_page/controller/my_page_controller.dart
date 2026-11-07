import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/notification/notification_permission.dart';
import '../../../../infrastructures/repositories/notification_permission_repository.dart';
import '../../../providers/authentication_notifier.dart';
import '../../../providers/diary_reminder_notifier.dart';
import '../../../providers/settings_notifier.dart';

part '_generated/my_page_controller.g.dart';

/// マイページのログアウトとアカウント削除、日記のリマインダーの切り替えを受け持つ。
/// 状態はログアウトとアカウント削除の進み具合。
@riverpod
class MyPageController extends _$MyPageController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// ログアウトし、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> signOut() => _run(
    ref.read(authenticationProvider.notifier).signOut,
    failureLog: 'ログアウトできませんでした',
  );

  /// アカウントを消し、成功したかを返す。失敗したときは状態にエラーが入る。
  Future<bool> deleteAccount() => _run(
    ref.read(authenticationProvider.notifier).deleteAccount,
    failureLog: 'アカウントを削除できませんでした',
  );

  /// 日記のリマインダーを出すかを [enabled] にする。
  /// オンにしたときにまだ通知の許可を聞いていなければ聞き、聞いたあとの許可の状態を返す。
  /// オフにしたときと、許可の状態を確かめられなかったときは null を返す。
  Future<NotificationPermission?> saveDiaryReminderEnabled(bool enabled) async {
    await ref.read(settingsProvider.notifier).saveDiaryReminderEnabled(enabled);
    if (!enabled) return null;
    try {
      final permission = ref.read(notificationPermissionRepositoryProvider);
      if (await permission.fetch() == NotificationPermission.notDetermined) {
        await permission.request();
        // 設定を変えたときの合わせ直しは許可の前に済んでいるので、許可されたら予約し直す。
        await ref.read(diaryReminderProvider.notifier).sync();
      }
      return await permission.fetch();
    } on Object catch (e, stackTrace) {
      debugPrint('通知の許可を確かめられませんでした: $e\n$stackTrace');
      return null;
    }
  }

  Future<bool> _run(
    Future<void> Function() action, {
    required String failureLog,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(action);
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('$failureLog: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
