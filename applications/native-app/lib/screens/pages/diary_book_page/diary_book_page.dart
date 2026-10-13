import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/post/timeline_post.dart';
import '../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../../components/confirm_sheet.dart';
import '../../components/diary_book_icon.dart';
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
    // 開いたまま朝4時を過ぎても今日が変わるよう、読み直したときとアプリに戻ったときに今日を確かめ直す。
    final todayState = useState(diaryDateOf(DateTime.now()));
    final today = todayState.value;
    void catchUpToday() => todayState.value = diaryDateOf(DateTime.now());
    useOnAppLifecycleStateChange((_, state) {
      if (state == AppLifecycleState.resumed) catchUpToday();
    });
    // カレンダーで選んだ日。null なら今日を見ていて、日付が変わったら新しい今日に移る。
    final pickedDate = useState<DateTime?>(null);
    final date = pickedDate.value ?? today;
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

    final provider = diaryBookPageControllerProvider(diaryBookId, date);
    final pageState = ref.watch(provider);
    DiaryBookPageController controller() => ref.read(provider.notifier);

    // 開いている間に外されたら、もう見られないことを知らせてホームに戻る。読み直すたびに出さないよう1回だけ。
    // 外されたと分かると気まずいので、外されたとは書かない。
    ref.listen(provider, (_, next) async {
      if (next.error is! RemovedFromDiaryBookException) return;
      if (notifiedRemoval.value) return;
      notifiedRemoval.value = true;

      await showNoticeSheet(
        context,
        title: '「${diaryBook.name}」は見られなくなりました',
        message: 'この日記帳の記録や日記は表示できません。',
        buttonLabel: 'ホームに戻る',
      );
      if (!context.mounted) return;
      final diaryBooks = ref.read(diaryBookRepositoryProvider.notifier);
      const HomeRoute().go(context);
      diaryBooks.forget(diaryBookId);
    });

    Future<void> record() async {
      final posted = await showPostSheet(context, diaryBook: diaryBook);
      if (posted) await controller().reloadPosts();
    }

    Future<void> pickDate() async {
      final picked = await showTimelineCalendar(
        context,
        date: date,
        fetchMarkedDates: controller().fetchMarkedDates,
      );
      if (picked == null) return;
      pickedDate.value = picked == today ? null : picked;
    }

    // 引っ張って読み直したとき、今日を見ていて日付が変わっていれば、新しい今日を読む。
    Future<void> refresh() async {
      catchUpToday();
      if (pickedDate.value == null && todayState.value != today) return;
      await controller().refresh();
    }

    // 日記を読んだり書いたりしたページから戻ったら、編集や削除を映すため読み直す。
    Future<void> openDiary(Diary diary) async {
      await DiaryDetailRoute(
        id: diaryBookId,
        date: diary.date,
        author: diary.authorId,
      ).push<void>(context);
      await controller().refresh();
    }

    Future<void> writeDiary(Diary diary) async {
      await DiaryEditorRoute(
        date: diary.date,
        diaryBook: diaryBookId,
      ).push<void>(context);
      await controller().refresh();
    }

    Future<void> confirmDeletePost(TimelinePost post) async {
      final confirmed = await showConfirmSheet(
        context,
        title: '記録を削除しますか？',
        message: 'ほかの日記帳に出した分は残ります。',
        preview: _PostPreview(diaryBook: diaryBook, post: post),
        irreversible: true,
        confirmLabel: '削除する',
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
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
    void openInfo() => DiaryBookInfoRoute(id: diaryBookId).push<void>(context);

    return Scaffold(
      appBar: AppBar(
        title: DatedTitle(title: diaryBook.name, date: date),
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
          date: date,
          myId: myId,
          members: value.members,
          diaries: value.diaries,
          posts: value.posts,
          onRefresh: refresh,
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
        diaryDate: isEditableDiaryDate(date, today: today)
            ? date
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

/// 消す記録。どの日記帳のいつの記録かと、その本文を見せる。
class _PostPreview extends StatelessWidget {
  const _PostPreview({required this.diaryBook, required this.post});

  final DiaryBook diaryBook;
  final TimelinePost post;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ConfirmPreview(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DiaryBookIcon(
                name: diaryBook.name,
                coverColor: diaryBook.coverColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  diaryBook.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                ' · ${formatTime(post.postedAt)}',
                style: TextStyle(fontSize: 12, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            post.message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
