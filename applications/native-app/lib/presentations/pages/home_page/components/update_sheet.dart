import 'package:flutter/material.dart';

import '../../../../domains/app_update/app_update.dart';
import '../../../../l10n/l10n.dart';
import '../../../../utils/store_pages.dart';
import '../../../components/confirm_sheet.dart';
import '../../../components/release_notes.dart';

/// 新しいバージョンがあることを知らせ、ストアを開くか聞く。
/// [update] に変わったことがあれば、決まり文句の代わりにそれを並べる。
///
/// 「あとで」を押すか外をタップして閉じたら false。
Future<bool> showUpdateSheet(BuildContext context, AppUpdate update) async {
  final l10n = context.l10n;
  final version = update.latestVersion;
  final hasNotes = version != null && update.releaseNotes.isNotEmpty;
  final confirmed = await showConfirmSheet(
    context,
    title: l10n.updateOptionalTitle,
    message: hasNotes ? null : l10n.updateOptionalMessage,
    preview: hasNotes
        ? ReleaseNotes(version: version.toString(), notes: update.releaseNotes)
        : null,
    cancelLabel: l10n.updateLater,
    confirmLabel: l10n.updateNow,
  );
  if (!confirmed) return false;

  if (!await openStorePage() && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.commonOpenLinkFailed)));
  }
  return true;
}
