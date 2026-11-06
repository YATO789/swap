import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../infrastructures/repositories/push_token_repository.dart';
import '../../../providers/app_update_notifier.dart';
import '../../../providers/diary_book_notifier.dart';
import '../../../providers/push_token_notifier.dart';

part '_generated/home_page_controller.g.dart';

/// ホームの処理を受け持つ。状態は一覧を読み直す進み具合。
@riverpod
class HomePageController extends _$HomePageController {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  /// 通知の未読数を 0 に戻す。失敗しても画面には出さない。
  Future<void> resetUnreadCount() {
    return ref.read(pushTokenProvider.notifier).resetUnreadCount();
  }

  /// 通知の許可を聞く。オンボーディングを通らずに来た端末（別の端末でサインインし直したときなど）のため。
  /// オンボーディングで「あとで」を押した端末では聞かない。答えたことがあれば何も出ない。
  /// 失敗しても画面には出さない。
  Future<void> requestNotificationPermission() async {
    try {
      final pushTokens = ref.read(pushTokenRepositoryProvider);
      if (pushTokens.permissionSkipped) return;
      await pushTokens.requestPermission();
    } on Object catch (e, stackTrace) {
      debugPrint('通知の許可を聞けませんでした: $e\n$stackTrace');
    }
  }

  /// 日記帳の一覧を読み直す。ほかの人が変えた名前や表紙を映す。
  /// 読み直せなかったら false を返し、状態にエラーが入る。
  Future<bool> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(diaryBookProvider.notifier).refresh(),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('日記帳を読み直せませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }

  /// 知らせた新しいバージョンを、アップデートせずに見送る。
  Future<void> skipUpdate() {
    return ref.read(appUpdateProvider.notifier).skip();
  }
}
