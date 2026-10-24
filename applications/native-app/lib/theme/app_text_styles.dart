import 'package:flutter/material.dart';

import 'app_theme.dart';

/// 画面をまたいで使う文字のスタイル。
/// `context.appTextStyles` で取り出す。
class AppTextStyles {
  const AppTextStyles(this._colors);

  final AppColors _colors;

  /// 文中で押せるリンク。周りの文字の大きさはそのまま引き継ぐ。
  TextStyle get link {
    return TextStyle(
      color: _colors.textPrimary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );
  }
}

extension AppTextStylesContext on BuildContext {
  AppTextStyles get appTextStyles {
    return AppTextStyles(appColors);
  }
}
