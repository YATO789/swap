import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/app_update/app_update.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../providers/diary_book_notifier.dart';
import '../../../infrastructures/repositories/opened_notification_repository.dart';
import '../../providers/settings_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../providers/push_token_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import 'components/add_diary_book_sheet.dart';
import 'components/empty_diary_books.dart';
import '../../components/invite_sheet.dart';
import 'components/join_diary_book_sheet/join_diary_book_sheet.dart';
import 'components/post_hint.dart';
import 'components/update_sheet.dart';
import 'controller/home_page_controller.dart';
import '../../components/diary_cover.dart';
import '../../components/post_button.dart';
import '../../components/user_avatar.dart';
import '../../providers/app_update_notifier.dart';
import '../router/router.dart';

/// ホーム。日記帳の一覧と、下に「今なにしてる？」と日記を書くバーを置く。
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final diaryBooksState = ref.watch(diaryBookProvider);
    final diaryBooks = diaryBooksState.value ?? const <DiaryBook>[];
    final profile = ref.watch(profileProvider).value;
    final showPostHint = ref.watch(
      settingsProvider.select((settings) => settings.postHintVisible),
    );
    final paged = ref.watch(
      settingsProvider.select((settings) => settings.diaryBookPaged),
    );
    // 通知の許可はふつうオンボーディングで聞く。オンボーディングを通らずに来た端末
    // （別の端末でサインインし直したときなど）では、ここで聞く。結果は画面に出さない。
    ref.listen(pushTokenProvider, (_, _) {});

    // コントローラーは見ていないと捨てられ、読み直しの途中で状態を書けなくなるので見ておく。
    ref.watch(homePageControllerProvider);
    final controller = ref.read(homePageControllerProvider.notifier);

    // アプリを開いたら、通知の未読数を 0 に戻す。ホームはサインインしている間ずっと一番下にある。
    void resetUnreadCount() => controller.resetUnreadCount();
    useEffect(() {
      resetUnreadCount();
      return null;
    }, const []);
    useOnAppLifecycleStateChange((_, state) {
      if (state == AppLifecycleState.resumed) resetUnreadCount();
    });

    // 新しいバージョンがあれば、一度だけ知らせる。ホームを開く前に確かめ終わっていることもある。
    // アップデートしないと使えないときは、ルーターがアップデートの画面に切り替える。
    useEffect(() {
      final subscription = ref.listenManual(appUpdateProvider, (
        previous,
        next,
      ) {
        if (previous?.value == AppUpdate.optional ||
            next.value != AppUpdate.optional) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;
          final updating = await showUpdateSheet(context);
          if (updating || !context.mounted) return;
          await controller.skipUpdate();
        });
      }, fireImmediately: true);
      return subscription.close;
    }, const []);

    void openDiaryBook(DiaryBook diaryBook) =>
        DiaryBookRoute(id: diaryBook.id).push<void>(context);

    // 記録の通知をタップしたら、その日記帳を開く。ホームはサインインしている間ずっと
    // 一番下にあるので、ほかのページを開いていても、その上に重ねる。
    useEffect(() {
      final subscription = ref
          .read(openedNotificationRepositoryProvider)
          .openedDiaryBookIds()
          .listen((diaryBookId) {
            if (!context.mounted) return;
            final route = DiaryBookRoute(id: diaryBookId);
            // もうその日記帳を一番上に開いていれば、同じページを重ねない。
            if (GoRouter.of(context).state.uri.path == route.location) return;
            route.push<void>(context);
          });
      return subscription.cancel;
    }, const []);

    // 作ったらホームに戻り、そのまま友達を招待するシートを出す。
    // 作った直後がいちばん飾りたくなるので、表紙を飾る入口も添える。
    Future<void> createDiaryBook() async {
      final diaryBook = await const CreateDiaryBookRoute().push<DiaryBook>(
        context,
      );
      if (diaryBook == null || !context.mounted) return;
      await showInviteSheet(
        context,
        diaryBook,
        justCreated: true,
        onDecorateCover: () =>
            CoverDecorationRoute(id: diaryBook.id).push<void>(context),
      );
    }

    Future<void> joinDiaryBook() async {
      final diaryBook = await showJoinDiaryBookSheet(context);
      if (diaryBook == null || !context.mounted) return;
      openDiaryBook(diaryBook);
    }

    // 引っ張って一覧を読み直す。
    Future<void> refresh() async {
      final refreshed = await controller.refresh();
      if (refreshed || !context.mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.homeRefreshFailed)));
    }

    Future<void> addDiaryBook() async {
      final action = await showAddDiaryBookSheet(context);
      if (!context.mounted) return;
      switch (action) {
        case AddDiaryBookAction.create:
          createDiaryBook();
        case AddDiaryBookAction.join:
          joinDiaryBook();
        case null:
          break;
      }
    }

    return Scaffold(
      // 一覧を書き込みバーの下までのばし、バーは一覧の上に浮かせる。
      extendBody: true,
      appBar: AppBar(
        // アプリアイコンから地色と星を抜いた、ロゴの文字だけを置く。
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/icons/swap_title.png',
              height: 24,
              semanticLabel: 'Swap!',
            ),
          ),
        ),
        leadingWidth: 120,
        actions: [
          // 日記帳がないうちは、画面の真ん中から作るか参加できるので出さない。
          if (diaryBooks.isNotEmpty)
            IconButton(
              onPressed: addDiaryBook,
              tooltip: l10n.homeAddDiaryBook,
              icon: const Icon(Icons.add),
            ),
          IconButton(
            onPressed: () => const MyPageRoute().push<void>(context),
            tooltip: l10n.homeProfileAndSettings,
            icon: UserAvatar(imageUrl: profile?.avatarUrl, size: 30),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: switch (diaryBooksState) {
        AsyncValue(hasValue: true) when diaryBooks.isEmpty => EmptyDiaryBooks(
          onCreate: createDiaryBook,
          onJoin: joinDiaryBook,
        ),
        AsyncValue(hasValue: true) => RefreshIndicator(
          onRefresh: refresh,
          child: paged
              ? _DiaryBookPager(diaryBooks: diaryBooks, onTap: openDiaryBook)
              : _DiaryBookGrid(diaryBooks: diaryBooks, onTap: openDiaryBook),
        ),
        AsyncError() => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.homeLoadFailed,
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => ref.invalidate(diaryBookProvider),
                child: Text(l10n.commonRetry),
              ),
            ],
          ),
        ),
        _ => Center(
          child: CircularProgressIndicator(color: colors.textSecondary),
        ),
      },
      // 日記帳に1冊も入っていないうちは、書いても見せる相手がいないので出さない。
      // 入力欄とペンに手書きの説明を重ねる。設定画面で消せる。
      bottomNavigationBar: diaryBooks.isEmpty
          ? null
          : Stack(
              clipBehavior: Clip.none,
              children: [
                const PostButton(),
                Positioned.fill(child: PostHint(visible: showPostHint)),
              ],
            ),
    );
  }
}

