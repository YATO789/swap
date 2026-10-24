import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/post/timeline_post.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../../components/confirm_sheet.dart';
import '../../components/page_turn_view.dart';
import '../../components/post_line.dart';
import '../../components/ruled_lines.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'controller/diary_detail_page_controller.dart';

/// その日の日記の全文と、書いた人のその日の記録を表示する。
/// 横にスワイプして、同じ日記帳の同じ日のほかの人の日記を読める。
class DiaryDetailPage extends HookConsumerWidget {
  const DiaryDetailPage({
    super.key,
    required this.diaryBookId,
    required this.date,
    this.initialAuthorId,
  });

  /// 日記を書いた日記帳。
  final String diaryBookId;
  final DateTime date;

  /// 最初に開くページの投稿者。null なら先頭のページ。
  final String? initialAuthorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final provider = diaryDetailPageControllerProvider(diaryBookId, date);
    final pageState = ref.watch(provider);
    final title = Text(
      context.l10n.commonDiaryOfDate(formatMonthDay(context, date)),
    );

    return switch (pageState) {
      AsyncValue(:final value?, hasError: false) when value.diaries.isEmpty =>
        Scaffold(
          appBar: AppBar(title: title),
          body: const _MissingDiary(),
        ),
      AsyncValue(:final value?, hasError: false) => _DiaryPages(
        title: title,
        diaryBookId: diaryBookId,
        state: value,
        initialAuthorId: initialAuthorId,
        onRefresh: () => ref.read(provider.notifier).refresh(),
        onDelete: (diary) => ref.read(provider.notifier).delete(diary),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: _LoadError(onRetry: () => ref.read(provider.notifier).refresh()),
      ),
      _ => Scaffold(
        appBar: AppBar(title: title),
        body: Center(
          child: CircularProgressIndicator(color: colors.textSecondary),
        ),
      ),
    };
  }
}

/// 読める日記を1ページずつ並べる。見出しと下のページ番号は固定して、日記の部分だけを本のようにめくる。
class _DiaryPages extends HookConsumerWidget {
  const _DiaryPages({
    required this.title,
    required this.diaryBookId,
    required this.state,
    required this.initialAuthorId,
    required this.onRefresh,
    required this.onDelete,
  });

  final Widget title;
  final String diaryBookId;
  final DiaryDetailPageState state;
  final String? initialAuthorId;
  final Future<void> Function() onRefresh;

  /// 自分の日記を消す。消せたら true。
  final Future<bool> Function(Diary diary) onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaries = state.diaries;
    final pageCount = diaries.length;
    final initialIndex = diaries
        .indexWhere((diary) => diary.authorId == initialAuthorId)
        .clamp(0, pageCount - 1);

    /// 今開いているページ。読み直して日記が減っても、はみ出さないようにする。
    final index = useState(initialIndex);
    final current = index.value.clamp(0, pageCount - 1);
    final diary = diaries[current];

    final myId = ref.watch(profileProvider).value?.id;
    final error = Theme.of(context).colorScheme.error;

    // ボタンで変えたときも、PageTurnView がその向きに1枚めくる。
    void turnTo(int page) => index.value = page;

    Future<void> edit() async {
      await DiaryEditorRoute(
        date: diary.date,
        diaryBook: diaryBookId,
      ).push<void>(context);
      await onRefresh();
    }

