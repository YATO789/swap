// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../diary_reminder_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// サインインしている間、日記のリマインダーの予約を設定と今日の日記に合わせておく。
///
/// 開いたとき、裏から戻ってきたとき、設定を変えたときに合わせ直す。日記を書いたり消したりしたら [sync] を呼ぶ。
/// サインアウトしたら予約を取り消し、前のアカウントのリマインダーが出ないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

@ProviderFor(DiaryReminderNotifier)
final diaryReminderProvider = DiaryReminderNotifierProvider._();

/// サインインしている間、日記のリマインダーの予約を設定と今日の日記に合わせておく。
///
/// 開いたとき、裏から戻ってきたとき、設定を変えたときに合わせ直す。日記を書いたり消したりしたら [sync] を呼ぶ。
/// サインアウトしたら予約を取り消し、前のアカウントのリマインダーが出ないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。
final class DiaryReminderNotifierProvider
    extends $AsyncNotifierProvider<DiaryReminderNotifier, void> {
  /// サインインしている間、日記のリマインダーの予約を設定と今日の日記に合わせておく。
  ///
  /// 開いたとき、裏から戻ってきたとき、設定を変えたときに合わせ直す。日記を書いたり消したりしたら [sync] を呼ぶ。
  /// サインアウトしたら予約を取り消し、前のアカウントのリマインダーが出ないようにする。
  /// サインイン状態を追い続けるので、一度読んだら破棄しない。
  DiaryReminderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diaryReminderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diaryReminderNotifierHash();

  @$internal
  @override
  DiaryReminderNotifier create() => DiaryReminderNotifier();
}

String _$diaryReminderNotifierHash() =>
    r'd5f8fd8916073a1b55ebac6f5380b0c7a22de7e9';

/// サインインしている間、日記のリマインダーの予約を設定と今日の日記に合わせておく。
///
/// 開いたとき、裏から戻ってきたとき、設定を変えたときに合わせ直す。日記を書いたり消したりしたら [sync] を呼ぶ。
/// サインアウトしたら予約を取り消し、前のアカウントのリマインダーが出ないようにする。
/// サインイン状態を追い続けるので、一度読んだら破棄しない。

abstract class _$DiaryReminderNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
