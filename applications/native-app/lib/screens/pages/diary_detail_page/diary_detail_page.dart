import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/post/timeline_post.dart';
import '../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
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
    final title = Text('${date.month}月${date.day}日の日記');

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

/// 読める日記を1ページずつ並べる。見出しと下のページ番号は固定して、日記の部分だけを横にスライドする。
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
    final pageController = usePageController(initialPage: initialIndex);

    /// 今開いているページ。読み直して日記が減っても、はみ出さないようにする。
    final index = useState(initialIndex);
    final current = index.value.clamp(0, pageCount - 1);
    final diary = diaries[current];

    final myId = ref.watch(profileRepositoryProvider).value?.id;
    final error = Theme.of(context).colorScheme.error;

    void turnTo(int page) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }

    Future<void> edit() async {
      await DiaryEditorRoute(
        date: diary.date,
        diaryBook: diaryBookId,
      ).push<void>(context);
      await onRefresh();
    }

    Future<void> confirmDelete() async {
      final diaryBookName =
          ref
              .read(diaryBookRepositoryProvider)
              .value
              ?.where((diaryBook) => diaryBook.id == diaryBookId)
              .firstOrNull
              ?.name ??
          '日記帳';
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('日記を削除しますか？'),
          content: Text('「$diaryBookName」からこの日記を削除します。この操作は取り消せません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('削除'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final deleted = await onDelete(diary);
      messenger.hideCurrentSnackBar();
      if (!deleted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('日記を削除できませんでした。もう一度お試しください')),
        );
        return;
      }
      messenger.showSnackBar(const SnackBar(content: Text('日記を削除しました')));
      if (context.mounted) Navigator.of(context).pop();
    }

    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: [
          if (diary.authorId == myId)
            PopupMenuButton<VoidCallback>(
              tooltip: 'メニュー',
              icon: const Icon(Icons.more_horiz),
              onSelected: (action) => action(),
              itemBuilder: (context) => [
                if (isEditableDiaryDate(
                  diary.date,
                  today: diaryDateOf(DateTime.now()),
                ))
                  PopupMenuItem(
                    value: edit,
                    child: const ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('編集'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                PopupMenuItem(
                  value: confirmDelete,
                  child: ListTile(
                    leading: Icon(Icons.delete_outline, color: error),
                    title: Text('削除', style: TextStyle(color: error)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        itemCount: pageCount,
        onPageChanged: (page) => index.value = page,
        itemBuilder: (context, page) {
          final diary = diaries[page];
          return _DiaryBody(
            diary: diary,
            // 日記帳を抜けた人の名前は読めない。
            name: state.names[diary.authorId] ?? '抜けたメンバー',
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
              tooltip: '前の日記',
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
              tooltip: '次の日記',
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
        'この日記は表示できません',
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
            '日記を読み込めませんでした',
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('もう一度試す')),
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
    required this.isMine,
    required this.posts,
  });

  final Diary diary;
  final String name;
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
            UserAvatar(name: name, filled: isMine),
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
              '${formatTime(diary.writtenAt)}に書きました',
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // 日記を書く画面と同じく、その日の記録を本文の上に出す。
        Text(
          'この日の記録',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        if (posts.isEmpty)
          Text(
            'この日の記録はありません',
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
