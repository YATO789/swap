import 'package:flutter/material.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';

/// AppBar のタイトル。どの日を見ているかを下に小さく常に出す。
class DatedTitle extends StatelessWidget {
  const DatedTitle({super.key, required this.title, required this.date});

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final dateLabel = formatDateWithWeekday(date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        Text(
          date == diaryDateOf(DateTime.now()) ? '今日・$dateLabel' : dateLabel,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// 今日以外を見ているときに AppBar に出す「今日」へ戻るボタン。
class BackToTodayButton extends StatelessWidget {
  const BackToTodayButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: const Text('今日', style: TextStyle(fontSize: 14)),
    );
  }
}
