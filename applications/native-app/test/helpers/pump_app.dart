import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:swap/infrastructures/datasources/stores/preferences_store.dart';
import 'package:swap/l10n/l10n.dart';
import 'package:swap/theme/app_theme.dart';

import 'fake_stores.dart';

extension PumpApp on WidgetTester {
  /// アプリと同じテーマと ProviderScope の中に [widget] を置いて表示する。
  /// Supabase につなぐ provider は [overrides] で差し替える。
  /// 端末への保存はせず、テストの間だけ [preferencesStore] に覚えておく。
  /// 文言は [locale] の言語で出す。
  Future<void> pumpApp(
    Widget widget, {
    List<Override> overrides = const [],
    FakePreferencesStore? preferencesStore,
    Locale locale = const Locale('ja'),
  }) {
    return pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(
            preferencesStore ?? FakePreferencesStore(),
          ),
          ...overrides,
        ],
        child: MaterialApp(
          theme: buildLightTheme(),
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: widget,
        ),
      ),
    );
  }
}
