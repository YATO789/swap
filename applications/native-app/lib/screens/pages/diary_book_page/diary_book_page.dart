import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/post/timeline_post.dart';
import '../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../components/post_button.dart';
import '../../components/post_sheet/post_sheet.dart';
import '../router/router.dart';
import 'components/dated_title.dart';
import 'components/timeline_calendar_sheet.dart';
import 'components/timeline_view.dart';
import 'controller/diary_book_page_controller.dart';

/// 日記帳のページ。その日記帳に書かれた日記と、メンバーの記録をタイムラインで表示する。
/// AppBar のカレンダーから、ほかの日を見られる。
class DiaryBookPage extends HookConsumerWidget {
  const DiaryBookPage({super.key, required this.diaryBookId});

  final String diaryBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final today = diaryDateOf(DateTime.now());
    final date = useState(today);
    final notifiedRemoval = useRef(false);

    final diaryBooksState = ref.watch(diaryBookRepositoryProvider);
    final diaryBook = diaryBooksState.value
        ?.where((diaryBook) => diaryBook.id == diaryBookId)
        .firstOrNull;
    final myId = ref.watch(profileRepositoryProvider).value?.id;

    if (diaryBook == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: diaryBooksState.isLoading
              ? CircularProgressIndicator(color: colors.textSecondary)
              : Text(
                  'この日記帳は表示できません',
                  style: TextStyle(color: colors.textSecondary),
                ),
        ),
      );
    }

    final provider = diaryBookPageControllerProvider(diaryBookId, date.value);
    final pageState = ref.watch(provider);
    DiaryBookPageController controller() => ref.read(provider.notifier);

    // 開いている間に外されたら、もう見られないことを知らせてホームに戻る。読み直すたびに出さないよう1回だけ。
    // 外されたと分かると気まずいので、外されたとは書かない。
    ref.listen(provider, (_, next) async {
      if (next.error is! RemovedFromDiaryBookException) return;
      if (notifiedRemoval.value) return;
      notifiedRemoval.value = true;

      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text('「${diaryBook.name}」は見られなくなりました'),
          content: const Text('この日記帳の記録や日記は表示できません。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      );
      if (!context.mounted) return;
      final diaryBooks = ref.read(diaryBookRepositoryProvider.notifier);
      GoRouter.of(context).go(AppRoutes.home);
      diaryBooks.forget(diaryBookId);
    });

    Future<void> record() async {
      final posted = await showPostSheet(context, diaryBook: diaryBook);
      if (posted) await controller().reloadPosts();
    }

    Future<void> pickDate() async {
      final picked = await showTimelineCalendar(
        context,
        date: date.value,
        fetchMarkedDates: controller().fetchMarkedDates,
      );
      if (picked != null) date.value = picked;
    }

    // 日記を読んだり書いたりしたページから戻ったら、編集や削除を映すため読み直す。
    Future<void> openDiary(Diary diary) async {
      await context.push(
        AppRoutes.diaryDetailOf(
          diaryBookId,
          diary.date,
          authorId: diary.authorId,
        ),
      );
      await controller().refresh();
    }

    Future<void> writeDiary(Diary diary) async {
      await context.push(
        AppRoutes.diaryEditorOf(diary.date, diaryBookId: diaryBookId),
      );
      await controller().refresh();
    }

    Future<void> confirmDeletePost(TimelinePost post) async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('記録を削除しますか？'),
          content: Text(
            '「${diaryBook.name}」から「${post.message}」を削除します。'
            'ほかの日記帳に出した分は残ります。この操作は取り消せません。',
          ),
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
      final deleted = await controller().deletePost(post);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(deleted ? '記録を削除しました' : '記録を削除できませんでした。もう一度お試しください'),
        ),
      );
    }

    // 名前や表紙を変えても、日記帳の一覧から読んでいるのでそのまま映る。
    void openInfo() => context.push(AppRoutes.diaryBookInfoOf(diaryBookId));

    return Scaffold(
      appBar: AppBar(
        title: DatedTitle(title: diaryBook.name, date: date.value),
        actions: [
          IconButton(
            onPressed: pickDate,
            tooltip: '日付を選ぶ',
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          IconButton(
            onPressed: openInfo,
            tooltip: '日記帳の情報',
            icon: const Icon(Icons.info_outline),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: switch (pageState) {
        AsyncValue(:final value?, hasError: false) => TimelineView(
          date: date.value,
          myId: myId,
          members: value.members,
          diaries: value.diaries,
          posts: value.posts,
          onRefresh: () => controller().refresh(),
          onRecord: record,
          onOpenDiary: openDiary,
          onWriteDiary: writeDiary,
          onDeletePost: confirmDeletePost,
        ),
        // 知らせるダイアログの後ろには、もう読めないことだけを出す。
        AsyncError(error: RemovedFromDiaryBookException()) => Center(
          child: Text(
            'この日記帳は表示できません',
            style: TextStyle(color: colors.textSecondary),
          ),
        ),
        AsyncError() => _LoadError(onRetry: () => controller().refresh()),
        _ => Center(
          child: CircularProgressIndicator(color: colors.textSecondary),
        ),
      },
      // 開いている日記帳に、そのまま記録を書けるようにする。
      // 見ている日が今日か昨日なら、日記はその日のものを書く。
      bottomNavigationBar: PostButton(
        diaryBook: diaryBook,
        diaryDate: isEditableDiaryDate(date.value, today: today)
            ? date.value
            : null,
        onPosted: () => controller().reloadPosts(),
        onDiaryClosed: () => controller().refresh(),
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
            '日記帳を読み込めませんでした',
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: const Text('もう一度試す')),
        ],
      ),
    );
  }
}
