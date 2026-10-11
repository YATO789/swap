import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:swap/infrastructures/datasources/stores/post_diary_book_store.dart';
import 'package:swap/theme/app_theme.dart';

import 'fake_stores.dart';

extension PumpApp on WidgetTester {
  /// アプリと同じテーマと ProviderScope の中に [widget] を置いて表示する。
  /// Supabase につなぐ provider は [overrides] で差し替える。
  /// 端末への保存はせず、テストの間だけ覚えておく。
  Future<void> pumpApp(Widget widget, {List<Override> overrides = const []}) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          postDiaryBookStoreProvider.overrideWithValue(
            FakePostDiaryBookStore(),
          ),
          ...overrides,
        ],
        child: MaterialApp(theme: buildLightTheme(), home: widget),
      ),
    );
  }
}
