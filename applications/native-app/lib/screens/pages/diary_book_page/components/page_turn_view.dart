import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 左右のスワイプで、本のページをめくるように日付を移す。
///
/// 左にスワイプすると、今のページの右側が紙のように丸まりながら左へめくれ、次の日が下から出てくる。
/// 右にスワイプすると、めくれていた前の日のページが戻ってきて今のページに重なる。
/// 指に合わせてめくれ、離したときの速さか、半分を越えたかで、めくるか戻すかを決める。
/// [latest] より先にはめくれず、少しだけめくれて戻る。
/// [date] が外から変わったとき（カレンダーで選んだときなど）は、その向きに1枚めくる。
class PageTurnView extends StatefulWidget {
  const PageTurnView({
    super.key,
    required this.date,
    required this.latest,
    required this.onChanged,
    required this.builder,
  });

  /// 見ている日。
  final DateTime date;

  /// これより先の日にはめくれない。
  final DateTime latest;

  /// めくり終えて、見る日が変わったとき。
  final ValueChanged<DateTime> onChanged;

  /// その日のページ。
  final Widget Function(DateTime date) builder;

  @override
  State<PageTurnView> createState() => _PageTurnViewState();
}

/// めくっている間の2枚。上で丸まる古い日と、その下の新しい日。
/// 先の日がなくて少しだけめくるときは、下は無地の紙（[newer] が null）。
typedef _Turning = ({DateTime older, DateTime? newer});

class _PageTurnViewState extends State<PageTurnView>
    with SingleTickerProviderStateMixin {
  // 上に重ねたページがどれだけめくれたか。0 で重なったまま、1 でめくれきる。
  late final _turn = AnimationController(vsync: this, duration: _turnDuration);
  // 丸まるページは毎フレーム写し取り直し、読み込みが終わるなどの変化もめくりながら映す。
  final _curling = SnapshotController(allowSnapshotting: true);
  final _flat = SnapshotController();
  late final _painter = _CurlPainter(_turn);

  ui.FragmentProgram? _program;

  /// 止まっているときに出す日。めくり終えたときに変わる。
  late DateTime _shown = widget.date;
  _Turning? _turning;

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
  void didUpdateWidget(PageTurnView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.date != _shown && _turning == null) _turnToDate();
  }

  @override
  void dispose() {
    _turn.dispose();
    _curling.dispose();
    _flat.dispose();
    _painter.dispose();
    super.dispose();
  }

  /// 外から変わった [PageTurnView.date] へ、その向きに1枚めくる。
  void _turnToDate() {
    final from = _shown;
    final to = widget.date;
    if (_program == null) {
      setState(() => _shown = to);
      return;
    }
    final forward = to.isAfter(from);
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
        final next = DateTime(_shown.year, _shown.month, _shown.day + 1);
        pages = (older: _shown, newer: next.isAfter(widget.latest) ? null : next);
        _turn.value = 0;
      } else if (dx > 0) {
        final previous = DateTime(_shown.year, _shown.month, _shown.day - 1);
        pages = (older: previous, newer: _shown);
        _turn.value = 1;
      } else {
        return;
      }
      setState(() => _turning = pages);
    }
    if (pages.newer == null) {
      // 先の日がないので、重く少しだけめくれる。
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

  /// めくり終える。指でめくったときは見る日が変わったことを伝え、
  /// 外から変わったときは、めくっている間にまた変わっていれば続けてめくる。
  Future<void> _settle(
    _Turning pages, {
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
      if (widget.date != shown) _turnToDate();
    } else if (shown != widget.date) {
      widget.onChanged(shown);
    }
  }

  // めくっていないときも同じ形で並べ、日ごとの key で中身（スクロール位置など）を保つ。
  Widget _page(DateTime? day, {bool curling = false}) {
    final background = Theme.of(context).scaffoldBackgroundColor;
    return KeyedSubtree(
      key: ValueKey(day),
      child: SnapshotWidget(
        controller: curling ? _curling : _flat,
        mode: SnapshotMode.permissive,
        painter: _painter,
        child: ColoredBox(
          color: background,
          child: day == null ? const SizedBox.expand() : widget.builder(day),
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