/// 日記帳の表紙を横2列に大きく並べる。
class _DiaryBookGrid extends StatelessWidget {
  const _DiaryBookGrid({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  static const _padding = 24.0;
  static const _crossSpacing = 20.0;
  static const _mainSpacing = 28.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final coverWidth =
            (constraints.maxWidth - _padding * 2 - _crossSpacing) / 2;

        return GridView.builder(
          // 日記帳が少なくて画面に収まっても、引っ張って読み直せるようにする。
          physics: const AlwaysScrollableScrollPhysics(),
          // 下の書き込みバーに隠れないよう、バーの高さぶん下をあける。
          padding: EdgeInsets.fromLTRB(
            _padding,
            16,
            _padding,
            40 + MediaQuery.paddingOf(context).bottom,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _crossSpacing,
            mainAxisSpacing: _mainSpacing,
            mainAxisExtent: coverWidth * 4 / 3,
          ),
          itemCount: diaryBooks.length,
          itemBuilder: (context, index) {
            return _DiaryBookCover(
              diaryBook: diaryBooks[index],
              width: coverWidth,
              onTap: onTap,
            );
          },
        );
      },
    );
  }
}

/// 日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替える。
class _DiaryBookPager extends HookWidget {
  const _DiaryBookPager({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  static const _horizontalPadding = 40.0;
  static const _topPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final page = useState(0);
    // 日記帳が減って、見ていたページがなくなったら最後のページにする。
    final current = min(page.value, diaryBooks.length - 1);
    // 下の書き込みバーに隠れないよう、バーの高さぶん下をあける。
    final bottomPadding = 40 + MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          // 1冊でも、引っ張って読み直せるようにする。
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: (index) => page.value = index,
          itemCount: diaryBooks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                _topPadding,
                _horizontalPadding,
                bottomPadding,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // 表紙は 3:4。幅と高さのどちらかいっぱいまで大きくする。
                  final width = min(
                    constraints.maxWidth,
                    constraints.maxHeight * 3 / 4,
                  );
                  return Center(
                    child: _DiaryBookCover(
                      diaryBook: diaryBooks[index],
                      width: width,
                      onTap: onTap,
                    ),
                  );
                },
              ),
            );
          },
        ),
        // 何冊あって今どれを見ているかを、右の縦の点で出す。
        if (diaryBooks.length > 1)
          Positioned(
            right: 16,
            top: _topPadding,
            bottom: bottomPadding,
            child: ExcludeSemantics(
              child: _PageDots(count: diaryBooks.length, current: current),
            ),
          ),
      ],
    );
  }
}

/// 縦に並べた点で、[count] ページのうち [current] ページ目を見ていることを出す。
class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 3),
            width: 6,
            height: i == current ? 18 : 6,
            decoration: BoxDecoration(
              color: i == current ? colors.textPrimary : colors.disabled,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}

/// 押すと日記帳を開く表紙。
class _DiaryBookCover extends StatelessWidget {
  const _DiaryBookCover({
    required this.diaryBook,
    required this.width,
    required this.onTap,
  });

  final DiaryBook diaryBook;
  final double width;
  final ValueChanged<DiaryBook> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memberCount = l10n.commonMemberCount(diaryBook.memberCount);

    return Semantics(
      button: true,
      label: l10n.homeDiaryBookSemantics(diaryBook.name, memberCount),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: () => onTap(diaryBook),
        behavior: HitTestBehavior.opaque,
        child: DiaryCover(
          name: diaryBook.name,
          color: diaryBook.coverColor == null
              ? null
              : Color(diaryBook.coverColor!),
          width: width,
          decoration: diaryBook.coverDecoration,
        ),
      ),
    );
  }
}
