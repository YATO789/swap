import 'dart:math';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../components/diary_book_icon.dart';
import '../../components/diary_cover.dart';
import '../../providers/diary_book_notifier.dart';

/// ホームで押した日記帳の表紙。日記帳のページを、この表紙から開く。
class DiaryBookOrigin {
  const DiaryBookOrigin({required this.diaryBook, required this.rect});

  /// 表紙に描く日記帳。開いている間に表紙を変えたら、閉じるときは変えた表紙を描く。
  final DiaryBook diaryBook;

  /// 画面の中での表紙の位置と大きさ。
  final Rect rect;
}

/// [origin] の表紙を少し浮かせて手に取り、その大きさのまま背表紙を軸に左へめくって
/// 中の [child] を見せ、それから [child] を画面いっぱいに広げて開くページ。
/// 戻るときは同じ動きを逆にたどって閉じる。
///
/// 画面の中ほどの左右スワイプはページの中で使うので、戻るのは画面の左端からだけにする。
/// 端から引くと、指に合わせて表紙が閉じていく。
Page<void> openBookPage({
  required LocalKey key,
  required DiaryBookOrigin origin,
  required Widget child,
}) {
  return _OpenBookPage(key: key, origin: origin, child: child);
}

class _OpenBookPage extends Page<void> {
  const _OpenBookPage({super.key, required this.origin, required this.child});

  final DiaryBookOrigin origin;
  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) {
    return _OpenBookRoute(settings: this, origin: origin, child: child);
  }
}

class _OpenBookRoute extends PageRoute<void> {
  _OpenBookRoute({
    required super.settings,
    required this.origin,
    required this.child,
  });

  final DiaryBookOrigin origin;
  final Widget child;

  @override
  Color? get barrierColor {
    return null;
  }

  @override
  String? get barrierLabel {
    return null;
  }

  @override
  bool get maintainState {
    return true;
  }

  @override
  Duration get transitionDuration {
    return const Duration(milliseconds: 1000);
  }

  @override
  Duration get reverseTransitionDuration {
    return const Duration(milliseconds: 800);
  }

  // 後ろのホームは iOS の標準の画面遷移のように左へずらさず、その場で暗くするだけにする。
  // ずらすと、開いていく表紙の横からホームの表紙がのぞく。
  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return false;
  }

  // 上に開いたページが横から入ってくるときは、iOS の標準の画面遷移と同じく左へ少しずれる。
  // 下から出てくるページのときは動かない。
  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    return nextRoute is PageRoute && !nextRoute.fullscreenDialog;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return child;
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return _OpenBookTransition(
      animation: animation,
      secondaryAnimation: secondaryAnimation,
      origin: origin,
      child: _BackSwipe(route: this, child: child),
    );
  }

  /// 画面の端から引いて戻れるか。開ききっていて、上にほかのページがないときだけ戻れる。
  bool get _canSwipeBack {
    return !isFirst &&
        !willHandlePopInternally &&
        popDisposition != RoutePopDisposition.doNotPop &&
        animation!.status == AnimationStatus.completed &&
        secondaryAnimation!.status == AnimationStatus.dismissed &&
        !navigator!.userGestureInProgress;
  }

  void _startSwipeBack() {
    navigator!.didStartUserGesture();
  }

  /// 指が画面の幅の [delta] だけ右へ動いたぶん、表紙を閉じる。
  void _updateSwipeBack(double delta) {
    controller!.value -= delta;
  }

  /// 指を離したとき。素早く払ったらその向きに、そうでなければ半分より閉じていれば戻る。
  /// [velocity] は1秒に画面の幅のいくつぶん右へ動いていたか。
  ///
  /// 残りは、戻るボタンで閉じるときと同じ速さで動かす。
  void _endSwipeBack(double velocity) {
    final controller = this.controller!;
    final pop = velocity.abs() >= 1 ? velocity > 0 : controller.value < 0.5;
    if (pop) {
      navigator!.pop();
    } else {
      controller.forward();
    }

    if (!controller.isAnimating) {
      navigator!.didStopUserGesture();
      return;
    }
    late final AnimationStatusListener listener;
    listener = (_) {
      if (controller.isAnimating) return;
      controller.removeStatusListener(listener);
      navigator?.didStopUserGesture();
    };
    controller.addStatusListener(listener);
  }
}

