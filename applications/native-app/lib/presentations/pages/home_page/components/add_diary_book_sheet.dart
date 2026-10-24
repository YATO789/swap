import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';

/// [showAddDiaryBookSheet] で選んだこと。
enum AddDiaryBookAction { create, join }

/// 「日記帳を作る」と「招待コードで参加」を選ぶシートを開く。閉じたら null。
Future<AddDiaryBookAction?> showAddDiaryBookSheet(BuildContext context) {
  return showModalBottomSheet<AddDiaryBookAction>(
    context: context,
    builder: (context) => const _AddDiaryBookSheet(),
  );
}

class _AddDiaryBookSheet extends StatelessWidget {
  const _AddDiaryBookSheet();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ActionTile(
              icon: Icons.add_circle_outline,
              title: l10n.commonCreateDiaryBook,
              subtitle: l10n.addDiaryBookCreateDescription,
              onTap: () => Navigator.of(context).pop(AddDiaryBookAction.create),
            ),
            _ActionTile(
              icon: Icons.key_outlined,
              title: l10n.commonJoinWithInviteCode,
              subtitle: l10n.addDiaryBookJoinDescription,
              onTap: () => Navigator.of(context).pop(AddDiaryBookAction.join),
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
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(icon, color: colors.textPrimary),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: colors.textSecondary),
      ),
      onTap: onTap,
    );
  }
}
