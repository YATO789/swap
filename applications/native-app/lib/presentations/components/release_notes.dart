import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';

/// 新しいバージョンで変わったこと。[notes] を1行ずつ、頭に印を付けて並べる。
/// 多ければ、決まった高さまでで中をスクロールさせる。
class ReleaseNotes extends StatelessWidget {
  const ReleaseNotes({super.key, required this.version, required this.notes});

  final String version;
  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.updateReleaseNotesTitle(version),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 240),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (index, note) in notes.indexed) ...[
                  if (index > 0) const SizedBox(height: 10),
                  _NoteRow(note),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 変わったことの1行。左に丸い印を付ける。
class _NoteRow extends StatelessWidget {
  const _NoteRow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1行目の文字の真ん中に揃える。
        Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: colors.textPrimary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w500,
              color: colors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
