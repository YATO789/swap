import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ColorScheme だけでは表せない、アプリ固有の色。
/// `context.appColors` で取り出す。
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.disabled,
    required this.placeholder,
    required this.surface,
    required this.avatarBackground,
    required this.avatarSilhouette,
  });

  /// 本文や見出し。塗りつぶしたボタンの地にも使う。
  final Color textPrimary;

  /// 補足のテキスト。背景に対して 4.5:1 以上のコントラストを保つ。
  final Color textSecondary;
  final Color border;
  final Color disabled;

  /// 伏せてある日記の帯など、中身の代わりに置く面。
  final Color placeholder;

  /// 画面の地の色。[textPrimary] で塗った上に載せる文字色にも使う。
  final Color surface;

  /// 画像のないアイコンの丸の地。
  final Color avatarBackground;

  /// 画像のないアイコンの、人のシルエット。
  final Color avatarSilhouette;

  static const light = AppColors(
    textPrimary: Color(0xFF111111),
    textSecondary: Color(0xFF6B6B6B),
    border: Color(0xFFE3E3E3),
    disabled: Color(0xFFC4C4C4),
    placeholder: Color(0xFFEFEFEF),
    surface: Colors.white,
    avatarBackground: Color(0xFFEBECEE),
    avatarSilhouette: Color(0xFF7D848C),
  );

  static const dark = AppColors(
    textPrimary: Color(0xFFF2F2F2),
    textSecondary: Color(0xFFA3A3A3),
    border: Color(0xFF333333),
    disabled: Color(0xFF4D4D4D),
    placeholder: Color(0xFF2A2A2A),
    surface: Color(0xFF121212),
    avatarBackground: Color(0xFF2C2F33),
    avatarSilhouette: Color(0xFF7D848C),
  );

  @override
  AppColors copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? disabled,
    Color? placeholder,
    Color? surface,
    Color? avatarBackground,
    Color? avatarSilhouette,
  }) {
    return AppColors(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      disabled: disabled ?? this.disabled,
      placeholder: placeholder ?? this.placeholder,
      surface: surface ?? this.surface,
      avatarBackground: avatarBackground ?? this.avatarBackground,
      avatarSilhouette: avatarSilhouette ?? this.avatarSilhouette,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      avatarBackground: Color.lerp(
        avatarBackground,
        other.avatarBackground,
        t,
      )!,
      avatarSilhouette: Color.lerp(
        avatarSilhouette,
        other.avatarSilhouette,
        t,
      )!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}

ThemeData buildLightTheme() => _buildTheme(Brightness.light, AppColors.light);

ThemeData buildDarkTheme() => _buildTheme(Brightness.dark, AppColors.dark);

ThemeData _buildTheme(Brightness brightness, AppColors colors) {
  final colorScheme =
      ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: brightness,
      ).copyWith(
        primary: colors.textPrimary,
        onPrimary: colors.surface,
        surface: colors.surface,
        // シード色から作られる面の色はうっすら色が付くので、すべて地の色に揃える。
        surfaceContainerLowest: colors.surface,
        surfaceContainerLow: colors.surface,
        surfaceContainer: colors.surface,
        surfaceContainerHigh: colors.surface,
        surfaceContainerHighest: colors.surface,
        onSurface: colors.textPrimary,
        onSurfaceVariant: colors.textSecondary,
        outline: colors.border,
        outlineVariant: colors.border,
      );
  final base = ThemeData(colorScheme: colorScheme);

  return base.copyWith(
    scaffoldBackgroundColor: colors.surface,
    extensions: [colors],
    textTheme: base.textTheme.apply(
      bodyColor: colors.textPrimary,
      displayColor: colors.textPrimary,
    ),
    appBarTheme: AppBarTheme(
      // 背景を透明にした AppBar では、Flutter が透明を暗い色とみなして
      // ステータスバーの文字を白にしてしまう。地色に合わせて決めておく。
      systemOverlayStyle: brightness == Brightness.light
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
      backgroundColor: colors.surface,
      foregroundColor: colors.textPrimary,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colors.textPrimary,
        disabledForegroundColor: colors.disabled,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: colors.textPrimary,
        foregroundColor: colors.surface,
        disabledBackgroundColor: colors.disabled,
        disabledForegroundColor: colors.surface,
        minimumSize: const Size(64, 52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    // 2つ目の選択肢に使う。大きさは FilledButton と揃える。
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.textPrimary,
        disabledForegroundColor: colors.disabled,
        side: BorderSide(color: colors.textPrimary),
        minimumSize: const Size(64, 52),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colors.textPrimary,
      foregroundColor: colors.surface,
      shape: const StadiumBorder(),
      extendedTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: colors.textSecondary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // 枠線の色は状態に応じて outline（通常）と primary（フォーカス時）が使われる。
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    ),
    dividerTheme: DividerThemeData(
      color: colors.border,
      thickness: 1,
      space: 1,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      // 文字は白にするので、ダークモードでも背景は暗いままにする。
      backgroundColor: brightness == Brightness.light
          ? colors.textPrimary
          : const Color(0xFF2A2A2A),
      contentTextStyle: base.textTheme.bodyMedium?.copyWith(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      showDragHandle: true,
      dragHandleColor: colors.disabled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: colors.placeholder,
      height: 64,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
          color: states.contains(WidgetState.selected)
              ? colors.textPrimary
              : colors.textSecondary,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? colors.textPrimary
              : colors.textSecondary,
        ),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: colors.surface,
      surfaceTintColor: Colors.transparent,
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
      headerForegroundColor: colors.textPrimary,
      dividerColor: colors.border,
      todayBorder: BorderSide(color: colors.textPrimary),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.surface,
      surfaceTintColor: Colors.transparent,
    ),
  );
}
