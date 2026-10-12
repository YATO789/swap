import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/diary_book/invited_diary_book.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/infrastructures/repositories/push_token_repository.dart';

/// Supabase につながず、サインインすると少し待ってからサインイン済みになる。
class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository({this.initial = const Authentication()});

  final Authentication initial;

  @override
  Authentication build() => initial;

  @override
  Future<bool> signInWithApple() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const Authentication(isLoginApp: true);
    return true;
  }

  @override
  Future<void> signInAnonymously() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    state = const Authentication(isLoginApp: true);
  }

  @override
  Future<void> signOut() async {
    state = const Authentication();
  }
}

/// Firebase につながず、送り先から外したときにサインインしていたかを [unregisteredWhileSignedIn] にためる。
class FakePushTokenRepository extends PushTokenRepository {
  final unregisteredWhileSignedIn = <bool>[];

  @override
  Future<void> build() async {}

  @override
  Future<void> unregister() async {
    unregisteredWhileSignedIn.add(
      ref.read(authenticationRepositoryProvider).isLoginApp,
    );
  }
}

/// サインインしていれば [profile] を返す。
class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository({this.profile});

  final Profile? profile;

  @override
  Future<Profile?> build() async {
    if (!ref.watch(authenticationRepositoryProvider).isLoginApp) return null;
    return profile;
  }
}

/// Firebase につながず、[diaryBookIds] に流した日記帳の id を、タップされた通知として流す。
class FakeOpenedNotificationRepository implements OpenedNotificationRepository {
  final diaryBookIds = StreamController<String>.broadcast();

  @override
  Stream<String> openedDiaryBookIds() => diaryBookIds.stream;
}

/// 書いた記録を [posts] にためる。日記帳のタイムラインには [timelinePosts] を返し、
/// 書いた記録も自分（id: me）の記録として足す。
class FakePostRepository implements PostRepository {
  FakePostRepository({Map<String, List<TimelinePost>>? timelinePosts})
    : timelinePosts = timelinePosts ?? {};

  final posts = <Post>[];

  /// 日記帳の id ごとの記録。
  final Map<String, List<TimelinePost>> timelinePosts;

  @override
  Future<void> create(Post post) async {
    posts.add(post);
    for (final id in post.diaryBookIds) {
      (timelinePosts[id] ??= []).add(
        TimelinePost(
          id: 'post${posts.length}',
          authorId: 'me',
          message: post.message,
          postedAt: DateTime.now(),
        ),
      );
    }
  }

  @override
  Future<void> removeFromDiaryBook(String postId, String diaryBookId) async {
    timelinePosts[diaryBookId]?.removeWhere((post) => post.id == postId);
  }

  @override
  Future<List<TimelinePost>> fetchInDiaryBook(
    String diaryBookId,
    DateTime date,
  ) async {
    return [
      for (final post in timelinePosts[diaryBookId] ?? const <TimelinePost>[])
        if (diaryDateOf(post.postedAt) == date) post,
    ]..sort((a, b) => a.postedAt.compareTo(b.postedAt));
  }

  @override
  Future<List<TimelinePost>> fetchByAuthorsOn(
    List<String> authorIds,
    DateTime date,
  ) async {
    // 同じ記録が複数の日記帳に出ていても1つにする。
    final posts = {
      for (final post in timelinePosts.values.expand((posts) => posts))
        if (authorIds.contains(post.authorId) &&
            diaryDateOf(post.postedAt) == date)
          post.id: post,
    }.values.toList();
    return posts..sort((a, b) => a.postedAt.compareTo(b.postedAt));
  }

  @override
  Future<Set<DateTime>> fetchDatesInDiaryBook(
    String diaryBookId,
    DateTime month,
  ) async {
    return {
      for (final post in timelinePosts[diaryBookId] ?? const <TimelinePost>[])
        diaryDateOf(post.postedAt),
    };
  }
}

/// 日記帳の id ごとの [diaries] を返す。自分（id: me）の日記を書いたり消したりすると [diaries] が変わる。
/// 自分がその日に書いていない日記帳の、ほかの人の日記の本文は伏せて返す。
class FakeDiaryRepository implements DiaryRepository {
  FakeDiaryRepository([Map<String, List<Diary>> diaries = const {}])
    : diaries = {
        for (final entry in diaries.entries) entry.key: [...entry.value],
      };

  final Map<String, List<Diary>> diaries;

  @override
  Future<List<Diary>> fetchOn(String diaryBookId, DateTime date) async {
    final onDate = [
      for (final diary in diaries[diaryBookId] ?? const <Diary>[])
        if (diary.date == date) diary,
    ];
    final wroteToday = onDate.any((diary) => diary.authorId == 'me');
    return [
      for (final diary in onDate)
        diary.authorId == 'me' || wroteToday
            ? diary
            : diary.copyWith(title: null, body: null),
    ];
  }

