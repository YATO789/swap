import 'package:flutter/material.dart';

import 'confirm_sheet.dart';

/// 書きかけの内容を捨てて閉じてよいかを聞く。捨てるなら true。
Future<bool> confirmDiscard(BuildContext context) => showConfirmSheet(
  context,
  title: '入力内容を破棄しますか？',
  message: '保存していない内容は失われます。',
  cancelLabel: '編集を続ける',
  confirmLabel: '破棄する',
  destructive: true,
);

/// 書きかけの内容があるときに、戻る操作で [confirmDiscard] を挟む。
/// 閉じるボタンは `Navigator.maybePop` を呼ぶこと（`pop` だと確認を飛ばす）。
class DiscardGuard extends StatelessWidget {
  const DiscardGuard({super.key, required this.dirty, required this.child});

  final bool dirty;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final navigator = Navigator.of(context);
        if (await confirmDiscard(context)) navigator.pop();
      },
      child: child,
    );
  }
}
