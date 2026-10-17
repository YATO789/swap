import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/cover_color_picker.dart';
import '../../../components/diary_cover.dart';

/// 日記帳に1冊も入っていないときの案内。真ん中に表紙を重ねた絵と見出しを置き、
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
                Center(
                  child: _StackedCovers(
                    width: min(constraints.maxWidth * 0.42, 170),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  l10n.emptyDiaryBooksTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 26,
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
                FilledButton.icon(
                  onPressed: onCreate,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: const StadiumBorder(),
                  ),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.commonCreateDiaryBook),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: onJoin,
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(
                    l10n.commonJoinWithInviteCode,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.5,
                    ),
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

/// ミントの表紙の後ろに、ラベンダーとピーチの表紙を扇のように傾けて重ねる。
/// 飾りなので読み上げない。
class _StackedCovers extends StatelessWidget {
  const _StackedCovers({required this.width});

  /// 手前の表紙の幅。後ろの表紙や全体の大きさもこれに合わせる。
  final double width;

  // 表紙に選べる色から、ミントと並べてきれいな2色を選んだ。
  static const _lavender = Color(0xFFD9C2FF);
  static const _peach = Color(0xFFFFB4A8);

  @override
  Widget build(BuildContext context) {
    final backWidth = width * 0.9;
    final shift = width * 0.32;

    return ExcludeSemantics(
      child: SizedBox(
        width: width * 1.7,
        height: width * 4 / 3 * 1.12,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Transform.translate(
              offset: Offset(-shift, width * 0.08),
              child: Transform.rotate(
                angle: -12 * pi / 180,
                child: DiaryCover(color: _lavender, width: backWidth),
              ),
            ),
            Transform.translate(
              offset: Offset(shift, width * 0.06),
              child: Transform.rotate(
                angle: 10 * pi / 180,
                child: DiaryCover(color: _peach, width: backWidth),
              ),
            ),
            // 無地だと寂しいので、表紙にアプリの名前を入れておく。
            DiaryCover(name: 'Swap!', color: initialCoverColor, width: width),
          ],
        ),
      ),
    );
  }
}
