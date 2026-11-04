import 'package:flutter/material.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/diary_book_icon.dart';

/// [showDiaryBookMenuSheet] で選んだこと。
enum DiaryBookMenuAction { info, invite, decorate }

/// ホームで表紙を長押ししたときに、[diaryBook] でできることを選ぶシートを開く。閉じたら null。
Future<DiaryBookMenuAction?> showDiaryBookMenuSheet(
  BuildContext context,
  DiaryBook diaryBook,
) {
  return showModalBottomSheet<DiaryBookMenuAction>(
    context: context,
    builder: (context) => _DiaryBookMenuSheet(diaryBook: diaryBook),
  );
}

class _DiaryBookMenuSheet extends StatelessWidget {
  const _DiaryBookMenuSheet({required this.diaryBook});

  final DiaryBook diaryBook;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    void choose(DiaryBookMenuAction action) {
      Navigator.of(context).pop(action);
    }

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // どの日記帳のメニューかを、いちばん上に出す。
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Row(
                children: [
                  DiaryBookIcon(
                    name: diaryBook.name,
                    coverColor: diaryBook.coverColor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      diaryBook.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _ActionTile(
              icon: Icons.info_outline,
              title: l10n.homeMenuInfo,
              onTap: () => choose(DiaryBookMenuAction.info),
            ),
            _ActionTile(
              icon: Icons.person_add_alt_outlined,
              title: l10n.homeMenuInvite,
              onTap: () => choose(DiaryBookMenuAction.invite),
            ),
            _ActionTile(
              icon: Icons.brush_outlined,
              title: l10n.homeMenuDecorate,
              onTap: () => choose(DiaryBookMenuAction.decorate),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: context.appColors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }
}
