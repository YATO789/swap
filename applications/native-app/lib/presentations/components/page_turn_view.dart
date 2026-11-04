import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 左右のスワイプで、本のページをめくるように移る。ページは [T]（日付や番号）で表す。
///
/// 左にスワイプすると、今のページの右側が紙のように丸まりながら左へめくれ、次のページが下から出てくる。
/// 右にスワイプすると、めくれていた前のページが戻ってきて今のページに重なる。
/// 指に合わせてめくれ、離したときの速さか、半分を越えたかで、めくるか戻すかを決める。
/// 次のページがないときは少しだけめくれて戻り、前のページがないときは右にはめくれない。
/// [page] が外から変わったとき（カレンダーで選んだときやボタンを押したときなど）は、その向きに1枚めくる。
class PageTurnView<T extends Comparable<Object>> extends StatefulWidget {
  const PageTurnView({
    super.key,
    required this.page,
    required this.previousOf,
    required this.nextOf,
    required this.onChanged,
    required this.builder,
  });

  /// 見ているページ。大きいほど後ろのページ。
  final T page;

  /// そのページの前のページ。なければ null。
  final T? Function(T page) previousOf;

  /// そのページの次のページ。なければ null。
  final T? Function(T page) nextOf;

  /// めくり終えて、見るページが変わったとき。
  final ValueChanged<T> onChanged;

  /// そのページの中身。
  final Widget Function(T page) builder;

  @override
  State<PageTurnView<T>> createState() => _PageTurnViewState<T>();
}

/// めくっている間の2枚。上で丸まる前のページと、その下の後ろのページ。
/// 次のページがなくて少しだけめくるときは、下は無地の紙（[newer] が null）。
typedef _Turning<T> = ({T older, T? newer});

class _PageTurnViewState<T extends Comparable<Object>>
    extends State<PageTurnView<T>>
    with SingleTickerProviderStateMixin {
  // 上に重ねたページがどれだけめくれたか。0 で重なったまま、1 でめくれきる。
  late final _turn = AnimationController(vsync: this, duration: _turnDuration);
  // 丸まるページは毎フレーム写し取り直し、読み込みが終わるなどの変化もめくりながら映す。
  final _curling = SnapshotController(allowSnapshotting: true);
  final _flat = SnapshotController();
  late final _painter = _CurlPainter(_turn);

  ui.FragmentProgram? _program;

  /// 止まっているときに出すページ。めくり終えたときに変わる。
  late T _shown = widget.page;
  _Turning<T>? _turning;

  @override
  void initState() {
    super.initState();
    _turn.addListener(_curling.clear);
    // 読み込めるまでは、めくらずに切り替える。
    _curlProgram.then((program) {
      if (mounted) setState(() => _program = program);
    });
  }

  @override
  void didUpdateWidget(PageTurnView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.page != _shown && _turning == null) _turnToPage();
  }

  @override
  void dispose() {
    _turn.dispose();
    _curling.dispose();
    _flat.dispose();
    _painter.dispose();
    super.dispose();
  }

  /// 外から変わった [PageTurnView.page] へ、その向きに1枚めくる。
  void _turnToPage() {
    final from = _shown;
    final to = widget.page;
    if (_program == null) {
      setState(() => _shown = to);
      return;
    }
    final forward = to.compareTo(from) > 0;
    final pages = forward ? (older: from, newer: to) : (older: to, newer: from);
    _turn.value = forward ? 0 : 1;
    setState(() => _turning = pages);
    _settle(pages, turnAway: forward, byDrag: false);
  }

  void _onDragUpdate(DragUpdateDetails details, double width) {
    if (_program == null || _turn.isAnimating) return;
    final dx = details.delta.dx;
    var pages = _turning;
    if (pages == null) {
      if (dx < 0) {
        pages = (older: _shown, newer: widget.nextOf(_shown));
        _turn.value = 0;
      } else if (dx > 0) {
        final previous = widget.previousOf(_shown);
        if (previous == null) return;
        pages = (older: previous, newer: _shown);
        _turn.value = 1;
      } else {
        return;
      }
      setState(() => _turning = pages);
    }
    if (pages.newer == null) {
      // 次のページがないので、重く少しだけめくれる。
      _turn.value = (_turn.value - dx / width * _endResistance).clamp(
        0,
        _endLimit,
      );
    } else {
      _turn.value -= dx / width;
    }
  }

  void _onDragEnd(double velocity) {
    final pages = _turning;
    if (pages == null || _turn.isAnimating) return;
    final turnAway =
        pages.newer != null &&
        (velocity.abs() > _flingVelocity ? velocity < 0 : _turn.value > 0.5);
    _settle(pages, turnAway: turnAway);
  }

  /// めくり終える。指でめくったときは見るページが変わったことを伝え、
  /// 外から変わったときは、めくっている間にまた変わっていれば続けてめくる。
  Future<void> _settle(
    _Turning<T> pages, {
    required bool turnAway,
    bool byDrag = true,
  }) async {
    await _turn.animateTo(turnAway ? 1 : 0, curve: Curves.easeOut);
    if (!mounted) return;
    final shown = turnAway ? pages.newer! : pages.older;
    setState(() {
      _turning = null;
      _shown = shown;
    });
    if (!byDrag) {
      if (widget.page != shown) _turnToPage();
    } else if (shown != widget.page) {
      widget.onChanged(shown);
    }
  }

  // めくっていないときも同じ形で並べ、ページごとの key で中身（スクロール位置など）を保つ。
  Widget _page(T? page, {bool curling = false}) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    return KeyedSubtree(
      key: ValueKey(page),
      child: SnapshotWidget(
        controller: curling ? _curling : _flat,
        mode: SnapshotMode.permissive,
        painter: _painter,
        child: ColoredBox(
          color: background,
          child: page == null ? const SizedBox.expand() : widget.builder(page),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _painter
      ..program = _program
      ..paper = Theme.of(context).scaffoldBackgroundColor;
    final pages = _turning;

    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onHorizontalDragUpdate: (details) =>
            _onDragUpdate(details, constraints.maxWidth),
        onHorizontalDragEnd: (details) =>
            _onDragEnd(details.primaryVelocity ?? 0),
        onHorizontalDragCancel: () => _onDragEnd(0),
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: pages == null
                ? [_page(_shown)]
                : [_page(pages.newer), _page(pages.older, curling: true)],
          ),
        ),
      ),
    );
  }
}

