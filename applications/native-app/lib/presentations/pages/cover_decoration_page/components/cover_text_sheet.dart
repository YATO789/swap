import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/cover_decoration.dart';
import '../../../../l10n/l10n.dart';
import '../../../components/sheet_parts.dart';

/// 表紙の文字シートで選んだもの。[name] なら日記帳の名前を置き、そうでなければ [text] を置く。
typedef CoverTextChoice = ({bool name, String text});

/// 表紙に置く文字を入れるシートを開く。決めたら前後の空白を除いた文字を返す。
///
/// [offerName] なら、表紙に名前を置き直すボタンも出す（名前を表紙から外したとき）。
/// [initialText] があれば、置いた文字を書き換えるシートにする。
Future<CoverTextChoice?> showCoverTextSheet(
  BuildContext context, {
  String initialText = '',
  bool offerName = false,
}) {
  return showModalBottomSheet<CoverTextChoice>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _CoverTextSheet(initialText: initialText, offerName: offerName),
  );
}

class _CoverTextSheet extends HookWidget {
  const _CoverTextSheet({required this.initialText, required this.offerName});

  final String initialText;
  final bool offerName;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final controller = useTextEditingController(text: initialText);
    final text = useValueListenable(controller).text.trim();
    final editing = initialText.isNotEmpty;

    return SheetBody(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetTitle(
            editing ? l10n.coverTextSheetEditTitle : l10n.coverTextSheetTitle,
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            autofocus: true,
            maxLength: maxCoverTextLength,
            minLines: 1,
            maxLines: maxCoverTextLines,
            keyboardType: TextInputType.multiline,
            // 改行で行が増えすぎないよう、行の数の上限までにする。
            inputFormatters: [_MaxLinesFormatter(maxCoverTextLines)],
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              hintText: l10n.coverTextSheetHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          if (offerName) ...[
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () =>
                    Navigator.of(context).pop((name: true, text: '')),
                icon: const Icon(Icons.book_outlined, size: 18),
                label: Text(l10n.coverTextSheetPlaceName),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SheetButtons(
            onCancel: () => Navigator.of(context).pop(),
            confirmLabel: editing ? l10n.commonSave : l10n.coverTextSheetPlace,
            onConfirm: text.isEmpty
                ? null
                : () => Navigator.of(context).pop((name: false, text: text)),
          ),
        ],
      ),
    );
  }
}

/// [maxLines] 行より多くなる入力を受けつけない。
class _MaxLinesFormatter extends TextInputFormatter {
  const _MaxLinesFormatter(this.maxLines);

  final int maxLines;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return '\n'.allMatches(newValue.text).length < maxLines
        ? newValue
        : oldValue;
  }
}
