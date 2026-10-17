import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/diary_book.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/sheet_parts.dart';

/// 日記帳に参加できる人数の上限を選ぶシートを開く。決めたら選んだ人数を返す。
/// 今の人数 [memberCount] より少ない人数は選べない。
Future<int?> showMemberLimitSheet(
  BuildContext context, {
  required int memberLimit,
  required int memberCount,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    builder: (context) =>
        _MemberLimitSheet(memberLimit: memberLimit, memberCount: memberCount),
  );
}

class _MemberLimitSheet extends HookWidget {
  const _MemberLimitSheet({
    required this.memberLimit,
    required this.memberCount,
  });

  final int memberLimit;
  final int memberCount;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final selected = useState(memberLimit);
    final left = selected.value - memberCount;

    return SheetBody(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SheetTitle('人数の上限'),
          const SizedBox(height: 18),
          _MemberLimitBar(
            selected: selected.value,
            memberCount: memberCount,
            onSelected: (count) => selected.value = count,
          ),
          const SizedBox(height: 8),
          Text(
            left == 0
                ? '${selected.value}人まで・満員'
                : '${selected.value}人まで・あと$left人',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 12, color: colors.textSecondary),
          ),
          const SizedBox(height: 24),
          SheetButtons(
            onCancel: () => Navigator.of(context).pop(),
            confirmLabel: '保存する',
            onConfirm: () => Navigator.of(context).pop(selected.value),
          ),
        ],
      ),
    );
  }
}

/// 1〜[maxDiaryBookMembers] 人を1本の帯に並べ、選んでいる人数を塗る。
/// [memberCount] より少ない人数は灰色にして押せなくする。
class _MemberLimitBar extends StatelessWidget {
  const _MemberLimitBar({
    required this.selected,
    required this.memberCount,
    required this.onSelected,
  });

  final int selected;
  final int memberCount;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    const radius = BorderRadius.all(Radius.circular(14));

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border, width: 1.5),
        borderRadius: radius,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Row(
          children: [
            for (var count = 1; count <= maxDiaryBookMembers; count++)
              Expanded(
                child: _Segment(
                  count: count,
                  selected: count == selected,
                  enabled: count >= memberCount,
                  showDivider: count < maxDiaryBookMembers,
                  onTap: () => onSelected(count),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.count,
    required this.selected,
    required this.enabled,
    required this.showDivider,
    required this.onTap,
  });

  final int count;
  final bool selected;
  final bool enabled;
  final bool showDivider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      label: '$count人',
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      button: true,
      excludeSemantics: true,
      child: Material(
        color: selected
            ? colors.textPrimary
            : enabled
            ? Colors.transparent
            : colors.placeholder,
        child: InkWell(
          onTap: enabled ? onTap : null,
          child: Container(
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: showDivider
                  ? Border(right: BorderSide(color: colors.border))
                  : null,
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                fontFeatures: const [FontFeature.tabularFigures()],
                color: selected
                    ? colors.surface
                    : enabled
                    ? colors.textPrimary
                    : colors.disabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
