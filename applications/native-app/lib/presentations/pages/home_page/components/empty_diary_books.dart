import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/cover_color_picker.dart';
import '../../../components/diary_cover.dart';

/// 日記帳に1冊も入っていないときの案内。真ん中に表紙を1冊置いた絵と見出しを置き、
/// 下のボタンからその場で作るか参加できるようにする。
class EmptyDiaryBooks extends StatelessWidget {
  const EmptyDiaryBooks({
    super.key,
    required this.onCreate,
    required this.onJoin,
  });

  final VoidCallback onCreate;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: ConstrainedBox(
          // 画面が十分に高ければ絵と見出しを真ん中に、ボタンを下に置き、
          // 低ければスクロールさせる。
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 40),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                // 見出しとの間を広めに空けたいので、表紙だけ上にずらす。
                Transform.translate(
                  offset: const Offset(0, -30),
                  child: Center(
                    child: _TiltedCover(
                      width: min(constraints.maxWidth * 0.46, 180),
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  l10n.emptyDiaryBooksTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    height: 1.4,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.emptyDiaryBooksMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.7,
                    color: colors.textSecondary,
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: onCreate,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(l10n.commonCreateDiaryBook),
                ),
                const SizedBox(height: 6),
                // 作るほうを主にしたいので、参加は控えめな灰色の文字にする。
                TextButton(
                  onPressed: onJoin,
                  style: TextButton.styleFrom(
                    foregroundColor: colors.textSecondary,
                    minimumSize: const Size.fromHeight(48),
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(l10n.commonJoinWithInviteCode),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ミントの表紙を1冊、少しだけ傾けて置く。飾りなので読み上げない。
class _TiltedCover extends StatelessWidget {
  const _TiltedCover({required this.width});

  /// 表紙の幅。中のロゴの大きさや位置もこれに合わせる。
  final double width;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Transform.rotate(
        angle: -4 * pi / 180,
        // 無地だと寂しいので、表紙にアプリのロゴを入れておく。
        // 位置は表紙の名前と同じく、背表紙を除いた上のほうの真ん中。
        child: Stack(
          children: [
            DiaryCover(color: initialCoverColor, width: width),
            Positioned(
              left: width * 28 / 168,
              right: width * 16 / 168,
              top: width * 40 / 168,
              child: Center(
                child: Image.asset(
                  'assets/icons/swap_title.png',
                  width: width * 0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
