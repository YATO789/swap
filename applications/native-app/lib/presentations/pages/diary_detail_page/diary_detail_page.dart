import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/post/timeline_post.dart';
import '../../../domains/reaction/reaction.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../../components/confirm_sheet.dart';
import '../../components/dismissible_selectable_text.dart';
import '../../components/floating_surface.dart';
import '../../components/floating_top_bar.dart';
import '../../components/page_turn_view.dart';
import '../../components/paper_title.dart';
import '../../components/post_line.dart';
import '../../components/reactions.dart';
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
    final title = formatMonthDay(context, date);

    return switch (pageState) {
      AsyncValue(:final value?, hasError: false) when value.diaries.isEmpty =>
        _PlainPage(title: title, child: const _MissingDiary()),
      AsyncValue(:final value?, hasError: false) => _DiaryPages(
        title: title,
        diaryBookId: diaryBookId,
        state: value,
        initialAuthorId: initialAuthorId,
        onRefresh: () => ref.read(provider.notifier).refresh(),
        onDelete: (diary) => ref.read(provider.notifier).delete(diary),
        onReact: (diary, myId, emoji) =>
            ref.read(provider.notifier).react(diary.id, myId, emoji),
      ),
      AsyncError() => _PlainPage(
        title: title,
        child: _LoadError(onRetry: () => ref.read(provider.notifier).refresh()),
      ),
      _ => _PlainPage(
        title: title,
        child: CircularProgressIndicator(color: colors.textSecondary),
      ),
    };
  }
}

/// 日記を出せないときのページ。日記のページと同じく戻るボタンを浮かせ、タイトルを紙に書いて、
/// 残りの真ん中に [child] を出す。
class _PlainPage extends StatelessWidget {
  const _PlainPage({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const FloatingTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PaperTitle(title: title),
          Expanded(child: Center(child: child)),
        ],
      ),
    );
  }
}

/// 読める日記を1ページずつ並べ、本のようにめくる。タイトルと下のページ番号は紙に書いて一緒にめくり、
/// 上のボタンは紙の上に浮かせる。
class _DiaryPages extends HookConsumerWidget {
  const _DiaryPages({
    required this.title,
    required this.diaryBookId,
    required this.state,
    required this.initialAuthorId,
    required this.onRefresh,
    required this.onDelete,
    required this.onReact,
  });

  final String title;
  final String diaryBookId;
  final DiaryDetailPageState state;
  final String? initialAuthorId;
  final Future<void> Function() onRefresh;

  /// 自分の日記を消す。消せたら true。
  final Future<bool> Function(Diary diary) onDelete;

  /// 自分（myId）のリアクションを付ける。同じ絵文字なら取り消す。保存できたら true。
  final Future<bool> Function(Diary diary, String myId, String emoji) onReact;

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

    void turnTo(int page) => index.value = page;

    Future<void> edit() async {
      await DiaryEditorRoute(
        date: diary.date,
        diaryBook: diaryBookId,
      ).push<void>(context);
      await onRefresh();
    }