    Future<void> confirmDelete() async {
      final l10n = context.l10n;
      final diaryBookName =
          ref
              .read(diaryBookProvider)
              .value
              ?.where((diaryBook) => diaryBook.id == diaryBookId)
              .firstOrNull
              ?.name ??
          l10n.diaryDetailFallbackDiaryBookName;
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.diaryDetailDeleteTitle,
        message: l10n.diaryDetailDeleteMessage(diaryBookName),
        irreversible: true,
        confirmLabel: l10n.commonDelete,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final deleted = await onDelete(diary);
      messenger.hideCurrentSnackBar();
      if (!deleted) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.diaryDetailDeleteFailed)),
        );
        return;
      }
      messenger.showSnackBar(SnackBar(content: Text(l10n.diaryDetailDeleted)));
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          if (diary.authorId == myId)
            PopupMenuButton<VoidCallback>(
              tooltip: context.l10n.diaryDetailMenu,
              icon: const Icon(Icons.more_horiz),
              onSelected: (action) => action(),
              itemBuilder: (context) => [
                if (isEditableDiaryDate(
                  diary.date,
                  today: diaryDateOf(DateTime.now()),
                ))
                  PopupMenuItem(
                    value: edit,
                    child: ListTile(
                      leading: const Icon(Icons.edit_outlined),
                      title: Text(context.l10n.diaryDetailEdit),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                PopupMenuItem(
                  value: confirmDelete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: error),
                    title: Text(
                      context.l10n.diaryDetailDelete,
                      style: TextStyle(color: error),
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      // 左にスワイプすると次の人、右にスワイプすると前の人の日記へページをめくる。
      body: PageTurnView<int>(
        page: current,
        previousOf: (page) => page > 0 ? page - 1 : null,
        nextOf: (page) => page < pageCount - 1 ? page + 1 : null,
        onChanged: turnTo,
        builder: (page) {
          // めくっている間に読み直して日記が減っても、はみ出さないようにする。
          final diary = diaries[page.clamp(0, pageCount - 1)];
          return _DiaryBody(
            diary: diary,
            // 日記帳を抜けた人の名前は読めない。
            name:
                state.members[diary.authorId]?.displayName ??
                context.l10n.commonFormerMember,
            avatarColor: state.members[diary.authorId]?.avatarColor,
            isMine: diary.authorId == myId,
            posts: state.posts[diary.authorId] ?? const [],
          );
        },
      ),
      bottomNavigationBar: pageCount > 1
          ? _PageFooter(
              index: current,
              count: pageCount,
              onPrevious: current > 0 ? () => turnTo(current - 1) : null,
              onNext: current < pageCount - 1
                  ? () => turnTo(current + 1)
                  : null,
            )
          : null,
    );
  }
}

/// 画面下の「‹ 2 / 5 ›」。今どのページかを示し、ボタンでもめくれるようにする。
class _PageFooter extends StatelessWidget {
  const _PageFooter({
    required this.index,
    required this.count,
    required this.onPrevious,
    required this.onNext,
  });

  final int index;
  final int count;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.border)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              tooltip: context.l10n.diaryDetailPrevious,
              icon: const Icon(Icons.chevron_left),
            ),
            Expanded(
              child: Text(
                '${index + 1} / $count',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: colors.textSecondary,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              tooltip: context.l10n.diaryDetailNext,
              icon: const Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}

/// 読める日記がないとき（消えたときや、読めない日記のリンクを開いたとき）の表示。
class _MissingDiary extends StatelessWidget {
  const _MissingDiary();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        context.l10n.diaryDetailUnavailable,
        style: TextStyle(fontSize: 14, color: context.appColors.textSecondary),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.diaryDetailLoadFailed,
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
        ],
      ),
    );
  }
}

// 罫線の間隔は日記を書く画面の本文と揃える。
const _bodyFontSize = 16.0;
const _bodyLineHeight = 2.2;
const _bodyStyle = TextStyle(fontSize: _bodyFontSize, height: _bodyLineHeight);

/// 本文の1行の高さを固定する。罫線と文字が下の行までずれないようにするため。
const _bodyStrut = StrutStyle(
  fontSize: _bodyFontSize,
  height: _bodyLineHeight,
  forceStrutHeight: true,
);

/// 書いた行の下に足す、薄くなっていく罫線の本数。書く画面と揃える。
const _fadingLines = 6;

class _DiaryBody extends StatelessWidget {
  const _DiaryBody({
    required this.diary,
    required this.name,
    required this.avatarColor,
    required this.isMine,
    required this.posts,
  });

  final Diary diary;
  final String name;
  final int? avatarColor;
  final bool isMine;

  /// 書いた人のその日の記録。古い順。
  final List<TimelinePost> posts;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final title = diary.title ?? '';
    final body = diary.body ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      children: [
        Row(
          children: [
            UserAvatar(name: name, filled: isMine, color: avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              context.l10n.diaryDetailWrittenAt(formatTime(diary.writtenAt)),
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 日記を書く画面と同じく、その日の記録を本文の上に出す。
        Text(
          context.l10n.diaryDetailPostsOfDay,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (posts.isEmpty)
          Text(
            context.l10n.commonNoPostsThisDay,
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
          )
        else
          for (final post in posts) PostLine(post: post),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 20),
        // 日記を書く画面と同じく、タイトルの下に線を引き、本文には罫線を敷く。
        if (title.isNotEmpty) ...[
          SelectableText(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: colors.border),
          const SizedBox(height: 8),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final lines = measureTextLines(
              context,
              text: body,
              style: DefaultTextStyle.of(context).style.merge(_bodyStyle),
              strutStyle: _bodyStrut,
              width: constraints.maxWidth,
            );
            final filledLines = lines.count;
            return RuledLines(
              lineHeight: lines.lineHeight,
              lineCount: _fadingLines,
              filledLines: filledLines,
              // 書く画面と同じく、書いた行の下にだんだん薄くなる罫線を足す。
              // 本文だけの高さだと引けないので、その分の高さを空けておく。
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: lines.lineHeight * (filledLines + _fadingLines),
                ),
                child: SelectableText(
                  body,
                  style: _bodyStyle,
                  strutStyle: _bodyStrut,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