  @override
  Future<Map<String, Diary>> fetchMineOn(DateTime date) async {
    return {
      for (final entry in diaries.entries)
        for (final diary in entry.value)
          if (diary.authorId == 'me' && diary.date == date) entry.key: diary,
    };
  }

  @override
  Future<void> save({
    required List<String> diaryBookIds,
    required DateTime date,
    required String title,
    required String body,
  }) async {
    for (final id in diaryBookIds) {
      final list = diaries[id] ??= [];
      final index = list.indexWhere(
        (diary) => diary.authorId == 'me' && diary.date == date,
      );
      if (index >= 0) {
        list[index] = list[index].copyWith(title: title, body: body);
      } else {
        list.insert(
          0,
          Diary(
            id: '$id-${list.length}',
            authorId: 'me',
            date: date,
            writtenAt: DateTime.now(),
            title: title,
            body: body,
          ),
        );
      }
    }
  }

  @override
  Future<void> delete(String diaryId) async {
    for (final list in diaries.values) {
      list.removeWhere((diary) => diary.id == diaryId);
    }
  }

  @override
  Future<Set<DateTime>> fetchDatesIn(String diaryBookId, DateTime month) async {
    return {
      for (final diary in diaries[diaryBookId] ?? const <Diary>[]) diary.date,
    };
  }
}

/// [diaryBooks] をそのまま返す。メンバーは日記帳の id ごとの [members] を返す。
/// 招待コードは [invitable] の日記帳のコードで探し、参加すると一覧に足す。
class FakeDiaryBookRepository extends DiaryBookRepository {
  FakeDiaryBookRepository(
    this.diaryBooks, {
    this.members = const {},
    this.invitable = const [],
  });

  final List<DiaryBook> diaryBooks;
  final Map<String, List<DiaryBookMember>> members;

  /// 招待コードで参加できる日記帳。参加しているものも含めてよい。
  final List<DiaryBook> invitable;

  /// 読み直したときに返す一覧。ほかの人が変えたことにする。null なら [diaryBooks]。
  List<DiaryBook>? refreshed;

  /// true なら読み直しに失敗する。
  bool failsToRefresh = false;

  @override
  Future<void> refresh() async {
    if (failsToRefresh) throw Exception('読み直しに失敗');
    state = AsyncData(refreshed ?? diaryBooks);
  }

  DiaryBook? _byCode(String code) =>
      invitable.where((diaryBook) => diaryBook.inviteCode == code).firstOrNull;

  @override
  Future<InvitedDiaryBook?> findByCode(String code) async {
    final diaryBook = _byCode(code);
    if (diaryBook == null) return null;
    return InvitedDiaryBook(
      id: diaryBook.id,
      name: diaryBook.name,
      memberNames: [
        for (final member in members[diaryBook.id] ?? const <DiaryBookMember>[])
          member.displayName,
      ],
      alreadyJoined: [...?state.value]
          .any((joined) => joined.id == diaryBook.id),
      coverColor: diaryBook.coverColor,
    );
  }

  @override
  Future<DiaryBook?> join(String code) async {
    final diaryBook = _byCode(code);
    if (diaryBook == null) return null;
    final current = [...?state.value];
    if (!current.any((joined) => joined.id == diaryBook.id)) {
      state = AsyncData([...current, diaryBook]);
    }
    return diaryBook;
  }

  @override
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    return members[diaryBookId] ?? const [];
  }

  @override
  Future<List<DiaryBook>> build() async => diaryBooks;

  @override
  Future<void> rename(String diaryBookId, String name) async {
    _replace(diaryBookId, (diaryBook) => diaryBook.copyWith(name: name));
  }

  @override
  Future<void> setCoverColor(String diaryBookId, int? coverColor) async {
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(coverColor: coverColor),
    );
  }

  @override
  Future<void> regenerateInviteCode(String diaryBookId) async {
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(inviteCode: 'Re23456'),
    );
  }

  @override
  Future<void> removeMember(String diaryBookId, String userId) async {
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(
        inviteCode: 'Re23456',
        memberCount: diaryBook.memberCount - 1,
      ),
    );
  }

  @override
  Future<void> leave(String diaryBookId) async {
    state = AsyncData([
      for (final diaryBook in [...?state.value])
        if (diaryBook.id != diaryBookId) diaryBook,
    ]);
  }

  void _replace(String diaryBookId, DiaryBook Function(DiaryBook) update) {
    state = AsyncData([
      for (final diaryBook in [...?state.value])
        diaryBook.id == diaryBookId ? update(diaryBook) : diaryBook,
    ]);
  }

  @override
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final diaryBook = DiaryBook(
      id: 'created',
      name: name,
      inviteCode: 'New2345',
      memberCount: 1,
      coverColor: coverColor,
    );
    state = AsyncData([...?state.value, diaryBook]);
    return diaryBook;
  }
}
