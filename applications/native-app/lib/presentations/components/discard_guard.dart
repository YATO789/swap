import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import 'confirm_sheet.dart';

/// 書きかけの内容を捨てて閉じてよいかを聞く。捨てるなら true。
Future<bool> confirmDiscard(BuildContext context) => showConfirmSheet(
  context,
  title: context.l10n.discardGuardTitle,
  message: context.l10n.discardGuardMessage,
  cancelLabel: context.l10n.discardGuardKeepEditing,
  confirmLabel: context.l10n.discardGuardDiscard,
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
