import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/post/timeline_post.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../../components/confirm_sheet.dart';
import '../../components/diary_book_icon.dart';
import '../../components/floating_surface.dart';
import '../../components/floating_top_bar.dart';
import '../../components/page_turn_view.dart';
import '../../components/paper_title.dart';
import '../../components/post_button.dart';
import '../router/router.dart';
import 'components/diary_actions_sheet.dart';
import 'components/timeline_calendar_sheet.dart';
import 'components/timeline_view.dart';
import 'controller/diary_book_page_controller.dart';

/// 日記帳のページ。その日記帳に書かれた日記と、メンバーの記録をタイムラインで表示する。
/// 上に浮かせたカレンダーのボタンから、ほかの日を見られる。
class DiaryBookPage extends HookConsumerWidget {
  const DiaryBookPage({super.key, required this.diaryBookId});

  final String diaryBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    // 開いたまま朝4時を過ぎても今日が変わるよう、読み直したときとアプリに戻ったときに今日を確かめ直す。
    final todayState = useState(diaryToday());
    final today = todayState.value;
    void catchUpToday() {
      todayState.value = diaryToday();
    }

    useOnAppLifecycleStateChange((_, state) {
      if (state == AppLifecycleState.resumed) catchUpToday();
    });
    // カレンダーで選んだ日。null なら今日を見ていて、日付が変わったら新しい今日に移る。
    final pickedDate = useState<DateTime?>(null);
    final date = pickedDate.value ?? today;
    //「この日記帳はもう見られません」というシートをもう出したかどうか
    final notifiedRemoval = useRef(false);

    final diaryBooksState = ref.watch(diaryBookProvider);
    //自分の日記帳の一覧から、今開いている日記帳を1冊探し出す
    final diaryBook = diaryBooksState.value
        ?.where((diaryBook) => diaryBook.id == diaryBookId)
        .firstOrNull;
    final myId = ref.watch(profileProvider).value?.id;

    if (diaryBook == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: diaryBooksState.isLoading
              ? CircularProgressIndicator(color: colors.textSecondary)
              : Text(
                  context.l10n.commonDiaryBookUnavailable,
                  style: TextStyle(color: colors.textSecondary),
                ),
        ),
      );
    }

    final provider = diaryBookPageControllerProvider(diaryBookId, date);
    DiaryBookPageController controller() => ref.read(provider.notifier);

    // 日記帳を開いている間にほかの人に外されたとき、それを知らせてホームに戻す処理
    // 外されたと分かると気まずいので、外されたとは書かない。
    ref.listen(provider, (_, next) async {
      if (next.error is! RemovedFromDiaryBookException) return;
      if (notifiedRemoval.value) return;
      notifiedRemoval.value = true;

      await showNoticeSheet(
        context,
        title: context.l10n.diaryBookNoLongerAvailableTitle(diaryBook.name),
        message: context.l10n.diaryBookNoLongerAvailableMessage,
        buttonLabel: context.l10n.diaryBookBackToHome,
      );
      if (!context.mounted) return;
      final diaryBooks = ref.read(diaryBookProvider.notifier);
      const HomeRoute().go(context);
      diaryBooks.forget(diaryBookId);
    });

    // 見る日を変える。今日なら null にして、日付が変わったら新しい今日に移るようにする。
    void showDay(DateTime day) {
      pickedDate.value = day == today ? null : day;
    }

    Future<void> pickDate() async {
      final picked = await showTimelineCalendar(
        context,
        date: date,
        fetchMarkedDates: controller().fetchMarkedDates,
      );
      if (picked == null) return;
      showDay(picked);
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

    Future<void> confirmDeleteDiary(Diary diary) async {
      final l10n = context.l10n;
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.diaryDetailDeleteTitle,
        message: l10n.diaryDetailDeleteMessage(diaryBook.name),
        irreversible: true,
        confirmLabel: l10n.commonDelete,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final deleted = await ref
          .read(
            diaryBookPageControllerProvider(diaryBookId, diary.date).notifier,
          )
          .deleteDiary(diary);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            deleted ? l10n.diaryDetailDeleted : l10n.diaryDetailDeleteFailed,
          ),
        ),
      );
    }

    // 自分の日記を長押ししたら、編集と削除を選べるようにする。
    Future<void> showMyDiaryActions(Diary diary) async {
      final action = await showDiaryActionsSheet(
        context,
        canEdit: isEditableDiaryDate(diary.date, today: diaryToday()),
      );
      if (!context.mounted) return;
      switch (action) {
        case DiaryAction.edit:
          await writeDiary(diary);
        case DiaryAction.delete:
          await confirmDeleteDiary(diary);
        case null:
          return;
      }
    }

    Future<void> confirmDeletePost(TimelinePost post) async {
      final confirmed = await showConfirmSheet(
        context,
        title: context.l10n.diaryBookDeletePostTitle,
        message: context.l10n.diaryBookDeletePostMessage,
        preview: _PostPreview(diaryBook: diaryBook, post: post),
        irreversible: true,
        confirmLabel: context.l10n.commonDelete,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      final l10n = context.l10n;
      final deleted = await controller().deletePost(post);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            deleted
                ? l10n.diaryBookPostDeleted
                : l10n.diaryBookPostDeleteFailed,
          ),
        ),
      );
    }

    // 押したらすぐ映し、保存できなかったら元に戻して知らせる。
    Future<void> react(TimelinePost post, String emoji) async {
      if (myId == null) return;
      final messenger = ScaffoldMessenger.of(context);
      final l10n = context.l10n;
      final saved = await controller().react(post.id, myId, emoji);
      if (saved) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.diaryBookReactionFailed)),
      );
    }

    // 名前や表紙を変えても、日記帳の一覧から読んでいるのでそのまま映る。
    void openInfo() => DiaryBookInfoRoute(id: diaryBookId).push<void>(context);

    // ページは画面いっぱいにのばしてめくり、上下のボタンはページの上に浮かせる。
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: FloatingTopBar(
        trailing: FloatingSurface(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingSurfaceIcon(
                onPressed: pickDate,
                tooltip: context.l10n.diaryBookPickDate,
                icon: const Icon(Icons.calendar_month_outlined),
              ),
              FloatingSurfaceIcon(
                onPressed: openInfo,
                tooltip: context.l10n.commonDiaryBookInfo,
                icon: const Icon(Icons.info_outline),
              ),
            ],
          ),
        ),
      ),
      // 右にスワイプすると前の日、左にスワイプすると次の日へページをめくる。今日より先には進まない。
      // めくっている間だけ隣の日も出す。触れるのは見ている日だけなので、操作は見ている日に向ける。
      body: PageTurnView<DateTime>(
        page: date,
        previousOf: (day) => DateTime(day.year, day.month, day.day - 1),
        nextOf: (day) {
          final next = DateTime(day.year, day.month, day.day + 1);
          return next.isAfter(today) ? null : next;
        },
        // ページをめくって、ほかの日に移ったとき。
        onChanged: showDay,
        builder: (day) => _DayTimeline(
          diaryBookId: diaryBookId,
          diaryBookName: diaryBook.name,
          date: day,
          myId: myId,
          onRefresh: refresh,
          onOpenDiary: openDiary,
          onWriteDiary: writeDiary,
          onLongPressMyDiary: showMyDiaryActions,
          onDeletePost: confirmDeletePost,
          onReact: react,
        ),
      ),
      // 開いている日記帳に、そのまま記録を書けるようにする。
      // 見ている日が今日か昨日なら、日記はその日のものを書く。
      bottomNavigationBar: PostButton(
        diaryBook: diaryBook,
        diaryDate: isEditableDiaryDate(date, today: today) ? date : null,
        onPosted: () => controller().reloadPosts(),
        onDiaryClosed: () => controller().refresh(),
      ),
    );
  }
}

