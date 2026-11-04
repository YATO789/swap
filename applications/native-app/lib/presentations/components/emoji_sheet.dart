import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';

/// 全部の絵文字から1つ選ぶシートを開く。選んだ絵文字を返す。閉じたら null。
Future<String?> showEmojiSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const _EmojiSheet(),
  );
}

class _EmojiSheet extends StatelessWidget {
  const _EmojiSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              l10n.emojiSheetTitle,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
          ),
          EmojiPicker(
            onEmojiSelected: (_, emoji) =>
                Navigator.of(context).pop(emoji.emoji),
            config: Config(
              height: MediaQuery.sizeOf(context).height * 0.5,
              locale: Localizations.localeOf(context),
              emojiViewConfig: EmojiViewConfig(
                columns: 8,
                emojiSizeMax: 30,
                backgroundColor: colors.surface,
                noRecents: Text(
                  l10n.emojiSheetNoRecents,
                  style: TextStyle(fontSize: 14, color: colors.textSecondary),
                ),
              ),
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: colors.surface,
                indicatorColor: colors.textPrimary,
                iconColor: colors.textSecondary,
                iconColorSelected: colors.textPrimary,
                dividerColor: colors.border,
              ),
              bottomActionBarConfig: BottomActionBarConfig(
                showBackspaceButton: false,
                backgroundColor: colors.surface,
                buttonColor: colors.surface,
                buttonIconColor: colors.textPrimary,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: colors.surface,
                buttonIconColor: colors.textSecondary,
                hintText: l10n.emojiSheetSearch,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
