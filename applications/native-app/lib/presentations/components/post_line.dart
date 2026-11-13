import 'package:flutter/material.dart';

import '../../domains/post/timeline_post.dart';
import '../../theme/app_theme.dart';
import '../../utils/format.dart';
import 'track_view.dart';

/// 「09:00  電車で移動」のように、記録を時刻つきの1行で表示する。
class PostLine extends StatelessWidget {
  const PostLine({super.key, required this.post});

  final TimelinePost post;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 52,
              child: Text(
                formatTime(post.postedAt),
                style: TextStyle(
                  fontSize: 14,
                  color: context.appColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.message, style: const TextStyle(fontSize: 14)),
                  // 添えた曲は、ひとことの下に小さく出す。
                  if (post.track case final track?)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 2),
                      child: TrackLine(track: track),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
