import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../utils/store_pages.dart';
import '../../../components/confirm_sheet.dart';

/// 新しいバージョンがあることを知らせ、ストアを開くか聞く。
///
/// 「あとで」を押すか外をタップして閉じたら false。
Future<bool> showUpdateSheet(BuildContext context) async {
  final l10n = context.l10n;
  final update = await showConfirmSheet(
    context,
    title: l10n.updateOptionalTitle,
    message: l10n.updateOptionalMessage,
    cancelLabel: l10n.updateLater,
    confirmLabel: l10n.updateNow,
  );
  if (!update) return false;

  if (!await openStorePage() && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.commonOpenLinkFailed)));
  }
  return true;
}
