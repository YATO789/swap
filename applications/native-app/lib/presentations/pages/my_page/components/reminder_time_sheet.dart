import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../l10n/l10n.dart';
import '../../../components/sheet_parts.dart';

/// 日記のリマインダーを出す時刻を、iOS と同じ回すホイールで選ぶシートを開く。
/// 保存を押したら選んだ時刻を返し、キャンセルや外のタップで閉じたら null を返す。
Future<TimeOfDay?> showReminderTimeSheet(
  BuildContext context, {
  required TimeOfDay initialTime,
}) {
  return showModalBottomSheet<TimeOfDay>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ReminderTimeSheet(initialTime: initialTime),
  );
}

class _ReminderTimeSheet extends HookWidget {
  const _ReminderTimeSheet({required this.initialTime});

  final TimeOfDay initialTime;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final selected = useState(initialTime);
    // ホイールは日時で受け渡すので、日付はどの日でもよい。
    final initialDateTime = useMemoized(() {
      return DateTime(2000, 1, 1, initialTime.hour, initialTime.minute);
    });

    return SheetBody(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SheetTitle(l10n.settingsDiaryReminderTime),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: initialDateTime,
              use24hFormat: MediaQuery.alwaysUse24HourFormatOf(context),
              onDateTimeChanged: (dateTime) {
                selected.value = TimeOfDay.fromDateTime(dateTime);
              },
            ),
          ),
          const SizedBox(height: 16),
          SheetButtons(
            onCancel: () => Navigator.of(context).pop(),
            confirmLabel: l10n.commonSave,
            onConfirm: () => Navigator.of(context).pop(selected.value),
          ),
        ],
      ),
    );
  }
}
