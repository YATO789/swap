import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../domains/post/timeline_post.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/emoji_sheet.dart';
import '../../../components/user_avatar.dart';

/// ハートを押したときに並べる、よく使う絵文字。❤️ を先頭に置いて、いつもの良いねは2タップで付けられるようにする。
const quickReactions = ['❤️', '😂', '😮', '😢', '👏'];

/// 絵文字の吹き出しで「＋」を押したときに返す値。
const _moreEmojis = '+';

/// 吹き出しの大きさ。絵文字5つと「＋」が並ぶ。
const _barButtonSize = 44.0;
const _barGap = 2.0;
const _barPadding = 6.0;

/// よく使う絵文字5つと「＋」。
const _barButtonCount = 6;
const _barWidth =
    _barButtonSize * _barButtonCount +
    _barGap * (_barButtonCount - 1) +
    _barPadding * 2;
const _barHeight = _barButtonSize + _barPadding * 2;

/// リアクションを付けるボタン。まだ付けていなければハート、付けていればその絵文字を出す。
class ReactionButton extends StatelessWidget {
  const ReactionButton({
    super.key,
    required this.current,
    required this.onPressed,
  });

  /// 自分が付けた絵文字。付けていなければ null。
  final String? current;
  final VoidCallback onPressed;

  /// ボタン全体（押せる範囲）の一辺。中の丸は 34。
  static const double size = 48;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final current = this.current;
    final label = current == null
        ? l10n.reactionAdd
        : l10n.reactionChange(current);
    final content = current == null
        ? Icon(Icons.favorite_border, size: 18, color: colors.textSecondary)
        : _Emoji(current, size: 18);

    return IconButton(
      onPressed: onPressed,
      tooltip: label,
      padding: const EdgeInsets.all((size - 34) / 2),
      constraints: const BoxConstraints.tightFor(width: size, height: size),
      icon: _GlassCircle(size: 34, child: content),
    );
  }
}

/// 絵文字を1つ、上下の真ん中に来るように出す。
/// 行の高さは本文のフォントで決まり、絵文字は少し下に寄って見えるので、行の高さを文字の大きさに揃える。
/// 部品の大きさに合わせてあるので、文字の大きさの設定では大きくしない。
class _Emoji extends StatelessWidget {
  const _Emoji(this.emoji, {required this.size});

  final String emoji;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      textScaler: TextScaler.noScaling,
      style: TextStyle(fontSize: size),
      strutStyle: StrutStyle(
        fontSize: size,
        height: 1,
        leadingDistribution: TextLeadingDistribution.even,
        forceStrutHeight: true,
      ),
    );
  }
}

/// ガラス玉のように見える丸。上から下へ明るさを少し落とし、上半分につやを乗せ、
/// 細い縁と薄い影でほんの少し浮かせる。
class _GlassCircle extends StatelessWidget {
  const _GlassCircle({required this.size, required this.child});

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const white = Colors.white;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [white.withValues(alpha: 0.20), white.withValues(alpha: 0.06)]
              : const [Color(0xFFFFFFFF), Color(0xFFF1F3F6)],
        ),
        border: Border.all(
          color: isDark
              ? white.withValues(alpha: 0.16)
              : Colors.black.withValues(alpha: 0.06),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 上半分のつや。
          Positioned(
            top: size * 0.05,
            left: size * 0.14,
            right: size * 0.14,
            height: size * 0.46,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(size * 0.36, size * 0.23),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    white.withValues(alpha: isDark ? 0.14 : 0.7),
                    white.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

/// 付いたリアクションを絵文字ごとにまとめ、押した人のアイコンを並べる。
/// 自分が入っている絵文字は枠を濃くする。[onTap] があれば、押すとその絵文字で自分も付ける（自分のものなら取り消す）。
class ReactionChips extends StatelessWidget {
  const ReactionChips({
    super.key,
    required this.reactions,
    required this.myId,
    required this.nameOf,
    required this.avatarUrlOf,
    this.onTap,
  });

  /// 付いたリアクション。付けた順。
  final List<PostReaction> reactions;
  final String? myId;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    // 絵文字ごとに、最初に付けられた順に並べる。
    final byEmoji = <String, List<String>>{};
    for (final reaction in reactions) {
      byEmoji.putIfAbsent(reaction.emoji, () => []).add(reaction.userId);
    }
    final onTap = this.onTap;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final entry in byEmoji.entries)
          _ReactionChip(
            emoji: entry.key,
            reactors: entry.value,
            myId: myId,
            nameOf: nameOf,
            avatarUrlOf: avatarUrlOf,
            onTap: onTap == null ? null : () => onTap(entry.key),
          ),
      ],
    );
  }
}

class _ReactionChip extends StatelessWidget {
  const _ReactionChip({
    required this.emoji,
    required this.reactors,
    required this.myId,
    required this.nameOf,
    required this.avatarUrlOf,
    required this.onTap,
  });

  final String emoji;
  final List<String> reactors;
  final String? myId;
  final String Function(String userId) nameOf;
  final String? Function(String userId) avatarUrlOf;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final isMine = reactors.contains(myId);
    final background = isMine ? colors.placeholder : colors.surface;
    final names = [
      for (final reactor in reactors)
        reactor == myId ? l10n.reactionYou : nameOf(reactor),
    ].join(l10n.reactionNameSeparator);

