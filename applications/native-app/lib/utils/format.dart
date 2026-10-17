import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// 「09:05」の形にする。
String formatTime(DateTime time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

/// 端末の言語で「10月3日 金曜日」「Friday, October 3」の形にする。
String formatDateWithWeekday(BuildContext context, DateTime date) {
  final locale = _locale(context);
  // 日本語の MMMMEEEEd は「10月3日金曜日」と詰まるので、間をあける。
  final format = locale == 'ja'
      ? DateFormat.MMMMd(locale).add_EEEE()
      : DateFormat.MMMMEEEEd(locale);
  return format.format(date);
}

/// 端末の言語で「10月3日」「October 3」の形にする。
String formatMonthDay(BuildContext context, DateTime date) =>
    DateFormat.MMMMd(_locale(context)).format(date);

/// 端末の言語で「2026年10月」「October 2026」の形にする。
String formatYearMonth(BuildContext context, DateTime date) =>
    DateFormat.yMMMM(_locale(context)).format(date);

String _locale(BuildContext context) =>
    Localizations.localeOf(context).languageCode;
