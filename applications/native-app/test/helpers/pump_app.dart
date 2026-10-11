import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:swap/theme/app_theme.dart';

extension PumpApp on WidgetTester {
  /// アプリと同じテーマと ProviderScope の中に [widget] を置いて表示する。
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      ProviderScope(
        child: MaterialApp(theme: buildLightTheme(), home: widget),
      ),
    );
  }
}