    // チップごとに1つの読み上げにする。中の InkWell は読み上げから外すので、押す操作はここで渡す。
    return Semantics(
      container: true,
      button: onTap != null,
      label: l10n.reactionChipLabel(names, emoji),
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: StadiumBorder(
          side: BorderSide(color: isMine ? colors.textPrimary : colors.border),
        ),
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 3, 8, 3),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Emoji(emoji, size: 15),
                const SizedBox(width: 4),
                _AvatarStack(
                  avatarUrls: [
                    for (final reactor in reactors) avatarUrlOf(reactor),
                  ],
                  ringColor: background,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 押した人のアイコンを少し重ねて並べる。多いときは3人まで出して残りは数にする。
class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.avatarUrls, required this.ringColor});

  final List<String?> avatarUrls;

  /// 重なりを見分けるための縁の色。チップの地の色に合わせる。
  final Color ringColor;

  static const _maxShown = 3;
  static const _size = 20.0;
  static const _step = 14.0;

  @override
  Widget build(BuildContext context) {
    final shown = avatarUrls.take(_maxShown).toList();
    final rest = avatarUrls.length - shown.length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: _size + _step * (shown.length - 1),
          height: _size,
          child: Stack(
            children: [
              for (final (index, avatarUrl) in shown.indexed)
                Positioned(
                  left: _step * index,
                  child: Container(
                    width: _size,
                    height: _size,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ringColor,
                    ),
                    child: UserAvatar(imageUrl: avatarUrl, size: 17),
                  ),
                ),
            ],
          ),
        ),
        if (rest > 0) ...[
          const SizedBox(width: 3),
          Text(
            '+$rest',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: context.appColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// ハートを押したときの絵文字の吹き出しを出し、選んだ絵文字を返す。閉じたら null。
/// [target] は吹き出しを寄せる部品。[liftedBuilder] があれば、その部品を暗くした画面の上に浮かせて出す
/// （どの記録に付けるのかが分かるように）。「＋」を押したら全部の絵文字から選ぶシートを開く。
Future<String?> showReactionPicker(
  BuildContext context, {
  required BuildContext target,
  required String? current,
  WidgetBuilder? liftedBuilder,
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
    pageBuilder: (context, animation, _) => _ReactionPickerOverlay(
      targetRect: rect,
      current: current,
      liftedBuilder: liftedBuilder,
      animation: animation,
    ),
  );
  if (picked != _moreEmojis) return picked;
  if (!context.mounted) return null;
  return showEmojiSheet(context);
}

class _ReactionPickerOverlay extends StatelessWidget {
  const _ReactionPickerOverlay({
    required this.targetRect,
    required this.current,
    required this.liftedBuilder,
    required this.animation,
  });

  final Rect targetRect;
  final String? current;
  final WidgetBuilder? liftedBuilder;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final media = MediaQuery.of(context);
    final screenWidth = media.size.width;
    final liftedBuilder = this.liftedBuilder;

    // 浮かせる部品は、左右に少し余白を足して角を丸めたカードにする。
    final liftedRect = liftedBuilder == null
        ? targetRect
        : Rect.fromLTRB(
            targetRect.left - 12,
            targetRect.top - 4,
            targetRect.right + 12,
            targetRect.bottom + 4,
          );
    // 吹き出しは上に出す。上に入りきらなければ下に出す。
    final above = liftedRect.top - 8 - _barHeight;
    final barTop = above >= media.padding.top + 8
        ? above
        : liftedRect.bottom + 8;
    // 浮かせた記録があれば右端に揃え、なければボタンの真上に出す。
    final preferredLeft = liftedBuilder == null
        ? targetRect.center.dx - _barWidth / 2
        : liftedRect.right - _barWidth;
    final barLeft = min(
      max(preferredLeft, 12.0),
      max(12.0, screenWidth - 12 - _barWidth),
    );
    final curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    return Stack(
      children: [
        if (liftedBuilder != null)
          Positioned.fromRect(
            rect: liftedRect,
            child: IgnorePointer(
              child: Material(
                color: colors.surface,
                elevation: 8,
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: liftedBuilder(context),
                ),
              ),
            ),
          ),
        Positioned(
          left: barLeft,
          top: barTop,
          child: ScaleTransition(
            scale: curved,
            alignment: barTop < liftedRect.top
                ? Alignment.bottomRight
                : Alignment.topRight,
            child: FadeTransition(
              opacity: animation,
              child: _ReactionBar(current: current),
            ),
          ),
        ),
      ],
    );
  }
}

/// よく使う絵文字と「＋」を並べた吹き出し。
class _ReactionBar extends StatelessWidget {
  const _ReactionBar({required this.current});

  final String? current;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final current = this.current;

    return Material(
      color: colors.surface,
      elevation: 8,
      shape: const StadiumBorder(),
      child: Padding(
        padding: const EdgeInsets.all(_barPadding),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: _barGap,
          children: [
            for (final emoji in quickReactions)
              _BarButton(
                // 今付けている絵文字は地を付けて見せる。押すと取り消し。
                selected: emoji == current,
                tooltip: emoji == current ? l10n.reactionUndo(emoji) : emoji,
                onPressed: () => Navigator.of(context).pop(emoji),
                child: _Emoji(emoji, size: 26),
              ),
            _BarButton(
              // よく使う絵文字以外を付けているときは「＋」に地を付ける。
              selected: current != null && !quickReactions.contains(current),
              tooltip: l10n.reactionMoreEmojis,
              onPressed: () => Navigator.of(context).pop(_moreEmojis),
              background: colors.placeholder,
              child: Icon(Icons.add, size: 22, color: colors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarButton extends StatelessWidget {
  const _BarButton({
    required this.selected,
    required this.tooltip,
    required this.onPressed,
    required this.child,
    this.background,
  });

  final bool selected;
  final String tooltip;
  final VoidCallback onPressed;
  final Widget child;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: selected ? colors.placeholder : background ?? Colors.transparent,
        shape: CircleBorder(
          side: selected
              ? BorderSide(color: colors.textPrimary)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: _barButtonSize,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
