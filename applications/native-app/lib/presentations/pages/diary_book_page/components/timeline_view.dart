import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';
import '../../../components/dismissible_selectable_text.dart';
import '../../../components/user_avatar.dart';
import 'diary_section.dart';
import '../../../components/reactions.dart';

/// その日の日記と、時間帯ごとの記録を表示するタイムライン。
/// 今日を表示しているときは、今の時間にまだ記録していないほかのメンバーを一番上に出す。
/// 自分の記録は下の書き込みバーから書くので、ここには自分の書き込み欄を置かない。
/// 上下に浮かせたボタンの下までのばして置き、最初と最後はボタンに隠れないようあける。
class TimelineView extends HookWidget {
  const TimelineView({
    super.key,
    required this.heading,
    required this.date,
    required this.myId,
    required this.members,
    required this.diaries,
    required this.posts,
    required this.onRefresh,
    required this.onOpenDiary,
    required this.onWriteDiary,
    required this.onLongPressMyDiary,
    required this.onDeletePost,
    required this.onReact,
  });

  /// いちばん上に置く見出し。上に浮かせたボタンの高さぶんを自分で占め、記録と一緒にスクロールする。
  final Widget heading;

  final DateTime date;
  final String? myId;
  final List<DiaryBookMember> members;

  /// その日の日記。書いた時刻の新しい順。
  final List<Diary> diaries;

  /// その日の記録。古い順。
  final List<TimelinePost> posts;

  /// 引っ張って読み直したとき。
  final Future<void> Function() onRefresh;
  final ValueChanged<Diary> onOpenDiary;
  final ValueChanged<Diary> onWriteDiary;

  /// 自分の日記を長押ししたとき。
  final ValueChanged<Diary> onLongPressMyDiary;

  /// 自分の記録を長押ししたとき。
  final ValueChanged<TimelinePost> onDeletePost;

  /// ほかの人の記録に、自分のリアクションを絵文字で付けたとき。同じ絵文字なら取り消す。
  final void Function(TimelinePost post, String emoji) onReact;

  @override
  Widget build(BuildContext context) {
    // 今の時間の一覧に使う現在時刻。正時ごとに更新する。
    final now = useState(DateTime.now());
    useEffect(() {
      Timer? timer;
      void scheduleNextHour() {
        final current = DateTime.now();
        final nextHour = DateTime(
          current.year,
          current.month,
          current.day,
          current.hour + 1,
        );
        timer = Timer(nextHour.difference(current), () {
          now.value = DateTime.now();
          scheduleNextHour();
        });
      }

      scheduleNextHour();
      return () => timer?.cancel();
    }, const []);

    final membersById = {for (final member in members) member.userId: member};
    // 日記帳を抜けた人の名前は読めない。
    String nameOf(String userId) =>
        membersById[userId]?.displayName ?? context.l10n.commonFormerMember;
    String? avatarUrlOf(String userId) => membersById[userId]?.avatarUrl;

    // 新しい時間帯が上に来るように逆順で表示する。
    final hours = _groupByHour(posts).reversed.toList();
    final currentHour = date == diaryDateOf(now.value) ? now.value.hour : null;
    // 今の時間にまだ記録していない、自分以外のメンバー。記録した人は時間帯の欄に出す。
    final postedIds = {
      for (final post in posts)
        if (post.postedAt.hour == currentHour) post.authorId,
    };
    final pendingMembers = currentHour == null
        ? <DiaryBookMember>[]
        : members
              .where((m) => m.userId != myId && !postedIds.contains(m.userId))
              .toList();
    final insets = MediaQuery.paddingOf(context);
    final bottomPadding = 24 + insets.bottom;

    return RefreshIndicator(
      onRefresh: onRefresh,
      // 読み直しの印は、上に浮かせたボタンの下から出す。
      edgeOffset: insets.top,
      child: CustomScrollView(
        // 記録が少なくても引っ張って読み直せるようにする。
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: heading),
          // 日記があれば記録の上に出す。なければ何も出さない。
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            sliver: SliverToBoxAdapter(
              child: DiarySection(
                diaries: diaries,
                myId: myId,
                nameOf: nameOf,
                avatarUrlOf: avatarUrlOf,
                onOpen: onOpenDiary,
                onWrite: onWriteDiary,
                onLongPressMine: onLongPressMyDiary,
              ),
            ),
          ),
          if (currentHour != null && pendingMembers.isNotEmpty)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _PendingMembersSection(
                  hour: currentHour,
                  members: pendingMembers,
                ),
              ),
            ),
          if (hours.isEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 40, 24, bottomPadding),
              // 今日は白紙のページとして出し、画面が寂しくならないようにする。
              sliver: SliverToBoxAdapter(
                child: currentHour != null
                    ? const _BlankPage()
                    : const _EmptyPosts(),
              ),
            )
          else ...[
            if (pendingMembers.isNotEmpty)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(child: Divider()),
              ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, bottomPadding),
              sliver: SliverList.separated(
                itemCount: hours.length,
                itemBuilder: (context, index) => _HourSection(
                  hour: hours[index],
                  myId: myId,
                  nameOf: nameOf,
                  avatarUrlOf: avatarUrlOf,
                  onDeletePost: onDeletePost,
                  onReact: onReact,
                ),
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ある時間帯（何時台か）の記録。
typedef _TimelineHour = ({int hour, List<TimelinePost> posts});

/// 古い順の記録を、時間帯ごとにまとめる。時間帯も古い順。
/// 日記の日付は朝4時区切りなので、0時台は23時台の後に来る。
List<_TimelineHour> _groupByHour(List<TimelinePost> posts) {
  final byHour = <int, List<TimelinePost>>{};
  for (final post in posts) {
    byHour.putIfAbsent(post.postedAt.hour, () => []).add(post);
  }
  return [
    for (final entry in byHour.entries) (hour: entry.key, posts: entry.value),
  ];
}

class _EmptyPosts extends StatelessWidget {
  const _EmptyPosts();

  @override
  Widget build(BuildContext context) {
    final color = context.appColors.textSecondary;

    return Column(
      children: [
        Icon(Icons.schedule_outlined, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          context.l10n.commonNoPostsThisDay,
          style: TextStyle(fontSize: 14, color: color),
        ),
      ],
    );
  }
}

/// 今日まだ誰も記録していないときに出す、白紙のページ。
class _BlankPage extends StatelessWidget {
  const _BlankPage();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Column(
      children: [
        Text(
          context.l10n.timelineBlankTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          context.l10n.timelineBlankMessage,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: colors.textSecondary),
        ),
      ],
    );
  }
}

