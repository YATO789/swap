import 'package:flutter/material.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';
import '../../../components/user_avatar.dart';

/// タイムラインの上に出す、その日の日記のまとまり。
/// 自分の日記を先頭に、メンバーの日記を書いた時刻の新しい順に並べる。
/// 日記を書く入口は下の書き込みバーのペンと、伏せてある日記のカードにある。
class DiarySection extends StatelessWidget {
  const DiarySection({
    super.key,
    required this.diaries,
    required this.myId,
    required this.nameOf,
    required this.avatarColorOf,
    required this.onOpen,
    required this.onWrite,
  });

  /// その日の日記。書いた時刻の新しい順。
  final List<Diary> diaries;
  final String? myId;

  /// 書いた人の表示名。
  final String Function(String userId) nameOf;

  /// 書いた人のアイコンの色。
  final int? Function(String userId) avatarColorOf;

  /// 読める日記を押したとき。
  final ValueChanged<Diary> onOpen;

  /// 伏せてある日記を押したとき。その日の自分の日記を書く。
  final ValueChanged<Diary> onWrite;

  @override
  Widget build(BuildContext context) {
    final mine = diaries.where((diary) => diary.authorId == myId).firstOrNull;
    final others = diaries.where((diary) => diary.authorId != myId);
    final today = diaryDateOf(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (mine != null)
          _DiaryCard(
            diary: mine,
            name: nameOf(mine.authorId),
            avatarColor: avatarColorOf(mine.authorId),
            isMine: true,
            onTap: () => onOpen(mine),
          ),
        for (final diary in others)
          diary.isLocked
              ? _LockedDiaryCard(
                  diary: diary,
                  name: nameOf(diary.authorId),
                  avatarColor: avatarColorOf(diary.authorId),
                  today: today,
                  // この日記帳に書けば読めるようになるので、そのまま日記を開く。
                  // 書けない古い日はもう読めないので、何もしない。
                  onTap: isEditableDiaryDate(diary.date, today: today)
                      ? () => onWrite(diary)
                      : null,
                )
              : _DiaryCard(
                  diary: diary,
                  name: nameOf(diary.authorId),
                  avatarColor: avatarColorOf(diary.authorId),
                  isMine: false,
                  onTap: () => onOpen(diary),
                ),
      ],
    );
  }
}

const _previewFontSize = 15.0;
const _previewLineHeight = 1.5;

/// タイトルも本文も1行の高さをぴったり同じにして、カードの高さを揃える。
const _previewStrut = StrutStyle(
  fontSize: _previewFontSize,
  height: _previewLineHeight,
  forceStrutHeight: true,
);

/// 日記の冒頭を表示するカード。タップで全文を開く。
class _DiaryCard extends StatelessWidget {
  const _DiaryCard({
    required this.diary,
    required this.name,
    required this.avatarColor,
    required this.isMine,
    required this.onTap,
  });

  final Diary diary;
  final String name;
  final int? avatarColor;
  final bool isMine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final title = diary.title ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.border),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAvatar(name: name, filled: isMine, color: avatarColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CardHeader(name: name, writtenAt: diary.writtenAt),
                      const SizedBox(height: 4),
                      // 冒頭だけ見せて、続きはタップした詳細で読む。
                      // タイトル1行と本文1行にして、本文が短くてもカードの高さを2行ぶんに揃える。
                      // タイトルがなければ「タイトルなし」を灰色で出して見た目を揃える。
                      // 行の高さは端数が丸められるので、決め打ちの高さにはせず最低限の高さにする。
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.textScalerOf(context)
                                  .scale(_previewFontSize) *
                              _previewLineHeight *
                              2,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title.isNotEmpty
                                  ? title
                                  : context.l10n.diarySectionUntitled,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: _previewStrut,
                              style: TextStyle(
                                fontSize: _previewFontSize,
                                height: _previewLineHeight,
                                fontWeight: FontWeight.w700,
                                color: title.isNotEmpty
                                    ? null
                                    : colors.disabled,
                              ),
                            ),
                            Text(
                              diary.body ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: _previewStrut,
                              style: const TextStyle(
                                fontSize: _previewFontSize,
                                height: _previewLineHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// まだ読めない日記。名前と書いた時刻だけを出し、本文は伏せる。
/// タップすると、読めるようにするための日記の画面を開く。
/// [onTap] が null なら、その日の日記はもう書けないので読めないことだけを伝える。
class _LockedDiaryCard extends StatelessWidget {
  const _LockedDiaryCard({
    required this.diary,
    required this.name,
    required this.avatarColor,
    required this.today,
    required this.onTap,
  });

  final Diary diary;
  final String name;
  final int? avatarColor;
  final DateTime today;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canWrite = onTap != null;
    final hint = !canWrite
        ? context.l10n.diarySectionLockedPast
        : diary.date == today
        ? context.l10n.diarySectionLockedToday
        : context.l10n.diarySectionLockedYesterday;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Semantics(
        button: canWrite,
        label: context.l10n.diarySectionLockedSemantics(
          name,
          formatTime(diary.writtenAt),
          hint,
        ),
        excludeSemantics: true,
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UserAvatar(name: name, filled: false, color: avatarColor),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CardHeader(name: name, writtenAt: diary.writtenAt),
                        const SizedBox(height: 8),
                        // 本文の代わりに、伏せてあることが分かる帯を出す。
                        const _PlaceholderBar(widthFactor: 1),
                        const SizedBox(height: 6),
                        const _PlaceholderBar(widthFactor: 0.6),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: colors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                hint,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                            if (canWrite) ...[
                              Text(
                                context.l10n.commonWriteDiary,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.chevron_right, size: 16),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// カード上部の「名前 ・ 22:14」の行。
class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.name, required this.writtenAt});

  final String name;
  final DateTime writtenAt;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          formatTime(writtenAt),
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _PlaceholderBar extends StatelessWidget {
  const _PlaceholderBar({required this.widthFactor});

  final double widthFactor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: context.appColors.placeholder,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