/// 画面の左端から右へ引いて、[route] を閉じる。
/// 画面の中ほどの左右スワイプはページの中で使うので、端だけで受ける。
class _BackSwipe extends StatefulWidget {
  const _BackSwipe({required this.route, required this.child});

  final _OpenBookRoute route;
  final Widget child;

  // iOS の標準の画面遷移と同じ幅。
  static const _edgeWidth = 20.0;

  @override
  State<_BackSwipe> createState() {
    return _BackSwipeState();
  }
}

class _BackSwipeState extends State<_BackSwipe> {
  bool _swiping = false;

  void _start(DragStartDetails _) {
    if (!widget.route._canSwipeBack) return;
    _swiping = true;
    widget.route._startSwipeBack();
  }

  void _update(DragUpdateDetails details) {
    if (!_swiping) return;
    widget.route._updateSwipeBack(
      details.primaryDelta! / MediaQuery.sizeOf(context).width,
    );
  }

  void _end(DragEndDetails details) {
    if (!_swiping) return;
    _swiping = false;
    widget.route._endSwipeBack(
      details.velocity.pixelsPerSecond.dx / MediaQuery.sizeOf(context).width,
    );
  }

  void _cancel() {
    if (!_swiping) return;
    _swiping = false;
    widget.route._endSwipeBack(0);
  }

  @override
  Widget build(BuildContext context) {
    // ノッチのある端末を横にしたときは、ノッチのぶん広くする。
    final edgeWidth = max(
      MediaQuery.paddingOf(context).left,
      _BackSwipe._edgeWidth,
    );

    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: edgeWidth,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: _start,
            onHorizontalDragUpdate: _update,
            onHorizontalDragEnd: _end,
            onHorizontalDragCancel: _cancel,
          ),
        ),
      ],
    );
  }
}

class _OpenBookTransition extends StatelessWidget {
  const _OpenBookTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.origin,
    required this.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final DiaryBookOrigin origin;
  final Widget child;

  // 表紙を少し浮かせて手に取り、その大きさのまま開いて中のページを見せ、
  // それからページを画面いっぱいに広げる。それぞれ少し重ねてつなげる。
  static const _lift = Interval(0, 0.2, curve: Curves.easeOutCubic);
  static const _settle = Interval(0.55, 0.8, curve: Curves.easeInOutCubic);
  static const _open = Interval(0.15, 0.6, curve: Curves.easeInOutCubic);
  static const _grow = Interval(0.55, 1, curve: Curves.easeInOutCubic);
  static const _fadeCover = Interval(0.6, 0.8);

  // 手に取ったときに、どれだけ大きくし、どれだけ持ち上げるか。
  static const _liftScale = 0.05;
  static const _liftHeight = 8.0;

  // めくった表紙は真横まで倒さず、少し手前で消す。
  static const _openAngle = pi * 0.955;

  // 開いていくにつれ、後ろのホームを暗くする。
  static const _shadeAlpha = 0.35;

