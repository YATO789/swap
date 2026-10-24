import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../providers/diary_book_notifier.dart';

part '_generated/diary_book_info_page_controller.freezed.dart';
part '_generated/diary_book_info_page_controller.g.dart';

/// 日記帳の情報ページに出す内容。
@freezed
abstract class DiaryBookInfoPageState with _$DiaryBookInfoPageState {
  const factory DiaryBookInfoPageState({
    /// 日記帳に参加している人。参加した順。
    required List<DiaryBookMember> members,
  }) = _DiaryBookInfoPageState;
}

/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーを読み、
/// 名前や表紙の色、人数の上限を変えたり、招待コードを作り直したり、メンバーを外したり、
/// 日記帳から抜けたりする。
@riverpod
class DiaryBookInfoPageController extends _$DiaryBookInfoPageController {
  DiaryBookNotifier get _diaryBooks =>
      ref.read(diaryBookProvider.notifier);

  @override
  Future<DiaryBookInfoPageState> build(String diaryBookId) async {
    final members = await ref
        .read(diaryBookRepositoryProvider)
        .fetchMembers(diaryBookId);
    return DiaryBookInfoPageState(members: members);
  }

  /// 全部読み直す。読み直している間も、今の内容を出したままにする。
  /// 人数の上限などほかの人が変えたことも映るよう、日記帳の一覧も読み直す。
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await (future, _diaryBooks.refresh()).wait;
    } catch (_) {
      // メンバーを読めなかったことは状態に入り、画面に出る。
      // 一覧を読めなかったときは、今の一覧を出したままにする。
    }
  }

  /// 日記帳の名前を [name] にする。変えられたら true。
  Future<bool> rename(String name) {
    return _run('名前を変えられませんでした', () => _diaryBooks.rename(diaryBookId, name));
  }

  /// 表紙の色を [coverColor] にする。変えられたら true。
  Future<bool> setCoverColor(int? coverColor) {
    return _run(
      '表紙の色を変えられませんでした',
      () => _diaryBooks.setCoverColor(diaryBookId, coverColor),
    );
  }

  /// 参加できる人数の上限を [memberLimit] 人にする。変えられたら true。
  Future<bool> setMemberLimit(int memberLimit) {
    return _run(
      '人数の上限を変えられませんでした',
      () => _diaryBooks.setMemberLimit(diaryBookId, memberLimit),
    );
  }

  /// 招待コードを作り直す。作り直せたら true。
  Future<bool> regenerateInviteCode() {
    return _run(
      '招待コードを作り直せませんでした',
      () => _diaryBooks.regenerateInviteCode(diaryBookId),
    );
  }

  /// [userId] の人を日記帳から外す。招待コードも作り直される。外せたら true。
  Future<bool> removeMember(String userId) {
    return _run('メンバーを外せませんでした', () async {
      await _diaryBooks.removeMember(diaryBookId, userId);
      final current = state.value;
      if (current == null) return;
      state = AsyncData(
        current.copyWith(
          members: [
            for (final member in current.members)
              if (member.userId != userId) member,
          ],
        ),
      );
    });
  }

  /// 日記帳から抜ける。抜けられたら true。
  Future<bool> leave() {
    return _run('日記帳から退出できませんでした', () => _diaryBooks.leave(diaryBookId));
  }

  Future<bool> _run(String failure, Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (error, stackTrace) {
      debugPrint('$failure: $error\n$stackTrace');
      return false;
    }
  }
}
