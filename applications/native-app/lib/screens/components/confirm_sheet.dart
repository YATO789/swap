import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'sheet_parts.dart';

/// してよいかを下から出るシートで聞く。決めるボタンを押したら true、
/// キャンセルや外のタップで閉じたら false。
///
/// [preview] には消すものなど、何が対象かを見せる部品を渡せる。
/// [irreversible] なら「この操作は取り消せません」を赤く添える。
/// [destructive] なら決めるボタンを赤くする。
Future<bool> showConfirmSheet(
  BuildContext context, {
  required String title,
  String? message,
  Widget? preview,
  bool irreversible = false,
  required String confirmLabel,
  String cancelLabel = 'キャンセル',
  bool destructive = false,
}) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final errorColor = Theme.of(context).colorScheme.error;

      return SheetBody(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetTitle(title),
            if (message != null) ...[
              const SizedBox(height: 8),
              SheetMessage(message),
            ],
            if (preview != null) ...[const SizedBox(height: 18), preview],
            if (irreversible) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: errorColor),
                  const SizedBox(width: 6),
                  Text(
                    'この操作は取り消せません',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: errorColor,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 24),
            SheetButtons(
              cancelLabel: cancelLabel,
              onCancel: () => Navigator.of(context).pop(false),
              confirmLabel: confirmLabel,
              onConfirm: () => Navigator.of(context).pop(true),
              destructive: destructive,
            ),
          ],
        ),
      );
    },
  );
  return confirmed ?? false;
}

/// 知らせるだけのシートを開く。ボタンを押すまで閉じない。
Future<void> showNoticeSheet(
  BuildContext context, {
  required String title,
  String? message,
  required String buttonLabel,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    showDragHandle: false,
    builder: (context) => SheetBody(
      child: Padding(
        // ドラッグハンドルがない分、上を空ける。
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SheetTitle(title),
            if (message != null) ...[
              const SizedBox(height: 8),
              SheetMessage(message),
            ],
            const SizedBox(height: 24),
            SheetPillButton(
              label: buttonLabel,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    ),
  );
}

/// [showConfirmSheet] の [preview] に渡す、対象を見せる淡い地のカード。
class ConfirmPreview extends StatelessWidget {
  const ConfirmPreview({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: context.appColors.placeholder,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}
