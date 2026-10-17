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
import 'delete_post_picker_sheet.dart';
import 'diary_section.dart';

/// その日の日記と、時間帯ごとの記録を表示するタイムライン。
/// 今日を表示しているときは、今の時間をメンバー一覧で出す。
class TimelineView extends HookWidget {
  const TimelineView({
    super.key,
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

    final hours = _groupByHour(posts);
    final currentHour = date == diaryDateOf(now.value) ? now.value.hour : null;
    // 新しい時間帯が上に来るように逆順で表示する。
    final otherHours = hours
        .where((hour) => hour.hour != currentHour)
        .toList()
        .reversed
        .toList();
    const bottomPadding = 24.0;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
        // 記録が少なくても引っ張って読み直せるようにする。
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
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
          if (currentHour != null)
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                24,
                0,
                24,
                otherHours.isEmpty ? bottomPadding : 0,
              ),
              sliver: SliverToBoxAdapter(
                child: _CurrentHourSection(
                  hour: currentHour,
                  members: members,
                  myId: myId,
                  onRecord: onRecord,
                  onDeletePost: onDeletePost,
                  posts: [
                    for (final hour in hours)
                      if (hour.hour == currentHour) ...hour.posts,
                  ],
                ),
              ),
            ),
          if (otherHours.isEmpty) ...[
            if (currentHour == null)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(24, 40, 24, bottomPadding),
                sliver: SliverToBoxAdapter(child: _EmptyPosts()),
              ),
          ] else ...[
            if (currentHour != null)
              const SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverToBoxAdapter(child: Divider()),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, bottomPadding),
              sliver: SliverList.separated(
                itemCount: otherHours.length,
                itemBuilder: (context, index) => _HourSection(
                  hour: otherHours[index],
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
  const _HourHeader({required this.hour});

  final int hour;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        '${hour.toString().padLeft(2, '0')}:00',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// 今の時間の欄。記録の有無にかかわらずメンバー全員を出す。
/// 自分が一番上で、あとは日記帳に参加した順。
class _CurrentHourSection extends StatelessWidget {
  const _CurrentHourSection({
    required this.hour,
    required this.members,
    required this.myId,
    required this.onRecord,
    required this.onDeletePost,
    required this.posts,
  });

  final int hour;
  final List<DiaryBookMember> members;
  final String? myId;
  final VoidCallback onRecord;
  final ValueChanged<TimelinePost> onDeletePost;

  /// 今の時間の記録（古い順）。
  final List<TimelinePost> posts;

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
          _HourHeader(hour: hour),
          const SizedBox(height: 10),
          for (final member in ordered)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _MemberCard(
                name: member.displayName,
                avatarColor: member.avatarColor,
                isMe: member.userId == myId,
                onRecord: onRecord,
                onDeletePost: onDeletePost,
                posts: [
                  // 新しい記録が上に来るように逆順にする。
                  for (final post in posts.reversed)
                    if (post.authorId == member.userId) post,
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// 今の時間の欄の1人ぶん。自分がまだ記録していなければ、
/// カードのどこを押しても投稿シートを開く。
class _MemberCard extends StatelessWidget {
  const _MemberCard({
    required this.name,
    required this.avatarColor,
    required this.isMe,
    required this.onRecord,
    required this.onDeletePost,
    required this.posts,
  });

  final String name;
  final int? avatarColor;
  final bool isMe;
  final VoidCallback onRecord;
  final ValueChanged<TimelinePost> onDeletePost;
  final List<TimelinePost> posts;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final canRecord = posts.isEmpty && isMe;

    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: MergeSemantics(
        // 記録が何行あっても、アイコンは左上に置いたままにする。
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
                  if (posts.isEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      context.l10n.timelineNoPostsYet,
                      style: TextStyle(
                        fontSize: 14,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                  for (final post in posts) ...[
                    const SizedBox(height: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          formatTime(post.postedAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            post.message,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
    if (canRecord) {
      return InkWell(
        onTap: onRecord,
        borderRadius: BorderRadius.circular(12),
        child: card,
      );
    }
    if (!isMe || posts.isEmpty) return card;

    // 自分の記録はカードの長押しで削除できる。複数あれば、どれを消すか選ばせる。
    Future<void> deletePost() async {
      final post = posts.length == 1
          ? posts.single
          : await showDeletePostPickerSheet(context, posts: posts);
      if (post != null) onDeletePost(post);
    }

    return InkWell(
      onLongPress: deletePost,
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
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(12),
          ),
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
