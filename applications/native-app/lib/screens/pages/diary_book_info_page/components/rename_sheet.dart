import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/diary_book_icon.dart';
import '../../../components/sheet_parts.dart';

/// 日記帳の名前を書き換えるシートを開く。決めたら前後の空白を除いた新しい名前を返す。
/// 入れている名前の1文字目を、表紙の色 [coverColor] のアイコンにして横に見せる。
Future<String?> showRenameSheet(
  BuildContext context,
  String initialName, {
  int? coverColor,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _RenameSheet(initialName: initialName, coverColor: coverColor),
  );
}

class _RenameSheet extends HookWidget {
  const _RenameSheet({required this.initialName, required this.coverColor});

  final String initialName;
  final int? coverColor;

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialName);
    final name = useValueListenable(controller).text.trim();
    final canSubmit = name.isNotEmpty;

    void submit() => Navigator.of(context).pop(name);

    return SheetBody(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetTitle('日記帳の名前'),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DiaryBookIcon(name: name, coverColor: coverColor, size: 58),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  autofocus: true,
                  maxLength: maxDiaryBookNameLength,
                  textInputAction: TextInputAction.done,
                  onSubmitted: canSubmit ? (_) => submit() : null,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    hintText: '日記帳の名前を入力',
                    helperText: '最初の1文字がアイコンになります',
                    helperStyle: TextStyle(
                      fontSize: 12,
                      color: context.appColors.textSecondary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SheetButtons(
            onCancel: () => Navigator.of(context).pop(),
            confirmLabel: '保存する',
            onConfirm: canSubmit ? submit : null,
          ),
        ],
      ),
    );
  }
}