/// [date] の1日ぶんのページ。その日の日記と記録を読んで出す。
/// いちばん上には、どの日のページかを書いた見出しを、読み込み中や読めなかったときも出す。
class _DayTimeline extends ConsumerWidget {
  const _DayTimeline({
    required this.diaryBookId,
    required this.diaryBookName,
    required this.date,
    required this.myId,
    required this.onRefresh,
    required this.onOpenDiary,
    required this.onWriteDiary,
    required this.onLongPressMyDiary,
    required this.onDeletePost,
    required this.onReact,
  });

  final String diaryBookId;
  final String diaryBookName;
  final DateTime date;
  final String? myId;
  final Future<void> Function() onRefresh;
  final ValueChanged<Diary> onOpenDiary;
  final ValueChanged<Diary> onWriteDiary;
  final ValueChanged<Diary> onLongPressMyDiary;
  final ValueChanged<TimelinePost> onDeletePost;
  final void Function(TimelinePost post, String emoji) onReact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final provider = diaryBookPageControllerProvider(diaryBookId, date);
    final heading = PaperTitle(
      title: diaryBookName,
      subtitle: formatDateWithWeekday(context, date),
    );

    return switch (ref.watch(provider)) {
      AsyncValue(:final value?, hasError: false) => TimelineView(
        heading: heading,
        date: date,
        myId: myId,
        members: value.members,
        diaries: value.diaries,
        posts: value.posts,
        onRefresh: onRefresh,
        onOpenDiary: onOpenDiary,
        onWriteDiary: onWriteDiary,
        onLongPressMyDiary: onLongPressMyDiary,
        onDeletePost: onDeletePost,
        onReact: onReact,
      ),
      // 知らせるダイアログの後ろには、もう読めないことだけを出す。
      AsyncError(error: RemovedFromDiaryBookException()) => _Headed(
        heading: heading,
        child: Text(
          context.l10n.commonDiaryBookUnavailable,
          style: TextStyle(color: colors.textSecondary),
        ),
      ),
      AsyncError() => _Headed(
        heading: heading,
        child: _LoadError(onRetry: () => ref.read(provider.notifier).refresh()),
      ),
      _ => _Headed(
        heading: heading,
        child: CircularProgressIndicator(color: colors.textSecondary),
      ),
    };
  }
}

/// 見出しを上に置き、下に浮かせたボタンまでの残りの真ん中に [child] を出す。
class _Headed extends StatelessWidget {
  const _Headed({required this.heading, required this.child});

  final Widget heading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          heading,
          Expanded(child: Center(child: child)),
        ],
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
            context.l10n.diaryBookLoadFailed,
            style: TextStyle(color: context.appColors.textSecondary),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: onRetry, child: Text(context.l10n.commonRetry)),
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
