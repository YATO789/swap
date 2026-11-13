import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/app_update/app_update.dart';
import '../../../domains/diary/diary.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../providers/diary_book_notifier.dart';
import '../../../infrastructures/repositories/diary_reminder_repository.dart';
import '../../../infrastructures/repositories/opened_notification_repository.dart';
import '../../providers/diary_reminder_notifier.dart';
import '../../providers/settings_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../providers/push_token_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import 'components/add_diary_book_cover.dart';
import 'components/add_diary_book_sheet.dart';
import 'components/diary_book_menu_sheet.dart';
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
import '../router/open_book_page.dart';
import '../router/router.dart';

/// ホーム。日記帳の一覧と、下に「ひとこと」と日記を書くバーを置く。
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
    // サインインしている間、この端末を通知の送り先にしておく。結果は画面に出さない。
    ref.listen(pushTokenProvider, (_, _) {});
    // サインインしている間、日記のリマインダーの予約を合わせておく。結果は画面に出さない。
    ref.listen(diaryReminderProvider, (_, _) {});

    // コントローラーは見ていないと捨てられ、読み直しの途中で状態を書けなくなるので見ておく。
    ref.watch(homePageControllerProvider);
    final controller = ref.read(homePageControllerProvider.notifier);

    // 通知の許可はふつうオンボーディングで聞く。オンボーディングを通らずに来た端末では、ここで聞く。
    useEffect(() {
      controller.requestNotificationPermission();
      return null;
    }, const []);

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
        final update = next.value;
        if (previous?.value?.level == AppUpdateLevel.optional ||
            update == null ||
            update.level != AppUpdateLevel.optional) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!context.mounted) return;
          final updating = await showUpdateSheet(context, update);
          if (updating || !context.mounted) return;
          await controller.skipUpdate();
        });
      }, fireImmediately: true);
      return subscription.close;
    }, const []);

    // 表紙を押して開くときは、その表紙をめくって開く。
    void openDiaryBook(DiaryBook diaryBook, {Rect? coverRect}) =>
        DiaryBookRoute(
          id: diaryBook.id,
          $extra: coverRect == null
              ? null
              : DiaryBookOrigin(diaryBook: diaryBook, rect: coverRect),
        ).push<void>(context);
    void openFromCover(DiaryBook diaryBook, Rect coverRect) =>
        openDiaryBook(diaryBook, coverRect: coverRect);
    // 表紙を長押ししたら、日記帳を開かずに、その日記帳でできることを選ばせる。
    Future<void> openMenu(DiaryBook diaryBook) async {
      HapticFeedback.mediumImpact();
      final action = await showDiaryBookMenuSheet(context, diaryBook);
      if (!context.mounted) return;
      switch (action) {
        case DiaryBookMenuAction.info:
          DiaryBookInfoRoute(id: diaryBook.id).push<void>(context);
        case DiaryBookMenuAction.invite:
          showInviteSheet(context, diaryBook);
        case DiaryBookMenuAction.decorate:
          CoverDecorationRoute(id: diaryBook.id).push<void>(context);
        case null:
          break;
      }
    }

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

    // 日記のリマインダーをタップしたら、今日の日記を書くページを開く。投稿先は書いてから選ぶ。
    useEffect(() {
      final subscription = ref
          .read(diaryReminderRepositoryProvider)
          .opened()
          .listen((_) {
            if (!context.mounted) return;
            final route = DiaryEditorRoute(date: diaryToday(), blank: true);
            // もう日記を書くページを開いていれば、同じページを重ねない。
            if (GoRouter.of(context).state.uri.path ==
                Uri.parse(route.location).path) {
              return;
            }
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
      // 一覧を AppBar の下までのばし、AppBar も書き込みバーと同じく透かして一覧の上に浮かせる。
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
          IconButton(
            onPressed: () => const MyPageRoute().push<void>(context),
            tooltip: l10n.homeProfileAndSettings,
            icon: UserAvatar(imageUrl: profile?.avatarUrl, size: 30),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: switch (diaryBooksState) {
        // 一覧のほかは AppBar の下から出す。
        AsyncValue(hasValue: true) when diaryBooks.isEmpty => SafeArea(
          bottom: false,
          child: EmptyDiaryBooks(
            onCreate: createDiaryBook,
            onJoin: joinDiaryBook,
          ),
        ),
        // AppBar の高さは body の中の MediaQuery にしか入らないので、Builder で読む。
        AsyncValue(hasValue: true) => Builder(
          builder: (context) => RefreshIndicator(
            onRefresh: refresh,
            // 読み直しの印は AppBar の下から出す。
            edgeOffset: MediaQuery.paddingOf(context).top,
            child: paged
                ? _DiaryBookPager(
                    diaryBooks: diaryBooks,
                    onTap: openFromCover,
                    onLongPress: openMenu,
                    onAdd: addDiaryBook,
                  )
                : _DiaryBookGrid(
                    diaryBooks: diaryBooks,
                    onTap: openFromCover,
                    onLongPress: openMenu,
                    onAdd: addDiaryBook,
                  ),
          ),
        ),
        AsyncError() => SafeArea(
          child: Center(
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
        ),
        _ => SafeArea(
          child: Center(
            child: CircularProgressIndicator(color: colors.textSecondary),
          ),
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

/// 日記帳の表紙を横2列に大きく並べ、最後に追加ボタンを置く。
class _DiaryBookGrid extends StatelessWidget {
  const _DiaryBookGrid({
    required this.diaryBooks,
    required this.onTap,
    required this.onLongPress,
    required this.onAdd,
  });

  final List<DiaryBook> diaryBooks;
  final void Function(DiaryBook diaryBook, Rect coverRect) onTap;
  final ValueChanged<DiaryBook> onLongPress;
  final VoidCallback onAdd;

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
            // AppBar に隠れないよう、AppBar の高さぶん上をあける。
            16 + MediaQuery.paddingOf(context).top,
            _padding,
            40 + MediaQuery.paddingOf(context).bottom,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _crossSpacing,
            mainAxisSpacing: _mainSpacing,
            mainAxisExtent: coverWidth * 4 / 3,
          ),
          itemCount: diaryBooks.length + 1,
          itemBuilder: (context, index) {
            if (index == diaryBooks.length) {
              return AddDiaryBookCover(width: coverWidth, onPressed: onAdd);
            }
            return _DiaryBookCover(
              diaryBook: diaryBooks[index],
              width: coverWidth,
              onTap: onTap,
              onLongPress: onLongPress,
            );
          },
        );
      },
    );
  }
}

/// 日記帳を1冊ずつ画面いっぱいに出し、縦にスワイプして切り替える。最後のページは追加ボタン。
class _DiaryBookPager extends HookWidget {
  const _DiaryBookPager({
    required this.diaryBooks,
    required this.onTap,
    required this.onLongPress,
    required this.onAdd,
  });

  final List<DiaryBook> diaryBooks;
  final void Function(DiaryBook diaryBook, Rect coverRect) onTap;
  final ValueChanged<DiaryBook> onLongPress;
  final VoidCallback onAdd;

  static const _horizontalPadding = 40.0;
  static const _topPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final controller = usePageController();
    final page = useState(0);
    // 日記帳が減って、見ていたページがなくなったら最後のページにする。
    final pageCount = diaryBooks.length + 1;
    final current = min(page.value, pageCount - 1);
    // AppBar と下の書き込みバーに隠れないよう、それぞれの高さぶん上と下をあける。
    final topPadding = _topPadding + MediaQuery.paddingOf(context).top;
    final bottomPadding = 40 + MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        PageView.builder(
          controller: controller,
          scrollDirection: Axis.vertical,
          // 1冊でも、引っ張って読み直せるようにする。
          physics: const AlwaysScrollableScrollPhysics(),
          onPageChanged: (index) => page.value = index,
          itemCount: pageCount,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                _horizontalPadding,
                topPadding,
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
                    child: index == diaryBooks.length
                        ? AddDiaryBookCover(width: width, onPressed: onAdd)
                        : _DiaryBookCover(
                            diaryBook: diaryBooks[index],
                            width: width,
                            onTap: onTap,
                            onLongPress: onLongPress,
                          ),
                  );
                },
              ),
            );
          },
        ),
        // 何冊あって今どれを見ているかを、右の縦の点で出す。
        if (pageCount > 1)
          Positioned(
            right: 16,
            top: topPadding,
            bottom: bottomPadding,
            child: ExcludeSemantics(
              child: _PageDots(count: pageCount, current: current),
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

/// 押すと日記帳を開き、長押しするとその日記帳のメニューを開く表紙。
class _DiaryBookCover extends StatelessWidget {
  const _DiaryBookCover({
    required this.diaryBook,
    required this.width,
    required this.onTap,
    required this.onLongPress,
  });

  final DiaryBook diaryBook;
  final double width;
  final void Function(DiaryBook diaryBook, Rect coverRect) onTap;
  final ValueChanged<DiaryBook> onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memberCount = l10n.commonMemberCount(diaryBook.memberCount);

    return Semantics(
      button: true,
      label: l10n.homeDiaryBookSemantics(diaryBook.name, memberCount),
      onLongPressHint: l10n.homeDiaryBookLongPressHint,
      onLongPress: () => onLongPress(diaryBook),
      excludeSemantics: true,
      child: GestureDetector(
        // 開くページに、画面の中での表紙の位置と大きさを渡す。
        onTap: () {
          final box = context.findRenderObject()! as RenderBox;
          onTap(diaryBook, box.localToGlobal(Offset.zero) & box.size);
        },
        onLongPress: () => onLongPress(diaryBook),
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
