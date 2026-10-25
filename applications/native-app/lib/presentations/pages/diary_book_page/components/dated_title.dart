import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';
import 'floating_top_bar.dart';

/// ページのいちばん上、浮かせたボタンの間に書くタイトル。どの日を見ているかを下に小さく出す。
/// ページと一緒にめくれ、スクロールすると流れていく。
/// ステータスバーとボタンの並びの高さぶんを占め、ボタンの並びの真ん中に置く。
class DatedTitle extends StatelessWidget {
  const DatedTitle({super.key, required this.title, required this.date});

  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.paddingOf(context).top,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: FloatingTopBar.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: FloatingTopBar.sideWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                Text(
                  formatDateWithWeekday(context, date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
