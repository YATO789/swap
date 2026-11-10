import 'dart:async';
import 'dart:typed_data';

import 'package:swap/domains/app_update/app_update.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary/diary.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/diary_book/diary_book_cover_field.dart';
import 'package:swap/domains/diary_book/diary_book_member.dart';
import 'package:swap/domains/diary_book/invited_diary_book.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/post/post_comment.dart';
import 'package:swap/domains/post/timeline_post.dart';
import 'package:swap/domains/post/track.dart';
import 'package:swap/domains/reaction/reaction.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/app_update_repository.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
import 'package:swap/infrastructures/repositories/diary_reminder_repository.dart';
import 'package:swap/infrastructures/repositories/diary_repository.dart';
import 'package:swap/infrastructures/repositories/feedback_repository.dart';
import 'package:swap/infrastructures/repositories/opened_notification_repository.dart';
import 'package:swap/infrastructures/repositories/post_repository.dart';
import 'package:swap/infrastructures/repositories/profile_repository.dart';
import 'package:swap/infrastructures/repositories/push_token_repository.dart';

/// Remote Config を見ず、[initial] を返す。「あとで」を押すと [skipped] を true にする。
class FakeAppUpdateRepository implements AppUpdateRepository {
  FakeAppUpdateRepository([this.initial = AppUpdate.none]);

  final AppUpdate initial;
  var skipped = false;

  @override
  Future<AppUpdate> fetch() async {
    return initial;
  }

  @override
  Future<void> skip() async {
    skipped = true;
  }
}

/// Supabase につながず、サインインすると少し待ってからサインイン済みになる。
class FakeAuthenticationRepository implements AuthenticationRepository {
  FakeAuthenticationRepository({
    Authentication initial = const Authentication(),
  }) : current = initial;

  @override
  Authentication current;

  @override
  Future<bool> signInWithApple() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    current = const Authentication(isSignedIn: true);
    return true;
  }

  @override
  Future<void> signInAnonymously() async {
    await Future<void>.delayed(const Duration(milliseconds: 10));
    current = const Authentication(isSignedIn: true);
  }

  @override
  Future<void> signOut() async {
    current = const Authentication();
  }

  @override
  Future<void> deleteAccount() async {
    current = const Authentication();
  }
}

/// Firebase につながず、送り先から外したときに [authentication] でサインインしていたかを
/// [unregisteredWhileSignedIn] にためる。
class FakePushTokenRepository implements PushTokenRepository {
  FakePushTokenRepository(this.authentication);

  final AuthenticationRepository authentication;
  final unregisteredWhileSignedIn = <bool>[];

  @override
  Stream<String> get onTokenRefresh {
    return const Stream.empty();
  }

  @override
  Future<String?> fetchToken() async {
    return null;
  }

  @override
  Future<void> register(String token) async {}

  @override
  Future<void> unregister() async {
    unregisteredWhileSignedIn.add(authentication.current.isSignedIn);
  }

  @override
  Future<void> deleteToken() async {}

  @override
  Future<void> resetUnreadCount() async {}
}

/// [profile] を返す。保存すると [profile] を書き換える。
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({this.profile});

  Profile? profile;

  @override
  Future<Profile?> fetchMine() async {
    return profile;
  }

  @override
  Future<Profile> save({
    required String displayName,
    Uint8List? newAvatar,
    bool removesAvatar = false,
  }) async {
    final saved = Profile(
      id: profile?.id ?? 'me',
      displayName: displayName,
      avatarUrl: newAvatar != null
          ? 'https://example.com/avatar.jpg'
          : removesAvatar
          ? null
          : profile?.avatarUrl,
    );
    profile = saved;
    return saved;
  }
}

/// 送ったフィードバックを [sent] にためる。[fails] が true なら送れない。
class FakeFeedbackRepository implements FeedbackRepository {
  final sent = <String>[];
  var fails = false;

  @override
  Future<void> send(String body) async {
    if (fails) throw Exception('送信に失敗');
    sent.add(body);
  }
}

/// Firebase につながず、[diaryBookIds] に流した日記帳の id を、タップされた通知として流す。
class FakeOpenedNotificationRepository implements OpenedNotificationRepository {
  final diaryBookIds = StreamController<String>.broadcast();

