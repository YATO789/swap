import 'package:flutter/material.dart';

import '../../../../domains/post/track.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../track_view.dart';

/// 書いている記録に添えた曲。押すと曲を選び直し、右の × で外す。
class AttachedTrackCard extends StatelessWidget {
  const AttachedTrackCard({
    super.key,
    required this.track,
    required this.onChange,
    required this.onRemove,
  });

  final Track track;
  final VoidCallback onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              button: true,
              label: l10n.trackAttachedLabel(track.title, track.artist),
              excludeSemantics: true,
              child: InkWell(
                onTap: onChange,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      TrackArtwork(track: track, size: 44),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TrackTitle(
                          title: track.title,
                          subtitle: track.artist,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            tooltip: l10n.trackRemove,
            icon: Icon(Icons.close, size: 20, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

/// 書いている記録に曲を添えるボタン。
class AttachTrackButton extends StatelessWidget {
  const AttachTrackButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.music_note_outlined, size: 18),
      label: Text(context.l10n.trackAttach),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.fromLTRB(12, 0, 14, 0),
        shape: const StadiumBorder(),
        side: BorderSide(color: context.appColors.border),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }
}
