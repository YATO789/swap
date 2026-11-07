import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../domains/post/post_comment.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../../utils/format.dart';
import '../../../components/confirm_sheet.dart';
import '../../../components/emoji_sheet.dart';
import '../../../components/reactions.dart';
import '../../../components/user_avatar.dart';
import '../controller/diary_book_page_controller.dart';

/// 記録の「反応する」ボタンを押したときに出す画面。リアクションの吹き出しを広げたもの。
/// 暗くした画面の上に、上から絵文字の吹き出し・浮かせた記録・これまでのコメントを重ね、いちばん下に入力欄を置く。
/// [canReact] が false（自分の記録）なら絵文字の吹き出しは出さず、コメントだけにする。
/// 選んだ絵文字を返す（「＋」なら全部の絵文字のシートから選んだもの）。絵文字を選ばずに閉じたら null。
/// コメントはこの画面の中で送ったり消したりし、送っても画面は閉じない。
/// コメントは [diaryBookId] の日記帳の [date] のページのコントローラーから読み書きする。
Future<String?> showPostResponder(
  BuildContext context, {
  required BuildContext target,
  required String diaryBookId,
  required DateTime date,
  required String postId,
  required String? myId,
  required bool canReact,
  required String? current,
  required String hintText,
  required String Function(String userId) nameOf,
  required String? Function(String userId) avatarUrlOf,
  required WidgetBuilder liftedBuilder,
}) async {
  final box = target.findRenderObject()! as RenderBox;
  final rect = box.localToGlobal(Offset.zero) & box.size;

  // 画面の遷移（PageRoute）にすると、下の画面が iOS 風に左へずれてしまうので、ダイアログとして出す。
  final picked = await showGeneralDialog<String>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.32),
    barrierLabel: context.l10n.commonClose,
    transitionDuration: const Duration(milliseconds: 180),
    // 出方は中で決めるので、ここでは何も足さない。
    transitionBuilder: (_, _, _, child) => child,
    pageBuilder: (context, animation, _) => _PostResponderOverlay(
      targetRect: rect,
      diaryBookId: diaryBookId,
      date: date,
      postId: postId,
      myId: myId,
      canReact: canReact,
      current: current,
      hintText: hintText,
      nameOf: nameOf,
      avatarUrlOf: avatarUrlOf,
      liftedBuilder: liftedBuilder,
      animation: animation,
    ),
  );
  if (picked != moreEmojis) return picked;
  if (!context.mounted) return null;
  return showEmojiSheet(context);
}

/// 浮かせた記録・吹き出し・コメントのあいだ。
const _gap = 8.0;

class _PostResponderOverlay extends HookConsumerWidget {
  const _PostResponderOverlay({
    required this.targetRect,
    required this.diaryBookId,
    required this.date,
    required this.postId,
    required this.myId,
    required this.canReact,
    required this.current,
    required this.hintText,
    required this.nameOf,
    required this.avatarUrlOf,
    required this.liftedBuilder,
    required this.animation,
  });

  final Rect targetRect;
  final String diaryBookId;
  final DateTime date;
  final String postId;
  final String? myId;
  final bool canReact;
  final String? current;

  /// 入力欄のヒント。
  final String hintText;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final WidgetBuilder liftedBuilder;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final provider = diaryBookPageControllerProvider(diaryBookId, date);
    final comments = ref.watch(
      provider.select(
        (state) =>
            state.value?.posts
                .where((post) => post.id == postId)
                .firstOrNull
                ?.comments ??
            const <PostComment>[],
      ),
    );
    final controller = useTextEditingController();
    useListenable(controller);
    final commentsScroll = useScrollController();
    final sending = useState(false);
    // 送れなかった・消せなかったときに、入力欄の上に出す知らせ。
    final error = useState<String?>(null);

