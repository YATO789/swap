import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';

/// AppBar のタイトル。どの日を見ているかを下に小さく常に出す。
class DatedTitle extends StatelessWidget {
  const DatedTitle({super.key, required this.title, required this.date});

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title),
        Text(
          formatDateWithWeekday(context, date),
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
