import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// 表紙の下の帯に並べる、丸い小さなボタン。
class BarButton extends StatelessWidget {
  const BarButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.toggled,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;

  /// 入り切りするボタンの今の状態。null なら入り切りしないボタン。
  /// 入っているときは塗りつぶす。
  final bool? toggled;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = toggled ?? false;

    return Semantics(
      toggled: toggled,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: const StadiumBorder(),
          backgroundColor: selected ? colors.textPrimary : null,
          foregroundColor: destructive
              ? Theme.of(context).colorScheme.error
              : selected
              ? colors.surface
              : colors.textPrimary,
          side: BorderSide(
            color: selected ? colors.textPrimary : colors.border,
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        child: Text(label),
      ),
    );
  }
}

/// らくがきや色を選ぶのを終えて、絵文字を動かせるようにするボタン。
class DoneButton extends StatelessWidget {
  const DoneButton({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 40),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
