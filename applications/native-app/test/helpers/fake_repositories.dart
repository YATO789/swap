import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';

/// Supabase につながず、サインインすると少し待ってからサインイン済みになる。
class FakeAuthenticationRepository extends AuthenticationRepository {
  FakeAuthenticationRepository({this.initial = const Authentication()});

  final Authentication initial;

  @override
  Authentication build() => initial;

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
class FakeDiaryBookRepository extends DiaryBookRepository {
  FakeDiaryBookRepository(this.diaryBooks, {this.members = const {}});

  final List<DiaryBook> diaryBooks;
  final Map<String, List<DiaryBookMember>> members;

  @override
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    return members[diaryBookId] ?? const [];
  }

  @override
  Future<List<DiaryBook>> build() async => diaryBooks;

  @override
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final diaryBook = DiaryBook(
      id: 'created',
      name: name,
      icon: name.characters.first,
      inviteCode: 'NEW234',
      memberCount: 1,
      coverColor: coverColor,
    );
    state = AsyncData([...?state.value, diaryBook]);
    return diaryBook;
  }
}
