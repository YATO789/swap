import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 画面の上に浮かせるボタンの台。紙と同じ色の丸（横に長ければ両端が丸い形）に、
/// 細い枠線と柔らかい影を付けて、下を流れる文字から浮いて見せる。
class FloatingSurface extends StatelessWidget {
  const FloatingSurface({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.border)),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}

/// [FloatingSurface] に載せた丸いアイコンのボタン。
class FloatingIconButton extends StatelessWidget {
  const FloatingIconButton({
    super.key,
    required this.onPressed,
    required this.tooltip,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return FloatingSurface(
      child: FloatingSurfaceIcon(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: icon,
      ),
    );
  }
}

/// [FloatingSurface] の中に並べるアイコン。いくつか並べて1つの台にまとめるときに使う。
class FloatingSurfaceIcon extends StatelessWidget {
  const FloatingSurfaceIcon({
    super.key,
    required this.onPressed,
    required this.tooltip,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String tooltip;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        fixedSize: const Size(floatingButtonSize, floatingButtonSize),
        foregroundColor: context.appColors.textPrimary,
      ),
      icon: icon,
    );
  }
}

/// 浮かせるボタンの高さ。
const floatingButtonSize = 48.0;
