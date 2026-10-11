import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../infrastructures/repositories/diary_book_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../components/post_button.dart';
import '../../components/post_sheet/post_sheet.dart';
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

    // TODO: 日記の詳細ページと日記を書くページを移植したらつなぐ。
    void showNotReady(Diary _) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('準備中です')));
    }

    return Scaffold(
      appBar: AppBar(
        // TODO: 2冊以上あれば、タイトルからほかの日記帳に切り替えられるようにする。
        title: DatedTitle(title: diaryBook.name, date: date.value),
        actions: [
          if (date.value != today)
            BackToTodayButton(onPressed: () => date.value = today),
          IconButton(
            onPressed: pickDate,
            tooltip: '日付を選ぶ',
            icon: const Icon(Icons.calendar_month_outlined),
          ),
          // TODO: 日記帳の情報ページ（名前・表紙・メンバー・招待）を開くボタンを置く。
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
          onOpenDiary: showNotReady,
          onWriteDiary: showNotReady,
        ),
        AsyncError() => _LoadError(onRetry: () => controller().refresh()),
        _ => Center(
          child: CircularProgressIndicator(color: colors.textSecondary),
        ),
      },
      // 開いている日記帳に、そのまま記録を書けるようにする。
      bottomNavigationBar: PostButton(
        diaryBook: diaryBook,
        onPosted: () => controller().reloadPosts(),
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
