import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../infrastructures/repositories/diary_reminder_repository.dart';
import '../../l10n/l10n.dart';
import '../../usecases/sync_diary_reminder_usecase.dart';
import 'authentication_notifier.dart';
import 'settings_notifier.dart';

part '_generated/diary_reminder_notifier.g.dart';

/// 合わせ直しを順番に行うための、前の合わせ直し。
/// 重なると、古い判断で予約したものが後から残ることがあるので、一つずつ行う。
/// 作り直されたノーティファイアーの間でも共有したいので、ファイルに置く。
Future<void> _running = Future.value();

/// サインインしている間、日記のリマインダーの予約を設定と今日の日記に合わせておく。
///
/// 開いたとき、裏から戻ってきたとき、設定を変えたときに合わせ直す。日記を書いたり消したりしたら [sync] を呼ぶ。
/// サインアウトしたら予約を取り消し、前のアカウントのリマインダーが出ないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
@Riverpod(keepAlive: true, name: 'diaryReminderProvider')
class DiaryReminderNotifier extends _$DiaryReminderNotifier {
  @override
  Future<void> build() async {
    final signedIn = ref.watch(authenticationProvider).isSignedIn;
    ref.watch(
      settingsProvider.select((settings) => settings.diaryReminderEnabled),
    );
    ref.watch(
      settingsProvider.select((settings) => settings.diaryReminderTime),
    );

    if (!signedIn) {
      final repository = ref.read(diaryReminderRepositoryProvider);
      await _enqueue(repository.cancelAll);
      return;
    }

    final listener = AppLifecycleListener(onResume: sync);
    ref.onDispose(listener.dispose);
    await sync();
  }

  /// 予約を今の設定と今日の日記に合わせ直す。失敗しても画面には出さない。
  /// 日記を書いたあとなどに呼ばれるので、ここで失敗しても呼んだ側の処理は止めない。
  Future<void> sync() async {
    if (!ref.mounted) return;
    try {
      final settings = ref.read(settingsProvider);
      final useCase = ref.read(syncDiaryReminderUseCaseProvider);
      await _enqueue(() {
        return useCase(
          enabled: settings.diaryReminderEnabled,
          time: settings.diaryReminderTime,
          body: _localizations().diaryReminderBody,
        );
      });
    } on Object catch (e, stackTrace) {
      _logFailure(e, stackTrace);
    }
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final next = _running.then((_) async {
      try {
        await action();
      } on Object catch (e, stackTrace) {
        _logFailure(e, stackTrace);
      }
    });
    _running = next;
    return next;
  }

  void _logFailure(Object error, StackTrace stackTrace) {
    debugPrint('日記のリマインダーを予約し直せませんでした: $error\n$stackTrace');
  }

  /// 端末の言語に合わせた文言。画面の外で使うので、端末の言語から選ぶ。
  AppLocalizations _localizations() {
    final locale = basicLocaleListResolution(
      PlatformDispatcher.instance.locales,
      AppLocalizations.supportedLocales,
    );
    return lookupAppLocalizations(locale);
  }
}
