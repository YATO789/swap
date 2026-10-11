import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/diary_book.dart';

/// 日記帳の名前を書き換えるダイアログを開く。決めたら前後の空白を除いた新しい名前を返す。
Future<String?> showRenameDialog(BuildContext context, String initialName) {
  return showDialog<String>(
    context: context,
    builder: (context) => _RenameDialog(initialName: initialName),
  );
}

class _RenameDialog extends HookWidget {
  const _RenameDialog({required this.initialName});

  final String initialName;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialName);
    final name = useValueListenable(controller).text.trim();
    final canSubmit = name.isNotEmpty;

    void submit() => Navigator.of(context).pop(name);

    return AlertDialog(
      title: const Text('日記帳の名前'),
      content: TextField(
        controller: controller,
        autofocus: true,
        maxLength: maxDiaryBookNameLength,
        textInputAction: TextInputAction.done,
        onSubmitted: canSubmit ? (_) => submit() : null,
        decoration: const InputDecoration(
          hintText: '日記帳の名前を入力',
          helperText: '名前の最初の1文字がアイコンになります',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        TextButton(
          onPressed: canSubmit ? submit : null,
          child: const Text('保存'),
        ),
      ],
    );
  }
}
