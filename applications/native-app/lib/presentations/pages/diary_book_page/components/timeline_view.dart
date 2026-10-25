import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary/diary.dart';
import '../../../../domains/diary_book/diary_book_member.dart';
import '../../../../domains/post/timeline_post.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';
import '../../../components/user_avatar.dart';
import 'diary_section.dart';

/// その日の日記と、時間帯ごとの記録を表示するタイムライン。
/// 今日を表示しているときは、今の時間にまだ記録していないメンバーを一番上に出す。
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
    required this.onRecord,
    required this.onOpenDiary,
    required this.onWriteDiary,
    required this.onDeletePost,
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

  /// 今の時間の欄で、自分の「記録」を押したとき。
  final VoidCallback onRecord;
  final ValueChanged<Diary> onOpenDiary;
  final ValueChanged<Diary> onWriteDiary;

  /// 自分の記録を長押ししたとき。
  final ValueChanged<TimelinePost> onDeletePost;

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
    int? avatarColorOf(String userId) => membersById[userId]?.avatarColor;

    // 新しい時間帯が上に来るように逆順で表示する。
    final hours = _groupByHour(posts).reversed.toList();
    final currentHour = date == diaryDateOf(now.value) ? now.value.hour : null;
    // 今の時間にまだ記録していないメンバー。記録した人は時間帯の欄に出す。
    final postedIds = {
      for (final post in posts)
        if (post.postedAt.hour == currentHour) post.authorId,
    };
    final pendingMembers = currentHour == null
        ? <DiaryBookMember>[]
        : members.where((m) => !postedIds.contains(m.userId)).toList();
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
                avatarColorOf: avatarColorOf,
                onOpen: onOpenDiary,
                onWrite: onWriteDiary,
              ),
            ),
          ),
          if (currentHour != null && pendingMembers.isNotEmpty)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                hours.isEmpty ? bottomPadding : 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _PendingMembersSection(
                  hour: currentHour,
                  members: pendingMembers,
                  myId: myId,
                  onRecord: onRecord,
                ),
              ),
            ),
          if (hours.isEmpty) ...[
            if (pendingMembers.isEmpty)
              SliverPadding(
                padding: EdgeInsets.fromLTRB(24, 40, 24, bottomPadding),
                sliver: const SliverToBoxAdapter(child: _EmptyPosts()),
              ),
          ] else ...[
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
                  avatarColorOf: avatarColorOf,
                  onDeletePost: onDeletePost,
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

class _HourSection extends StatelessWidget {
  const _HourSection({
    required this.hour,
    required this.myId,
    required this.nameOf,
    required this.avatarColorOf,
    required this.onDeletePost,
  });

  final _TimelineHour hour;
  final String? myId;
  final String Function(String userId) nameOf;
  final int? Function(String userId) avatarColorOf;
  final ValueChanged<TimelinePost> onDeletePost;

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
                name: nameOf(post.authorId),
                avatarColor: avatarColorOf(post.authorId),
                isMine: post.authorId == myId,
                onDelete: () => onDeletePost(post),
              ),
            ),
        ],
      ),
    );
  }
}

class _HourHeader extends StatelessWidget {
  const _HourHeader({required this.hour, this.small = false});

  final int hour;

  /// まだ記録していない人の欄では、時間を小さく出す。
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        '${hour.toString().padLeft(2, '0')}:00',
        style: small
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

/// 今の時間にまだ記録していないメンバーの欄。記録すると、この欄から外れて時間帯の欄に出る。
/// 自分が一番上で、あとは日記帳に参加した順。
class _PendingMembersSection extends StatelessWidget {
  const _PendingMembersSection({
    required this.hour,
    required this.members,
    required this.myId,
    required this.onRecord,
  });

  final int hour;
  final List<DiaryBookMember> members;
  final String? myId;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final ordered = [
      ...members.where((member) => member.userId == myId),
      ...members.where((member) => member.userId != myId),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HourHeader(hour: hour, small: true),
          const SizedBox(height: 10),
          for (final member in ordered)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _PendingMemberCard(
                name: member.displayName,
                avatarColor: member.avatarColor,
                isMe: member.userId == myId,
                onRecord: onRecord,
              ),
            ),
        ],
      ),
    );
  }
}

/// まだ記録していないメンバーの1人ぶん。自分なら、カードのどこを押しても投稿シートを開く。
class _PendingMemberCard extends StatelessWidget {
  const _PendingMemberCard({
    required this.name,
    required this.avatarColor,
    required this.isMe,
    required this.onRecord,
  });

  final String name;
  final int? avatarColor;
  final bool isMe;
  final VoidCallback onRecord;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // 記録は枠で囲まず、アイコンの色で誰のものかを見せる。枠は日記のカードだけに付ける。
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(name: name, filled: isMe, color: avatarColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.l10n.timelineNoPostsYet,
                    style: TextStyle(fontSize: 14, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (!isMe) return card;

    return InkWell(
      onTap: onRecord,
      borderRadius: BorderRadius.circular(12),
      child: card,
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({
    required this.post,
    required this.name,
    required this.avatarColor,
    required this.isMine,
    required this.onDelete,
  });

  final TimelinePost post;
  final String name;
  final int? avatarColor;
  final bool isMine;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MergeSemantics(
      // 自分の記録は長押しで削除できる。
      child: InkWell(
        onLongPress: isMine ? onDelete : null,
        borderRadius: BorderRadius.circular(12),
        // 記録は枠で囲まず、アイコンの色で誰のものかを見せる。枠は日記のカードだけに付ける。
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          // 記録が長くても、アイコンは左上に置いたままにする。
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(name: name, filled: isMine, color: avatarColor),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatTime(post.postedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(post.message, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