  @override
  Widget build(BuildContext context) {
    // 上に別のページを開いたときは、iOS の標準の画面遷移と同じく左へ少しずらす。
    final slide = secondaryAnimation
        .drive(CurveTween(curve: Curves.linearToEaseOut))
        .drive(Tween(begin: Offset.zero, end: const Offset(-1 / 3, 0)));

    return SlideTransition(
      position: slide,
      child: AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) => _buildBook(context, child!),
      ),
    );
  }

  // 動きの途中でページの状態が捨てられないよう、どの時点でも同じ形の木を返す。
  Widget _buildBook(BuildContext context, Widget page) {
    final t = animation.value;
    final size = MediaQuery.sizeOf(context);
    // 動きを減らす設定のときは、表紙を出さずにページを浮かび上がらせるだけにする。
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final lift = reduceMotion
        ? 0.0
        : _lift.transform(t) * (1 - _settle.transform(t));
    final grow = reduceMotion ? 1.0 : _grow.transform(t);
    final open = reduceMotion ? 1.0 : _open.transform(t);
    final coverOpacity = reduceMotion ? 0.0 : 1 - _fadeCover.transform(t);
    final pageOpacity = reduceMotion ? t : 1.0;

    final grown = Rect.lerp(origin.rect, Offset.zero & size, grow)!;
    final scale = 1 + _liftScale * lift;
    final rect = Rect.fromCenter(
      center: grown.center.translate(0, -_liftHeight * lift),
      width: grown.width * scale,
      height: grown.height * scale,
    );
    // 表紙と同じく、背表紙の側は小さく、反対側は大きく角を丸める。
    final radius = lerpDouble(6 * origin.rect.width / 168, 0, grow)!;
    final borderRadius = BorderRadius.horizontal(
      left: Radius.circular(min(2, radius)),
      right: Radius.circular(radius),
    );
    final angle = _openAngle * open;

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              // 表紙を開いたあたりから暗くし始め、ページが広がりきるまでに暗くしきる。
              color: Colors.black.withValues(
                alpha: reduceMotion ? 0 : _shadeAlpha * max(open * 0.7, grow),
              ),
            ),
          ),
        ),
        // ページは画面の大きさで組み、表紙の幅まで縮めて表紙の形で切り抜く。
        Positioned.fromRect(
          rect: rect,
          child: Opacity(
            opacity: pageOpacity,
            child: ClipRRect(
              borderRadius: borderRadius,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                minWidth: size.width,
                maxWidth: size.width,
                minHeight: size.height,
                maxHeight: size.height,
                child: Transform.scale(
                  scale: rect.width / size.width,
                  alignment: Alignment.topLeft,
                  child: page,
                ),
              ),
            ),
          ),
        ),
        Positioned.fromRect(
          rect: rect,
          child: IgnorePointer(
            child: Opacity(
              opacity: coverOpacity,
              child: Transform(
                alignment: Alignment.centerLeft,
                // 遠近をつけて、めくれる側が手前に起き上がって見えるようにする。
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 1 / (size.width * 4))
                  ..rotateY(angle),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: _Cover(
                    origin: origin,
                    aspectRatio: rect.width / rect.height,
                    // 半分より先にめくれたら、表紙の裏側が見えている。
                    inside: angle > pi / 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// めくれていく表紙。
///
/// 表紙は 3:4 で、画面いっぱいまで大きくすると縦が足りない。地の色は縦に伸ばし、
/// 名前や飾りは形を変えずに表紙と同じ位置に置く。
class _Cover extends ConsumerWidget {
  const _Cover({
    required this.origin,
    required this.aspectRatio,
    required this.inside,
  });

  final DiaryBookOrigin origin;

  /// 今の表紙の 幅 / 高さ。
  final double aspectRatio;

  /// 表紙の裏側を描くか。
  final bool inside;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryBook =
        ref.watch(
          diaryBookProvider.select(
            (state) => state.value
                ?.where((diaryBook) => diaryBook.id == origin.diaryBook.id)
                .firstOrNull,
          ),
        ) ??
        origin.diaryBook;
    final coverColor = diaryBook.coverColor == null
        ? defaultCoverColor(context)
        : Color(diaryBook.coverColor!);

    // 裏側は、表紙の色を薄くした見返しにする。
    if (inside) {
      return ColoredBox(color: Color.lerp(coverColor, Colors.white, 0.6)!);
    }

    final width = origin.rect.width;
    // 画面遷移の中は Scaffold の外で、文字の形の決まりがないと文字に黄色い下線が出る。
    // ホームの表紙と同じに見えるよう、透明な Material を敷く。
    return Material(
      type: MaterialType.transparency,
      child: ColoredBox(
        color: coverColor,
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: width,
            height: width / aspectRatio,
            child: DiaryCoverFace(
              name: diaryBook.name,
              coverColor: coverColor,
              width: width,
              decoration: diaryBook.coverDecoration,
            ),
          ),
        ),
      ),
    );
  }
}