/// 写し取ったページを、めくれ具合に合わせて紙のように丸めて描く。
class _CurlPainter extends SnapshotPainter {
  _CurlPainter(this.turn) {
    turn.addListener(notifyListeners);
  }

  final Animation<double> turn;
  ui.FragmentProgram? program;
  Color paper = Colors.white;
  ui.FragmentShader? _shader;

  @override
  void paintSnapshot(
    PaintingContext context,
    Offset offset,
    Size size,
    ui.Image image,
    Size sourceSize,
    double pixelRatio,
  ) {
    final program = this.program;
    if (program == null) return;
    final shader = _shader ??= program.fragmentShader();
    final radius = size.width * _radiusRatio;
    final progress = turn.value;
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, size.width - progress * (size.width + radius))
      ..setFloat(3, radius)
      ..setFloat(4, paper.r)
      ..setFloat(5, paper.g)
      ..setFloat(6, paper.b)
      ..setFloat(7, paper.a)
      ..setFloat(8, 1 - progress)
      ..setImageSampler(0, image);

    context.canvas
      ..save()
      ..translate(offset.dx, offset.dy)
      ..drawRect(Offset.zero & size, Paint()..shader = shader)
      ..restore();
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset,
    Size size,
    PaintingContextCallback painter,
  ) => painter(context, offset);

  @override
  bool shouldRepaint(_CurlPainter oldPainter) => oldPainter != this;

  @override
  void dispose() {
    turn.removeListener(notifyListeners);
    _shader?.dispose();
    super.dispose();
  }
}

final _curlProgram = ui.FragmentProgram.fromAsset('shaders/page_curl.frag');

const _turnDuration = Duration(milliseconds: 500);

/// これより速く離したら、半分を越えていなくてもその向きにめくる（px/秒）。
const _flingVelocity = 300.0;

/// ページが巻き付く筒の半径の、ページの幅に対する割合。
const _radiusRatio = 0.12;

/// 先の日がないとき、指の動きに対してどれだけめくれるか。
const _endResistance = 0.35;

/// 先の日がないとき、どこまでめくれるか。
const _endLimit = 0.12;