    // 入力欄の高さ。浮かせた部分をこの上までに収める。複数行になったら測り直す。
    final inputKey = useMemoized(GlobalKey.new);
    final inputHeight = useState(72.0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      final height = inputKey.currentContext?.size?.height;
      if (height != null && height != inputHeight.value) {
        inputHeight.value = height;
      }
    });

    Future<void> send() async {
      final message = controller.text.trim();
      if (message.isEmpty || sending.value) return;
      sending.value = true;
      error.value = null;
      final sent = await ref
          .read(provider.notifier)
          .addComment(postId, message);
      if (!context.mounted) return;
      sending.value = false;
      if (!sent) {
        // 書いた文字は残して、もう一度送れるようにする。
        error.value = l10n.commentSendFailed;
        return;
      }
      controller.clear();
      // 送ったコメントが見えるよう、いちばん下までスクロールする。
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!commentsScroll.hasClients) return;
        commentsScroll.animateTo(
          commentsScroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      });
    }

    Future<void> confirmDelete(PostComment comment) async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.commentDeleteTitle,
        preview: ConfirmPreview(
          child: Text(comment.message, style: const TextStyle(fontSize: 15)),
        ),
        irreversible: true,
        confirmLabel: l10n.commonDelete,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;
      error.value = null;
      final deleted = await ref
          .read(provider.notifier)
          .deleteComment(postId, comment);
      if (!context.mounted) return;
      if (!deleted) error.value = l10n.commentDeleteFailed;
    }

    // 浮かせる記録は、左右に少し余白を足して角を丸めたカードにする（リアクションの吹き出しと同じ）。
    final liftedRect = Rect.fromLTRB(
      targetRect.left - 12,
      targetRect.top - 4,
      targetRect.right + 12,
      targetRect.bottom + 4,
    );
    final barSpace = canReact ? reactionBarHeight + _gap : 0.0;
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: CustomSingleChildLayout(
            delegate: _GroupLayout(
              preferredTop: liftedRect.top - barSpace,
              minTop: media.padding.top + _gap,
              maxBottom:
                  media.size.height -
                  media.viewInsets.bottom -
                  inputHeight.value -
                  _gap,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: liftedRect.left,
                right: max(0, media.size.width - liftedRect.right),
              ),
              child: FadeTransition(
                opacity: animation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (canReact) ...[
                      Align(
                        alignment: Alignment.centerRight,
                        child: ScaleTransition(
                          scale: curved,
                          alignment: Alignment.bottomRight,
                          child: ReactionBar(current: current),
                        ),
                      ),
                      const SizedBox(height: _gap),
                    ],
                    _Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        child: IgnorePointer(child: liftedBuilder(context)),
                      ),
                    ),
                    // コメントがなければコメントの欄は出さない。送ったら出す。
                    if (comments.isNotEmpty) ...[
                      const SizedBox(height: _gap),
                      Flexible(
                        child: _Card(
                          child: ListView.builder(
                            controller: commentsScroll,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return _CommentTile(
                                comment: comment,
                                name: nameOf(comment.userId),
                                avatarUrl: avatarUrlOf(comment.userId),
                                // 自分のコメントは長押しで消せる。
                                onLongPress: comment.userId == myId
                                    ? () => confirmDelete(comment)
                                    : null,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: media.viewInsets.bottom,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: _CommentInput(
              key: inputKey,
              controller: controller,
              // 自分の記録では絵文字を選ばないので、すぐ書けるようにキーボードを出す。
              // ほかの人の記録では、絵文字だけ付けたいときに邪魔にならないよう、入力欄を押すまで出さない。
              autofocus: !canReact,
              hintText: hintText,
              sending: sending.value,
              error: error.value,
              onSend: send,
            ),
          ),
        ),
      ],
    );
  }
}

/// 吹き出し・記録・コメントのまとまりを、できるだけ元の記録の位置に置く。
/// 下の入力欄（とキーボード）に重なるなら上へずらし、画面の上からはみ出さないようにする。
class _GroupLayout extends SingleChildLayoutDelegate {
  const _GroupLayout({
    required this.preferredTop,
    required this.minTop,
    required this.maxBottom,
  });

  final double preferredTop;
  final double minTop;
  final double maxBottom;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      maxHeight: max(0, maxBottom - minTop),
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final top = min(preferredTop, maxBottom - childSize.height);
    return Offset(0, max(minTop, top));
  }

  @override
  bool shouldRelayout(_GroupLayout oldDelegate) {
    return oldDelegate.preferredTop != preferredTop ||
        oldDelegate.minTop != minTop ||
        oldDelegate.maxBottom != maxBottom;
  }
}

/// 浮かせて見せる、角の丸い紙の色のカード。
class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.appColors.surface,
      elevation: 8,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// コメント1件。書いた人のアイコン・名前・時刻と本文。
class _CommentTile extends StatelessWidget {
  const _CommentTile({
    required this.comment,
    required this.name,
    required this.avatarUrl,
    required this.onLongPress,
  });

  final PostComment comment;
  final String name;
  final String? avatarUrl;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return MergeSemantics(
      child: InkWell(
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserAvatar(imageUrl: avatarUrl, size: 28),
              const SizedBox(width: 10),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          formatTime(comment.createdAt),
                          style: TextStyle(
                            fontSize: 13,
                            color: colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(comment.message, style: const TextStyle(fontSize: 14)),
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

/// 画面の下に置く、コメントの入力欄と送るボタン。
/// [error] があれば入力欄の上に出す。
class _CommentInput extends StatelessWidget {
  const _CommentInput({
    super.key,
    required this.controller,
    required this.autofocus,
    required this.hintText,
    required this.sending,
    required this.error,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool autofocus;
  final String hintText;
  final bool sending;
  final String? error;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final error = this.error;
    final canSend = !sending && controller.text.trim().isNotEmpty;

    return Material(
      color: colors.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (error != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                  child: Semantics(
                    liveRegion: true,
                    child: Text(
                      error,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      autofocus: autofocus,
                      // 送っている間は書き換えさせない。
                      readOnly: sending,
                      maxLength: maxCommentMessageLength,
                      minLines: 1,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      style: const TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: hintText,
                        // 上限で止まるので、文字数は出さない。
                        counterText: '',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: colors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                          borderSide: BorderSide(color: colors.textPrimary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton.filled(
                    onPressed: canSend ? onSend : null,
                    tooltip: context.l10n.commentSend,
                    style: IconButton.styleFrom(
                      backgroundColor: colors.textPrimary,
                      foregroundColor: colors.surface,
                      disabledBackgroundColor: colors.disabled,
                      disabledForegroundColor: colors.surface,
                    ),
                    icon: sending
                        ? SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.surface,
                            ),
                          )
                        : const Icon(Icons.arrow_upward, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