  @override
  Stream<String> openedDiaryBookIds() {
    return diaryBookIds.stream;
  }
}

/// 端末に予約せず、予約した時刻を [scheduled] に覚えておく。
/// [taps] に流すと、日記のリマインダーがタップされたことにする。
class FakeDiaryReminderRepository implements DiaryReminderRepository {
  final taps = StreamController<void>.broadcast();
  List<DateTime> scheduled = [];

  @override
  Future<void> replace(List<DateTime> times, {required String body}) async {
    scheduled = times;
  }

  @override
  Future<void> cancelAll() async {
    scheduled = [];
  }

  @override
  Stream<void> opened() {
    return taps.stream;
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
          track: post.track,
        ),
      );
    }
  }

  /// 曲の検索で返す曲。曲名・アーティスト名・アルバム名に検索語を含むものだけ返す。
  List<Track> tracks = const [];

  @override
  Future<List<Track>> searchTracks(String query) async {
    final words = query.toLowerCase();
    return [
      for (final track in tracks)
        if ('${track.title} ${track.artist} ${track.album}'
            .toLowerCase()
            .contains(words))
          track,
    ];
  }

  @override
  Future<void> removeFromDiaryBook(String postId, String diaryBookId) async {
    timelinePosts[diaryBookId]?.removeWhere((post) => post.id == postId);
  }

  /// true なら、リアクションの保存に失敗する。
  bool failsReactions = false;

  @override
  Future<void> react(String postId, String diaryBookId, String emoji) async {
    if (failsReactions) throw Exception('リアクションを保存できない');
    _updatePost(diaryBookId, postId, (post) {
      return post.copyWith(
        reactions: [
          for (final reaction in post.reactions)
            if (reaction.userId != 'me') reaction,
          Reaction(userId: 'me', emoji: emoji),
        ],
      );
    });
  }

  @override
  Future<void> removeReaction(String postId, String diaryBookId) async {
    if (failsReactions) throw Exception('リアクションを保存できない');
    _updatePost(diaryBookId, postId, (post) {
      return post.copyWith(
        reactions: [
          for (final reaction in post.reactions)
            if (reaction.userId != 'me') reaction,
        ],
      );
    });
  }

  /// true なら、コメントを書くのも消すのも失敗する。
  bool failsComments = false;

  @override
  Future<PostComment> addComment(
    String postId,
    String diaryBookId,
    String message,
  ) async {
    if (failsComments) throw Exception('コメントを書けない');
    final comment = PostComment(
      id: 'comment${DateTime.now().microsecondsSinceEpoch}',
      userId: 'me',
      message: message,
      createdAt: DateTime.now(),
    );
    _updatePost(diaryBookId, postId, (post) {
      return post.copyWith(comments: [...post.comments, comment]);
    });
    return comment;
  }

  @override
  Future<void> deleteComment(String commentId) async {
    if (failsComments) throw Exception('コメントを消せない');
    for (final posts in timelinePosts.values) {
      for (final (index, post) in posts.indexed) {
        posts[index] = post.copyWith(
          comments: [
            for (final comment in post.comments)
              if (comment.id != commentId) comment,
          ],
        );
      }
    }
  }

  void _updatePost(
    String diaryBookId,
    String postId,
    TimelinePost Function(TimelinePost post) update,
  ) {
    final posts = timelinePosts[diaryBookId];
    if (posts == null) return;
    for (final (index, post) in posts.indexed) {
      if (post.id == postId) posts[index] = update(post);
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
            : diary.copyWith(body: null),
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

  /// true なら、リアクションの保存に失敗する。
  bool failsReactions = false;

  @override
  Future<void> react(String diaryId, String emoji) async {
    if (failsReactions) throw Exception('リアクションを保存できない');
    _updateDiary(diaryId, (diary) {
      return diary.copyWith(
        reactions: [
          for (final reaction in diary.reactions)
            if (reaction.userId != 'me') reaction,
          Reaction(userId: 'me', emoji: emoji),
        ],
      );
    });
  }

  @override
  Future<void> removeReaction(String diaryId) async {
    if (failsReactions) throw Exception('リアクションを保存できない');
    _updateDiary(diaryId, (diary) {
      return diary.copyWith(
        reactions: [
          for (final reaction in diary.reactions)
            if (reaction.userId != 'me') reaction,
        ],
      );
    });
  }

  void _updateDiary(String diaryId, Diary Function(Diary diary) update) {
    for (final list in diaries.values) {
      for (final (index, diary) in list.indexed) {
        if (diary.id == diaryId) list[index] = update(diary);
      }
    }
  }
}

/// 最初は [diaryBooks] を返す。メンバーは日記帳の id ごとの [members] を返す。
/// 招待コードは [invitable] の日記帳のコードで探し、参加すると一覧に足す。
class FakeDiaryBookRepository implements DiaryBookRepository {
  FakeDiaryBookRepository(
    List<DiaryBook> diaryBooks, {
    this.members = const {},
    this.invitable = const [],
  }) : _joined = [...diaryBooks];

  final Map<String, List<DiaryBookMember>> members;

  /// 招待コードで参加できる日記帳。参加しているものも含めてよい。
  final List<DiaryBook> invitable;

  /// 読み直したときに返す一覧。ほかの人が変えたことにする。null なら今の一覧。
  List<DiaryBook>? refreshed;

  /// true なら読み直しに失敗する。最初に読むときは失敗しない。
  bool failsToRefresh = false;

  List<DiaryBook> _joined;
  var _fetched = false;

  @override
  Future<List<DiaryBook>> fetchJoined() async {
    if (_fetched) {
      if (failsToRefresh) throw Exception('読み直しに失敗');
      _joined = [...refreshed ?? _joined];
    }
    _fetched = true;
    return [..._joined];
  }

  DiaryBook? _byCode(String code) {
    return invitable
        .where((diaryBook) => diaryBook.inviteCode == code)
        .firstOrNull;
  }

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
      alreadyJoined: _joined.any((joined) => joined.id == diaryBook.id),
      memberLimit: diaryBook.memberLimit,
      coverColor: diaryBook.coverColor,
    );
  }

  @override
  Future<String?> join(String code) async {
    final diaryBook = _byCode(code);
    if (diaryBook == null) return null;
    if (!_joined.any((joined) => joined.id == diaryBook.id)) {
      _joined.add(diaryBook);
    }
    return diaryBook.id;
  }

  @override
  Future<List<DiaryBookMember>> fetchMembers(String diaryBookId) async {
    return members[diaryBookId] ?? const [];
  }

  @override
  Future<void> updateCover(
    DiaryBook diaryBook,
    Set<DiaryBookCoverField> fields,
  ) async {
    _replace(diaryBook.id, (current) {
      var updated = current;
      for (final field in fields) {
        updated = switch (field) {
          DiaryBookCoverField.name => updated.copyWith(name: diaryBook.name),
          DiaryBookCoverField.color => updated.copyWith(
            coverColor: diaryBook.coverColor,
          ),
          DiaryBookCoverField.decoration => updated.copyWith(
            coverDecoration: diaryBook.coverDecoration,
          ),
        };
      }
      return updated;
    });
  }

  @override
  Future<void> setMemberLimit(String diaryBookId, int memberLimit) async {
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(memberLimit: memberLimit),
    );
  }

  @override
  Future<String> regenerateInviteCode(String diaryBookId) async {
    const inviteCode = 'Re23456';
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(inviteCode: inviteCode),
    );
    return inviteCode;
  }

  @override
  Future<String> removeMember(String diaryBookId, String userId) async {
    const inviteCode = 'Re23456';
    _replace(
      diaryBookId,
      (diaryBook) => diaryBook.copyWith(
        inviteCode: inviteCode,
        memberCount: diaryBook.memberCount - 1,
      ),
    );
    return inviteCode;
  }

  @override
  Future<void> leave(String diaryBookId) async {
    _joined.removeWhere((diaryBook) => diaryBook.id == diaryBookId);
  }

  void _replace(String diaryBookId, DiaryBook Function(DiaryBook) update) {
    _joined = [
      for (final diaryBook in _joined)
        diaryBook.id == diaryBookId ? update(diaryBook) : diaryBook,
    ];
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
    _joined.add(diaryBook);
    return diaryBook;
  }
}
