import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';

/// [showAvatarActionSheet] で選んだこと。
enum AvatarAction { pick, remove }

/// アイコンの「写真を選ぶ」と「写真を外す」を選ぶシートを開く。閉じたら null。
Future<AvatarAction?> showAvatarActionSheet(BuildContext context) {
  return showModalBottomSheet<AvatarAction>(
    context: context,
    builder: (context) => const _AvatarActionSheet(),
  );
}

class _AvatarActionSheet extends StatelessWidget {
  const _AvatarActionSheet();

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
              icon: Icons.photo_library_outlined,
              title: l10n.profileEditPickAvatar,
              onTap: () => Navigator.of(context).pop(AvatarAction.pick),
            ),
            _ActionTile(
              icon: Icons.delete_outline,
              title: l10n.profileEditRemoveAvatar,
              onTap: () => Navigator.of(context).pop(AvatarAction.remove),
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