class _HourSection extends StatelessWidget {
  const _HourSection({
    required this.hour,
    required this.myId,
    required this.nameOf,
    required this.avatarUrlOf,
    required this.onDeletePost,
    required this.onReact,
  });

  final _TimelineHour hour;
  final String? myId;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final ValueChanged<TimelinePost> onDeletePost;
  final void Function(TimelinePost post, String emoji) onReact;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HourHeader(hour: hour.hour),
          const SizedBox(height: 10),
          for (final post in hour.posts.reversed)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PostCard(
                post: post,
                myId: myId,
                nameOf: nameOf,
                avatarUrlOf: avatarUrlOf,
                onDelete: () => onDeletePost(post),
                onReact: (emoji) => onReact(post, emoji),
              ),
            ),
        ],
      ),
    );
  }
}

class _HourHeader extends StatelessWidget {
  const _HourHeader({required this.hour, this.isNow = false});

  final int hour;

  /// 今の時間の欄では、時間を小さく出して「いま」を添える。
  final bool isNow;

  @override
  Widget build(BuildContext context) {
    final time = '${hour.toString().padLeft(2, '0')}:00';

    return Semantics(
      header: true,
      child: Text(
        isNow ? context.l10n.timelineNowHour(time) : time,
        style: isNow
            ? TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.appColors.textSecondary,
              )
            : const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// 今の時間にまだ記録していない、自分以外のメンバーの欄。記録すると、この欄から外れて時間帯の欄に出る。
/// メンバーは日記帳に参加した順。
class _PendingMembersSection extends StatelessWidget {
  const _PendingMembersSection({required this.hour, required this.members});

  final int hour;
  final List<DiaryBookMember> members;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HourHeader(hour: hour, isNow: true),
          const SizedBox(height: 10),
          _PendingOthersRow(members: members),
        ],
      ),
    );
  }
}

/// まだ記録していない人を1行にまとめる。人数が増えても長くならないよう、
/// アイコンを重ねて、最初の2人の名前と残りの人数を出す。
class _PendingOthersRow extends StatelessWidget {
  const _PendingOthersRow({required this.members});

  final List<DiaryBookMember> members;

