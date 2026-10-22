import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/app_update/app_update.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../helpers/diary_book_grid_helper.dart';
import '../../helpers/diary_book_helper.dart';
import '../../../infrastructures/repositories/opened_notification_repository.dart';
import '../../helpers/post_hint_helper.dart';
import '../../helpers/profile_helper.dart';
import '../../helpers/push_token_helper.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import 'components/add_diary_book_sheet.dart';
import 'components/empty_diary_books.dart';
import '../../components/invite_sheet.dart';
import 'components/join_diary_book_sheet/join_diary_book_sheet.dart';
import 'components/post_hint.dart';
import 'components/update_sheet.dart';
import '../../components/diary_book_icon.dart';
import '../../components/diary_cover.dart';
import '../../components/post_button.dart';
import '../../components/user_avatar.dart';
import '../../helpers/app_update_helper.dart';
import '../router/router.dart';

/// ホーム。日記帳の一覧と、下に「今なにしてる？」と日記を書くバーを置く。
class HomePage extends HookConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grid = ref.watch(diaryBookGridProvider);

    final colors = context.appColors;
    final l10n = context.l10n;
    final diaryBooksState = ref.watch(diaryBookProvider);
    final diaryBooks = diaryBooksState.value ?? const <DiaryBook>[];
    final profile = ref.watch(profileProvider).value;
    final showPostHint = ref.watch(postHintProvider);
    // 通知の許可はふつうオンボーディングで聞く。オンボーディングを通らずに来た端末
    // （別の端末でサインインし直したときなど）では、ここで聞く。結果は画面に出さない。
    ref.listen(pushTokenProvider, (_, _) {});

    // アプリを開いたら、通知の未読数を 0 に戻す。ホームはサインインしている間ずっと一番下にある。
    void resetUnreadCount() =>
        ref.read(pushTokenProvider.notifier).resetUnreadCount();
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
          await ref.read(appUpdateProvider.notifier).skip();
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
    Future<void> createDiaryBook() async {
      final diaryBook = await const CreateDiaryBookRoute().push<DiaryBook>(
        context,
      );
      if (diaryBook == null || !context.mounted) return;
      await showInviteSheet(context, diaryBook, justCreated: true);
    }

    Future<void> joinDiaryBook() async {
      final diaryBook = await showJoinDiaryBookSheet(context);
      if (diaryBook == null || !context.mounted) return;
      openDiaryBook(diaryBook);
    }

    // 引っ張って一覧を読み直す。ほかの人が変えた名前や表紙を映す。
    Future<void> refresh() async {
      try {
        await ref.read(diaryBookProvider.notifier).refresh();
      } catch (error, stackTrace) {
        debugPrint('日記帳を読み直せませんでした: $error\n$stackTrace');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.homeRefreshFailed)));
      }
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
            icon: UserAvatar(
              name: profile?.displayName ?? '',
              filled: true,
              color: profile?.avatarColor,
              size: 30,
            ),
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
          child: grid
              ? _DiaryBookGrid(diaryBooks: diaryBooks, onTap: openDiaryBook)
              : _DiaryBookList(diaryBooks: diaryBooks, onTap: openDiaryBook),
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

class _DiaryBookList extends StatelessWidget {
  const _DiaryBookList({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      // 日記帳が少なくて画面に収まっても、引っ張って読み直せるようにする。
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 8, bottom: 24),
      children: [
        for (final diaryBook in diaryBooks)
          _ListTile(
            leading: DiaryBookIcon(
              name: diaryBook.name,
              coverColor: diaryBook.coverColor,
              size: 60,
            ),
            title: diaryBook.name,
            subtitle: context.l10n.commonMemberCount(diaryBook.memberCount),
            onTap: () => onTap(diaryBook),
          ),
      ],
    );
  }
}

/// 日記帳の表紙を横2列に大きく並べる。表紙の下に人数を出す。
class _DiaryBookGrid extends StatelessWidget {
  const _DiaryBookGrid({required this.diaryBooks, required this.onTap});

  final List<DiaryBook> diaryBooks;
  final ValueChanged<DiaryBook> onTap;

  static const _padding = 24.0;
  static const _crossSpacing = 20.0;
  static const _mainSpacing = 28.0;

  /// 表紙と人数の間。
  static const _captionGap = 10.0;
  static const _captionHeight = 20.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return LayoutBuilder(
      builder: (context, constraints) {
        final coverWidth =
            (constraints.maxWidth - _padding * 2 - _crossSpacing) / 2;

        return GridView.builder(
          // 日記帳が少なくて画面に収まっても、引っ張って読み直せるようにする。
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(_padding, 16, _padding, 40),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: _crossSpacing,
            mainAxisSpacing: _mainSpacing,
            mainAxisExtent: coverWidth * 4 / 3 + _captionGap + _captionHeight,
          ),
          itemCount: diaryBooks.length,
          itemBuilder: (context, index) {
            final diaryBook = diaryBooks[index];
            final memberCount = l10n.commonMemberCount(diaryBook.memberCount);

            return Semantics(
              button: true,
              label: l10n.homeDiaryBookSemantics(diaryBook.name, memberCount),
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => onTap(diaryBook),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  children: [
                    DiaryCover(
                      name: diaryBook.name,
                      color: diaryBook.coverColor == null
                          ? null
                          : Color(diaryBook.coverColor!),
                      width: coverWidth,
                    ),
                    const SizedBox(height: _captionGap),
                    SizedBox(
                      height: _captionHeight,
                      child: Text(
                        memberCount,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.textSecondary,
                        ),
                        textScaler: TextScaler.noScaling,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: context.l10n.homeDiaryBookSemantics(title, subtitle),
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
