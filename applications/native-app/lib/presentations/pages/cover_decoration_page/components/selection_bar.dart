import 'package:flutter/material.dart';

import '../../../../domains/diary_book/cover_decoration.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import 'bar_button.dart';

/// 表紙の下の帯。絵文字を選んでいれば重なり順・ふち・消すを、選んでいなければ [hint] を出す。
class SelectionBar extends StatelessWidget {
  const SelectionBar({
    super.key,
    required this.sticker,
    required this.hint,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onMoveUp,
    required this.onMoveDown,
    required this.onToggleFrame,
    required this.onRemove,
  });

  /// 選んでいる絵文字。選んでいなければ null。
  final CoverSticker? sticker;

  /// 何も選んでいないときに出す文。
  final String hint;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onMoveUp;
  final VoidCallback onMoveDown;
  final VoidCallback onToggleFrame;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final sticker = this.sticker;

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: sticker == null
          ? Text(
              hint,
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            )
          : Row(
              children: [
                BarButton(
                  label: l10n.coverEditBringForward,
                  onPressed: canMoveUp ? onMoveUp : null,
                ),
                const SizedBox(width: 8),
                BarButton(
                  label: l10n.coverEditSendBackward,
                  onPressed: canMoveDown ? onMoveDown : null,
                ),
                const SizedBox(width: 8),
                BarButton(
                  label: l10n.coverEditFrame,
                  toggled: sticker.frame,
                  onPressed: onToggleFrame,
                ),
                const Spacer(),
                BarButton(
                  label: l10n.coverEditRemove,
                  destructive: true,
                  onPressed: onRemove,
                ),
              ],
            ),
    );
  }
}
