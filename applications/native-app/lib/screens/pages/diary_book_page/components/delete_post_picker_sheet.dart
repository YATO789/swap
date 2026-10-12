import 'package:flutter/material.dart';

import '../../../../domains/post/timeline_post.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';

/// 1つのカードに自分の記録が複数あるときに、どれを削除するかを選ぶシートを開く。閉じたら null。
Future<TimelinePost?> showDeletePostPickerSheet(
  BuildContext context, {
  required List<TimelinePost> posts,
}) {
  return showModalBottomSheet<TimelinePost>(
    context: context,
    builder: (context) => _DeletePostPickerSheet(posts: posts),
  );
}

class _DeletePostPickerSheet extends StatelessWidget {
  const _DeletePostPickerSheet({required this.posts});

  final List<TimelinePost> posts;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Padding(
        // 上はドラッグハンドルがあるので詰める。
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                '削除する記録を選んでください',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            for (final post in posts)
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: Text(
                  formatTime(post.postedAt),
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
                title: Text(post.message, style: const TextStyle(fontSize: 15)),
                onTap: () => Navigator.of(context).pop(post),
              ),
          ],
        ),
      ),
    );
  }
}
