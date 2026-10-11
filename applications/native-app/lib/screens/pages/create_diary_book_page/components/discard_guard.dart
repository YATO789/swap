import 'package:flutter/material.dart';

/// 書きかけの内容を捨てて閉じてよいかを聞く。捨てるなら true。
Future<bool> confirmDiscard(BuildContext context) async {
  final discard = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('入力内容を破棄しますか？'),
      content: const Text('保存していない内容は失われます。'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('編集を続ける'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('破棄'),
        ),
      ],
    ),
  );
  return discard ?? false;
}

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
