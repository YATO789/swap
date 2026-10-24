import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domains/app_update/app_update.dart';
import '../../infrastructures/repositories/app_update_repository.dart';

part '_generated/app_update_notifier.g.dart';

/// アップデートを促すか。ルーターとホームが見る。
///
/// アプリを開いたときと、裏から戻ってきたときに確かめ直す。
@Riverpod(name: 'appUpdateProvider')
class AppUpdateNotifier extends _$AppUpdateNotifier {
  @override
  Future<AppUpdate> build() {
    final listener = AppLifecycleListener(onResume: ref.invalidateSelf);
    ref.onDispose(listener.dispose);
    return ref.read(appUpdateRepositoryProvider).fetch();
  }

  /// 促すだけの案内で「あとで」を押した。次に新しい案内を出すまで出さない。
  Future<void> skip() async {
    state = const AsyncData(AppUpdate.none);
    await ref.read(appUpdateRepositoryProvider).skip();
  }
}
