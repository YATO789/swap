import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../../infrastructures/repositories/diary_repository.dart';
import '../../../../infrastructures/repositories/post_repository.dart';

part '_generated/diary_book_info_page_controller.freezed.dart';
part '_generated/diary_book_info_page_controller.g.dart';

/// 日記帳の情報ページに出す内容。
@freezed
abstract class DiaryBookInfoPageState with _$DiaryBookInfoPageState {
  const factory DiaryBookInfoPageState({
    /// 日記帳に参加している人。参加した順。
    required List<DiaryBookMember> members,

    /// 日記帳に出された記録の数。
    required int postCount,

    /// 日記帳に書かれた日記の数。
    required int diaryCount,
  }) = _DiaryBookInfoPageState;
}

/// 日記帳の情報ページで、[diaryBookId] の日記帳のメンバーと記録・日記の数を読み、
/// 名前や表紙の色を変えたり、招待コードを作り直したり、メンバーを外したり、日記帳から抜けたりする。
@riverpod
class DiaryBookInfoPageController extends _$DiaryBookInfoPageController {
  DiaryBookRepository get _diaryBookRepository =>
      ref.read(diaryBookRepositoryProvider.notifier);

  @override
  Future<DiaryBookInfoPageState> build(String diaryBookId) async {
    final (members, postCount, diaryCount) = await (
      _diaryBookRepository.fetchMembers(diaryBookId),
      ref.read(postRepositoryProvider).countInDiaryBook(diaryBookId),
      ref.read(diaryRepositoryProvider).countIn(diaryBookId),
    ).wait;
    return DiaryBookInfoPageState(
      members: members,
      postCount: postCount,
      diaryCount: diaryCount,
    );
  }

  /// 全部読み直す。読み直している間も、今の内容を出したままにする。
  Future<void> refresh() async {
    ref.invalidateSelf();
    try {
      await future;
    } catch (_) {
      // 失敗したことは状態に入り、画面に出る。
    }
  }

  /// 日記帳の名前を [name] にする。変えられたら true。
  Future<bool> rename(String name) {
    return _run(
      '名前を変えられませんでした',
      () => _diaryBookRepository.rename(diaryBookId, name),
    );
  }

  /// 表紙の色を [coverColor] にする。変えられたら true。
  Future<bool> setCoverColor(int? coverColor) {
    return _run(
      '表紙の色を変えられませんでした',
      () => _diaryBookRepository.setCoverColor(diaryBookId, coverColor),
    );
  }

  /// 招待コードを作り直す。作り直せたら true。
  Future<bool> regenerateInviteCode() {
    return _run(
      '招待コードを作り直せませんでした',
      () => _diaryBookRepository.regenerateInviteCode(diaryBookId),
    );
  }

  /// [userId] の人を日記帳から外す。招待コードも作り直される。外せたら true。
  Future<bool> removeMember(String userId) {
    return _run('メンバーを外せませんでした', () async {
      await _diaryBookRepository.removeMember(diaryBookId, userId);
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
    return _run(
      '日記帳から退出できませんでした',
      () => _diaryBookRepository.leave(diaryBookId),
    );
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
