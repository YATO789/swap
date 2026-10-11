const _weekdays = ['月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日', '日曜日'];

/// 「09:05」の形にする。
String formatTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

/// 「10月3日 金曜日」の形にする。
String formatDateWithWeekday(DateTime date) =>
    '${date.month}月${date.day}日 ${_weekdays[date.weekday - 1]}';
