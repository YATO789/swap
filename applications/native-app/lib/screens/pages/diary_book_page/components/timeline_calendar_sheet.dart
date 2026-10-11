import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../theme/app_theme.dart';
import '../controller/diary_book_page_controller.dart';

const _weekdays = ['日', '月', '火', '水', '木', '金', '土'];

/// 月のカレンダーをボトムシートで開き、選ばれた日付（年月日のみ）を返す。
/// [fetchMarkedDates] で読んだ、日記がある日・投稿だけある日に印を付ける。
/// 先の日付には記録がないので、今日までしか選べない。
Future<DateTime?> showTimelineCalendar(
  BuildContext context, {
  required DateTime date,
  required Future<MarkedDates> Function(DateTime month) fetchMarkedDates,
}) {
  return showModalBottomSheet<DateTime>(
    context: context,
    showDragHandle: true,
    builder: (_) =>
        _CalendarSheet(selected: date, fetchMarkedDates: fetchMarkedDates),
  );
}

class _CalendarSheet extends HookWidget {
  const _CalendarSheet({
    required this.selected,
    required this.fetchMarkedDates,
  });

  final DateTime selected;
  final Future<MarkedDates> Function(DateTime month) fetchMarkedDates;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final today = diaryDateOf(DateTime.now());
    final month = useState(DateTime(selected.year, selected.month));
    final isCurrentMonth =
        month.value.year == today.year && month.value.month == today.month;
    void moveMonth(int delta) =>
        month.value = DateTime(month.value.year, month.value.month + delta);

    // 月を変えるたびに読み直す。読み込むまでや失敗したときは、印を付けずに出す。
    final markedDates = useFuture(
      useMemoized(() => fetchMarkedDates(month.value), [month.value]),
    ).data;
    final diaryDates = markedDates?.diaryDates ?? const <DateTime>{};
    final postDates = markedDates?.postDates ?? const <DateTime>{};

    final daysInMonth = DateUtils.getDaysInMonth(
      month.value.year,
      month.value.month,
    );
    // DateTime.weekday は月曜=1〜日曜=7。日曜始まりの列に直す。
    final leading = month.value.weekday % 7;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => moveMonth(-1),
                  tooltip: '前の月',
                  icon: const Icon(Icons.chevron_left),
                ),
                Expanded(
                  child: Text(
                    '${month.value.year}年${month.value.month}月',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  // 先の月には記録がないので進めない。
                  onPressed: isCurrentMonth ? null : () => moveMonth(1),
                  tooltip: '次の月',
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final (i, label) in _weekdays.indexed)
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: i == 0
                            ? Theme.of(context).colorScheme.error
                            : colors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            GridView.count(
              crossAxisCount: 7,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (var i = 0; i < leading; i++) const SizedBox.shrink(),
                for (var day = 1; day <= daysInMonth; day++)
                  _buildDay(
                    context,
                    DateTime(month.value.year, month.value.month, day),
                    today: today,
                    diaryDates: diaryDates,
                    postDates: postDates,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            const _Legend(),
          ],
        ),
      ),
    );
  }

  Widget _buildDay(
    BuildContext context,
    DateTime date, {
    required DateTime today,
    required Set<DateTime> diaryDates,
    required Set<DateTime> postDates,
  }) {
    return _DayCell(
      date: date,
      hasDiary: diaryDates.contains(date),
      hasPost: postDates.contains(date),
      isToday: date == today,
      isSelected: date == selected,
      enabled: !date.isAfter(today),
      onTap: () => Navigator.of(context).pop(date),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.hasDiary,
    required this.hasPost,
    required this.isToday,
    required this.isSelected,
    required this.enabled,
    required this.onTap,
  });

  final DateTime date;
  final bool hasDiary;
  final bool hasPost;
  final bool isToday;
  final bool isSelected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;

    final textColor = !enabled
        ? colors.disabled
        : isSelected
        ? scheme.onPrimary
        : colors.textPrimary;
    final label = [
      '${date.month}月${date.day}日',
      if (isToday) '今日',
      if (hasDiary) '日記あり',
      if (hasPost) '記録あり',
    ].join('、');

    return Semantics(
      button: enabled,
      selected: isSelected,
      label: label,
      excludeSemantics: true,
      child: InkResponse(
        onTap: enabled ? onTap : null,
        radius: 22,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? scheme.primary : null,
                border: isToday && !isSelected
                    ? Border.all(color: scheme.primary)
                    : null,
              ),
              child: Text(
                '${date.day}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                  color: textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            // 両方ある日は、日記・記録の順に横に並べる。
            SizedBox(
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 3,
                children: [
                  if (hasDiary) const _MarkDot(filled: true),
                  if (hasPost) const _MarkDot(filled: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 日記は塗りの点、記録は輪郭の点。
class _MarkDot extends StatelessWidget {
  const _MarkDot({required this.filled});

  final bool filled;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? color : null,
        border: filled ? null : Border.all(color: color),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 12,
      color: context.appColors.textSecondary,
    );
    return ExcludeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _MarkDot(filled: true),
          const SizedBox(width: 4),
          Text('日記あり', style: style),
          const SizedBox(width: 16),
          const _MarkDot(filled: false),
          const SizedBox(width: 4),
          Text('記録あり', style: style),
        ],
      ),
    );
  }
}
