import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:swap/domains/authentication/authentication.dart';
import 'package:swap/domains/diary_book/diary_book.dart';
import 'package:swap/domains/post/post.dart';
import 'package:swap/domains/profile/profile.dart';
import 'package:swap/infrastructures/repositories/authentication_repository.dart';
import 'package:swap/infrastructures/repositories/diary_book_repository.dart';
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

/// 書いた記録を [posts] にためる。
class FakePostRepository implements PostRepository {
  final posts = <Post>[];

  @override
  Future<void> create(Post post) async {
    posts.add(post);
  }
}

/// [diaryBooks] をそのまま返す。
class FakeDiaryBookRepository extends DiaryBookRepository {
  FakeDiaryBookRepository(this.diaryBooks);

  final List<DiaryBook> diaryBooks;

  @override
  Future<List<DiaryBook>> build() async => diaryBooks;

  @override
  Future<DiaryBook> create(String name, {int? coverColor}) async {
    final diaryBook = DiaryBook(
      id: 'new',
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
