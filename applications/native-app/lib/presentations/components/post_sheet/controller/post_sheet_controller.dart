import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domains/post/post.dart';
import '../../../../infrastructures/repositories/post_repository.dart';

part '_generated/post_sheet_controller.g.dart';

/// 「ひとこと」の投稿シートの投稿処理を受け持つ。状態は投稿の進み具合。
@riverpod
class PostSheetController extends _$PostSheetController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// [post] を書いて日記帳に出す。書けたら true。
  /// 失敗したら false を返し、状態にエラーが入る。
  Future<bool> submit(Post post) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(postRepositoryProvider).create(post),
    );
    if (state case AsyncError(:final error, :final stackTrace)) {
      debugPrint('記録を書けませんでした: $error\n$stackTrace');
      return false;
    }
    return true;
  }
}
