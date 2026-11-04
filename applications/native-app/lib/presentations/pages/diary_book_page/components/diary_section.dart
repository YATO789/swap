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
    required this.avatarUrlOf,
    required this.onOpen,
    required this.onWrite,
  });

  /// その日の日記。書いた時刻の新しい順。
  final List<Diary> diaries;
  final String? myId;

  /// 書いた人の表示名。
  final String Function(String userId) nameOf;

  /// 書いた人のアイコンの色。
  final String? Function(String userId) avatarUrlOf;

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
            avatarUrl: avatarUrlOf(mine.authorId),
            isMine: true,
            onTap: () => onOpen(mine),
          ),
        for (final diary in others)
          diary.isLocked
              ? _LockedDiaryCard(
                  diary: diary,
                  name: nameOf(diary.authorId),
                  avatarUrl: avatarUrlOf(diary.authorId),
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
                  avatarUrl: avatarUrlOf(diary.authorId),
                  isMine: false,
                  onTap: () => onOpen(diary),
                ),
      ],
    );
  }
}

/// 日記の冒頭を表示するカード。タップで全文を開く。
class _DiaryCard extends StatelessWidget {
  const _DiaryCard({
    required this.diary,
    required this.name,
    required this.avatarUrl,
    required this.isMine,
    required this.onTap,
  });

  final Diary diary;
  final String name;
  final String? avatarUrl;
  final bool isMine;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final body = diary.body ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: colors.surface,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardHeader(name: name, avatarUrl: avatarUrl, isMine: isMine),
                const SizedBox(height: 10),
                // 冒頭だけ見せて、続きはタップした詳細で読む。
                _DiaryTitle(title: diary.title),
                // 本文は1行だけ。本文がなくても1行ぶんの高さを取り、カードの高さを揃える。
                const SizedBox(height: 6),
                Text(
                  body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: colors.textSecondary,
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

/// まだ読めない日記。誰の日記かとタイトルだけを出し、本文は伏せる。
/// タップすると、読めるようにするための日記の画面を開く。
/// [onTap] が null なら、その日の日記はもう書けないので読めないことだけを伝える。
class _LockedDiaryCard extends StatelessWidget {
  const _LockedDiaryCard({
    required this.diary,
    required this.name,
    required this.avatarUrl,
    required this.today,
    required this.onTap,
  });

  final Diary diary;
  final String name;
  final String? avatarUrl;
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
          diary.title.isNotEmpty
              ? diary.title
              : context.l10n.diarySectionUntitled,
          hint,
        ),
        excludeSemantics: true,
        child: Material(
          color: colors.surface,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: colors.border),
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CardHeader(name: name, avatarUrl: avatarUrl, isMine: false),
                  const SizedBox(height: 10),
                  // タイトルは続きを読みたくなる予告として見せる。
                  _DiaryTitle(title: diary.title),
                  // 本文の1行目の場所に、読めるようにする方法を出す。
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        size: 14,
                        color: colors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        // 本文の1行ぶんに収め、読めるカードと高さを揃える。
                        child: Text(
                          hint,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
          ),
        ),
      ),
    );
  }
}

/// カード上部の「（アイコン） 名前 の日記」の行。
class _CardHeader extends StatelessWidget {
  const _CardHeader({
    required this.name,
    required this.avatarUrl,
    required this.isMine,
  });

  final String name;
  final String? avatarUrl;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserAvatar(imageUrl: avatarUrl, size: 24),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            context.l10n.diarySectionAuthor(name),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: context.appColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

/// カードの日記のタイトル。1行に収める。
/// タイトルがなければ「タイトルなし」を灰色で出して見た目を揃える。
class _DiaryTitle extends StatelessWidget {
  const _DiaryTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title.isNotEmpty ? title : context.l10n.diarySectionUntitled,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: title.isNotEmpty ? null : context.appColors.disabled,
      ),
    );
  }
}