  /// 重ねて出すアイコンの数。
  static const _maxAvatars = 4;
  static const _avatarSize = 22.0;

  /// アイコンのまわりに付ける、地の色の縁の太さ。重なった境目を見せる。
  static const _ring = 2.0;

  /// 隣のアイコンと重ねる幅。
  static const _overlap = 8.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final names = [for (final member in members) member.displayName];
    final label = switch (names.length) {
      1 => l10n.timelinePendingOne(names[0]),
      2 => l10n.timelinePendingTwo(names[0], names[1]),
      _ => l10n.timelinePendingMany(names[0], names[1], names.length - 2),
    };
    final shown = members.take(_maxAvatars).toList();
    const outer = _avatarSize + _ring * 2;
    const step = outer - _overlap;

    return Row(
      children: [
        SizedBox(
          width: outer + step * (shown.length - 1),
          height: outer,
          child: Stack(
            children: [
              for (final (index, member) in shown.indexed)
                Positioned(
                  left: step * index,
                  child: Container(
                    padding: const EdgeInsets.all(_ring),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.surface,
                    ),
                    child: UserAvatar(
                      imageUrl: member.avatarUrl,
                      size: _avatarSize,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: colors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.myId,
    required this.nameOf,
    required this.avatarUrlOf,
    required this.onDelete,
    required this.onReact,
    this.lifted = false,
  });

  final TimelinePost post;
  final String? myId;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final VoidCallback onDelete;
  final ValueChanged<String> onReact;

  /// 絵文字を選ぶときに浮かせて出す見本か。押せるところを出さない。
  final bool lifted;

  static const _nameStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  /// 名前の行と本文のあいだ。
  static const double _headerGap = 4;

  /// 左に出す、書いた人のアイコンの大きさ。
  static const double _avatarSize = 36;

  Future<void> _pickReaction(BuildContext context) async {
    final emoji = await showReactionPicker(
      context,
      target: context,
      current: post.reactionOf(myId),
      liftedBuilder: (_) => _PostCard(
        post: post,
        myId: myId,
        nameOf: nameOf,
        avatarUrlOf: avatarUrlOf,
        onDelete: onDelete,
        onReact: onReact,
        lifted: true,
      ),
    );
    if (emoji == null) return;
    onReact(emoji);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final isMine = post.authorId == myId;
    // 自分の記録には付けない。
    final canReact = !isMine && !lifted;
    // ハートの中心を、左のアイコンの中心に合わせる。本文が何行あっても動かさない。
    const buttonTop = (_avatarSize - ReactionButton.size) / 2;

    // 自分の記録は長押しで削除できる。
    return InkWell(
      onLongPress: isMine && !lifted ? onDelete : null,
      borderRadius: BorderRadius.circular(12),
      // 記録は枠で囲まず、アイコンの色で誰のものかを見せる。枠は日記のカードだけに付ける。
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        // 記録が長くても、アイコンは左上に置いたままにする。
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(imageUrl: avatarUrlOf(post.authorId), size: _avatarSize),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 名前・時刻・本文は1つにまとめて読み上げる。リアクションは押せるので分けておく。
                  MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                nameOf(post.authorId),
                                overflow: TextOverflow.ellipsis,
                                style: _nameStyle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              formatTime(post.postedAt),
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: _headerGap),
                        // 本文は長押しからなぞって選び、コピーできるようにする。
                        // 浮かせた見本では選ばせない。
                        if (lifted)
                          Text(
                            post.message,
                            style: const TextStyle(fontSize: 15),
                          )
                        else
                          DismissibleSelectableText(
                            post.message,
                            style: const TextStyle(fontSize: 15),
                          ),
                      ],
                    ),
                  ),
                  if (post.reactions.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    ReactionChips(
                      reactions: post.reactions,
                      myId: myId,
                      nameOf: nameOf,
                      avatarUrlOf: avatarUrlOf,
                      onTap: canReact ? onReact : null,
                    ),
                  ],
                ],
              ),
            ),
            if (canReact)
              Transform.translate(
                offset: const Offset(0, buttonTop),
                child: ReactionButton(
                  current: post.reactionOf(myId),
                  onPressed: () => _pickReaction(context),
                ),
              )
            else if (lifted && !isMine)
              // 浮かせた見本でも、ボタンの場所は空けて元の並びと揃える。
              const SizedBox(width: ReactionButton.size),
          ],
        ),
      ),
    );
  }
}