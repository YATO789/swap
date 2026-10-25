import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'floating_top_bar.dart';

/// ページのいちばん上、[FloatingTopBar] のボタンの間に書くタイトル。[subtitle] があれば下に小さく出す。
/// ページと一緒にめくれ、スクロールすると流れていく。
/// ステータスバーとボタンの並びの高さぶんを占め、ボタンの並びの真ん中に置く。
class PaperTitle extends StatelessWidget {
  const PaperTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;

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
                if (subtitle != null)
                  Text(
                    subtitle,
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
