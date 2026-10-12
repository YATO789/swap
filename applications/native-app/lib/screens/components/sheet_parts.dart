import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 確認や入力に使うボトムシートの中身の枠。
/// キーボードが出たらその上まで持ち上げ、収まらなければスクロールさせる。
class SheetBody extends StatelessWidget {
  const SheetBody({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          // 上はドラッグハンドルがあるので詰める。
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
          child: child,
        ),
      ),
    );
  }
}

/// シートの見出し。
class SheetTitle extends StatelessWidget {
  const SheetTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 22,
        height: 1.4,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

/// シートの見出しの下に置く説明。
class SheetMessage extends StatelessWidget {
  const SheetMessage(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        height: 1.7,
        color: context.appColors.textSecondary,
      ),
    );
  }
}

/// シートの一番下に並べる「キャンセル」と、決めるボタン。
/// [destructive] なら決めるボタンを赤くする。[onConfirm] が null なら押せない。
class SheetButtons extends StatelessWidget {
  const SheetButtons({
    super.key,
    this.cancelLabel = 'キャンセル',
    required this.onCancel,
    required this.confirmLabel,
    required this.onConfirm,
    this.destructive = false,
  });

  final String cancelLabel;
  final VoidCallback onCancel;
  final String confirmLabel;
  final VoidCallback? onConfirm;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: const StadiumBorder(),
              side: BorderSide(color: context.appColors.border, width: 1.5),
            ),
            child: Text(cancelLabel),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SheetPillButton(
            label: confirmLabel,
            onPressed: onConfirm,
            destructive: destructive,
          ),
        ),
      ],
    );
  }
}

/// シートで使う、塗りつぶした丸いボタン。[destructive] なら赤くする。
class SheetPillButton extends StatelessWidget {
  const SheetPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        shape: const StadiumBorder(),
        backgroundColor: destructive ? colorScheme.error : null,
        foregroundColor: destructive ? colorScheme.onError : null,
      ),
      child: Text(label),
    );
  }
}