    // 押したらすぐ映し、保存できなかったら元に戻して知らせる。
    Future<void> react(Diary diary, String emoji) async {
      if (myId == null) return;
      final messenger = ScaffoldMessenger.of(context);
      final l10n = context.l10n;
      final saved = await onReact(diary, myId, emoji);
      if (saved) return;
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.diaryDetailReactionFailed)),
      );
    }

    // 日記帳を抜けた人の名前は読めない。
    String nameOf(String userId) {
      return state.members[userId]?.displayName ??
          context.l10n.commonFormerMember;
    }

    String? avatarUrlOf(String userId) {
      return state.members[userId]?.avatarUrl;
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
      extendBodyBehindAppBar: true,
      appBar: FloatingTopBar(
        trailing: diary.authorId == myId
            ? FloatingSurface(
                child: SizedBox.square(
                  dimension: floatingButtonSize,
                  child: PopupMenuButton<VoidCallback>(
                    tooltip: context.l10n.diaryDetailMenu,
                    icon: const Icon(Icons.more_horiz),
                    onSelected: (action) => action(),
                    itemBuilder: (context) => [
                      if (isEditableDiaryDate(diary.date, today: diaryToday()))
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
                ),
              )
            : null,
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
          // ページにするのは読める日記だけなので、自分の日記でなければリアクションを付けられる。
          final canReact = myId != null && diary.authorId != myId;
          return Column(
            children: [
              // ページ番号の上で本文が切れるよう、下の安全な余白はページ番号の側であける。
              // 上のボタンの高さが入った Scaffold の中の余白から外すため、Builder の context を使う。
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Builder(
                        builder: (context) => MediaQuery.removePadding(
                          context: context,
                          removeBottom: true,
                          child: _DiaryBody(
                            title: title,
                            diary: diary,
                            name: nameOf(diary.authorId),
                            avatarUrl: avatarUrlOf(diary.authorId),
                            isMine: diary.authorId == myId,
                            posts: state.posts[diary.authorId] ?? const [],
                            reactions: _DiaryReactions(
                              reactions: diary.reactions,
                              myId: myId,
                              canReact: canReact,
                              nameOf: nameOf,
                              avatarUrlOf: avatarUrlOf,
                              onTap: (emoji) => react(diary, emoji),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // リアクションのボタンは、どこまで読んでいても押せるよう右下に浮かせる。
                    if (canReact)
                      Positioned(
                        right: _reactionButtonRight,
                        bottom: _reactionButtonBottom,
                        child: _FloatingReactionButton(
                          current: diary.reactionOf(myId),
                          onPicked: (emoji) => react(diary, emoji),
                        ),
                      ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                // 1ページだけならページ番号は出さない。
                child: pageCount > 1
                    ? _PageNumber(number: page + 1)
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 右下に浮かせるリアクションボタンの位置。
const _reactionButtonRight = 20.0;
const _reactionButtonBottom = 16.0;

/// 本文の終わりで、浮かせたボタンに重ならないようにあける高さ。
const _reactionButtonClearance =
    _reactionButtonBottom +
    ReactionButton.floatingSize +
    8 -
    _bodyBottomPadding;

/// 右下に浮かせる、リアクションを付けるボタン。押すと絵文字の吹き出しを出す。
class _FloatingReactionButton extends StatelessWidget {
  const _FloatingReactionButton({
    required this.current,
    required this.onPicked,
  });

  /// 自分が付けた絵文字。付けていなければ null。
  final String? current;
  final ValueChanged<String> onPicked;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (button) => ReactionButton(
        floating: true,
        current: current,
        onPressed: () async {
          final emoji = await showReactionPicker(
            context,
            target: button,
            current: current,
          );
          if (emoji != null) onPicked(emoji);
        },
      ),
    );
  }
}

/// 本文を読み終えたところに、付いたリアクションを左から並べる。
/// 最後までスクロールしても右下のボタンに隠れないよう、ボタンの高さぶんをあけておく。
class _DiaryReactions extends StatelessWidget {
  const _DiaryReactions({
    required this.reactions,
    required this.myId,
    required this.canReact,
    required this.nameOf,
    required this.avatarUrlOf,
    required this.onTap,
  });

  final List<Reaction> reactions;
  final String? myId;

  /// ほかの人の日記なら、チップを押してその絵文字で付けられる。
  final bool canReact;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    if (!canReact && reactions.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        top: 12,
        bottom: canReact ? 0 : 12,
        // チップがボタンの下にもぐらないよう、ボタンの幅ぶん右をあける。
        right: canReact
            ? ReactionButton.floatingSize + _reactionButtonRight - 24 + 8
            : 0,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: canReact ? _reactionButtonClearance - 12 : 0,
        ),
        child: Align(
          alignment: Alignment.topLeft,
          child: ReactionChips(
            reactions: reactions,
            myId: myId,
            nameOf: nameOf,
            avatarUrlOf: avatarUrlOf,
            onTap: canReact ? onTap : null,
          ),
        ),
      ),
    );
  }
}

/// 紙の下に書くページ番号。本のページ番号のように、数字だけを小さく書く。
class _PageNumber extends StatelessWidget {
  const _PageNumber({required this.number});

  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        '$number',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: context.appColors.textSecondary,
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

/// 罫線の下、ページ番号との間にあける高さ。
const _bodyBottomPadding = 8.0;

/// 1人ぶんの日記のページ。いちばん上にタイトルを書き、上下に浮かせたボタンの下まで広げる。
/// 本文の罫線は、本文が短くてもページの下まで引く。
class _DiaryBody extends StatelessWidget {
  const _DiaryBody({
    required this.title,
    required this.diary,
    required this.name,
    required this.avatarUrl,
    required this.isMine,
    required this.posts,
    required this.reactions,
  });

  /// ページのいちばん上に書く日付。
  final String title;

  final Diary diary;
  final String name;
  final String? avatarUrl;
  final bool isMine;

  /// 書いた人のその日の記録。古い順。
  final List<TimelinePost> posts;

  /// 本文を読み終えたところに出す、付いたリアクション。
  final Widget reactions;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final diaryTitle = diary.title;
    final body = diary.body ?? '';

    final header = [
      PaperTitle(title: title),
      const SizedBox(height: 8),
      Row(
        children: [
          UserAvatar(imageUrl: avatarUrl),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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
      if (diaryTitle.isNotEmpty) ...[
        DismissibleSelectableText(
          diaryTitle,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Container(height: 1, color: colors.border),
        const SizedBox(height: 8),
      ],
    ];

    return CustomScrollView(
      slivers: [
        // 上は PaperTitle がボタンの高さぶんを占めるので、あけない。
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList.list(children: header),
        ),
        // 本文の上までの高さが分かってから、残りの高さいっぱいに罫線を引く。
        SliverLayoutBuilder(
          builder: (context, constraints) {
            final remaining =
                constraints.viewportMainAxisExtent -
                constraints.precedingScrollExtent -
                _bodyBottomPadding;
            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, _bodyBottomPadding),
              sliver: SliverToBoxAdapter(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final lines = measureTextLines(
                      context,
                      text: body,
                      style: DefaultTextStyle.of(context).style
                          .merge(_bodyStyle),
                      strutStyle: _bodyStrut,
                      width: constraints.maxWidth,
                    );
                    return RuledLines(
                      lineHeight: lines.lineHeight,
                      filledLines: lines.count,
                      fadeOut: false,
                      // 本文だけの高さだと下まで引けないので、残りの高さを空けておく。
                      // リアクションは本文を読み終えたところに、罫線の上に置く。
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: remaining),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DismissibleSelectableText(
                              body,
                              style: _bodyStyle,
                              strutStyle: _bodyStrut,
                            ),
                            reactions,
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
