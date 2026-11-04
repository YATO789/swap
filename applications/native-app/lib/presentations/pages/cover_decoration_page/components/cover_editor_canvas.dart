import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../domains/diary_book/cover_decoration.dart';
import '../../../../l10n/l10n.dart';
import '../../../components/cover_decoration_layer.dart';

/// 選んでいるもののつまみの半径。つまみを触れるよう、貼ったもののまわりをこのぶん空ける。
const _knobRadius = 14.0;

/// 前の点からこれより近い点は足さない（等倍のときの、表紙の幅との割合）。保存する点を減らすため。
/// 拡大しているときは、画面の上で同じ間隔になるよう倍率で割る。
const _minPointGap = 0.004;

/// 消しゴムが線に届く距離（線の太さの半分に足す、等倍のときの表紙の幅との割合）。
/// 拡大しているときは、画面の上で同じ範囲に届くよう倍率で割る。
const _eraserReach = 0.025;

/// 表紙の編集ページで今していること。
enum CoverEditMode {
  /// 貼ったものを選んで動かす。
  stickers,

  /// 表紙をなぞってらくがきする。
  doodle,

  /// 表紙の色を選ぶ。
  color,
}

/// 表紙の背表紙の上に置く、触って編集できる飾りの層。
///
/// 貼ったもの（絵文字・文字・名前）はドラッグで動かし、右下のつまみか2本指で回転と拡大縮小をする。
/// 選んでいる文字をもう一度押すと [onEditText] を呼ぶ。
/// らくがきのモードでは、1本指でなぞって線を描くか、消しゴムで線を消す。
/// 2本指で触れると [onPinchStart]・[onPinchUpdate] を呼び、表紙の拡大と移動をしてもらう。
/// 描いている途中で2本目の指が触れたら、描きかけの線は捨てる。
/// 変えるたびに [onChanged] で新しい飾りを渡す。1回の操作の始まりには [onEditStart] を呼ぶ。
class CoverEditorCanvas extends HookWidget {
  const CoverEditorCanvas({
    super.key,
    required this.decoration,
    required this.coverWidth,
    required this.name,
    required this.inkColor,
    required this.mode,
    required this.selected,
    required this.penColor,
    required this.penWidth,
    required this.erasing,
    required this.zoom,
    required this.onSelect,
    required this.onEditStart,
    required this.onChanged,
    required this.onEditText,
    required this.onStrokeLimit,
    required this.onPinchStart,
    required this.onPinchUpdate,
  });

  final CoverDecoration decoration;
  final double coverWidth;

  /// 日記帳の名前。名前の貼ったものに出す。
  final String name;

  /// 色を決めていない文字の色。表紙の色に合わせた黒か白。
  final Color inkColor;
  final CoverEditMode mode;

  /// 選んでいるものの位置。選んでいなければ null。
  final int? selected;
  final int penColor;
  final double penWidth;
  final bool erasing;

  /// 表紙を拡大している倍率。等倍なら 1。
  final double zoom;
  final ValueChanged<int?> onSelect;

  /// ドラッグや線を描くなど、1回の操作を始めた。元に戻すときはこの前まで戻る。
  final VoidCallback onEditStart;
  final ValueChanged<CoverDecoration> onChanged;

  /// 選んでいる文字をもう一度押した。引数は文字の位置。
  final ValueChanged<int> onEditText;

  /// 描ける線の数か点の数の上限に届いていて、描き始められなかった。
  final VoidCallback onStrokeLimit;

  /// らくがきのモードで、2本指で触れて動かし始めた。
  final GestureScaleStartCallback onPinchStart;

  /// らくがきのモードで、2本指を動かした。拡大の倍率と指の真ん中は [onPinchStart] のときとの比べ。
  final GestureScaleUpdateCallback onPinchUpdate;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final canvasKey = useMemoized(GlobalKey.new);

    /// 動かし始めたときの絵文字。動かしているあいだはこれを元に位置や大きさを出す。
    final gestureStart = useRef<CoverSticker?>(null);
    final focalStart = useRef(Offset.zero);

    /// つまみを触り始めたときの、絵文字の中心からつまみまで。
    final knobStart = useRef(Offset.zero);

    /// 今描いている線。描き終えたら飾りに足す。
    final drawing = useState<CoverStroke?>(null);

    /// らくがきのモードで、表紙に触れている指。
    final pointers = useRef(<int>{});

    /// 1本目の指が触れた場所（画面の座標）。線はなぞり始めたと分かる前のここから描く。
    final downAt = useRef(Offset.zero);

    /// 今の操作で2本目の指が触れたか。すべての指を離すまでは線を描かず、拡大と移動だけをする。
    final pinching = useRef(false);

    // 触れたままモードを変えると、らくがきの場所が消えて離した指が届かないので、数え直す。
    useEffect(() {
      pointers.value.clear();
      pinching.value = false;
      return null;
    }, [mode]);

    Offset toCanvas(Offset global) {
      final box = canvasKey.currentContext!.findRenderObject()! as RenderBox;
      return box.globalToLocal(global);
    }

    /// 表紙の上の位置を、表紙の幅を 1 とした点にする。
    Offset toPoint(Offset local) {
      return Offset(
        (local.dx / coverWidth).clamp(0.0, 1.0),
        (local.dy / coverWidth).clamp(0.0, coverHeightRatio),
      );
    }

    void onScaleStart(int index, ScaleStartDetails details) {
      onSelect(index);
      onEditStart();
      gestureStart.value = decoration.stickers[index];
      focalStart.value = details.focalPoint;
    }

    // 1本指なら動かすだけ、2本指なら回転と拡大縮小もする。
    void onScaleUpdate(int index, ScaleUpdateDetails details) {
      final start = gestureStart.value;
      if (start == null) return;
      final moved = (details.focalPoint - focalStart.value) / coverWidth;
      onChanged(
        decoration.replaceSticker(
          index,
          start.copyWith(
            x: start.x + moved.dx,
            y: start.y + moved.dy,
            size: start.size * details.scale,
            rotation: start.rotation + details.rotation,
          ),
        ),
      );
    }

    void onKnobStart(int index, DragStartDetails details) {
      final start = gestureStart.value = decoration.stickers[index];
      onEditStart();
      knobStart.value =
          toCanvas(details.globalPosition) -
          Offset(start.x, start.y) * coverWidth;
    }

    // 絵文字の中心からつまみまでの長さで大きさを、向きで回転を決める。
    void onKnobUpdate(int index, DragUpdateDetails details) {
      final start = gestureStart.value;
      if (start == null || knobStart.value.distance == 0) return;
      final knob =
          toCanvas(details.globalPosition) -
          Offset(start.x, start.y) * coverWidth;
      onChanged(
        decoration.replaceSticker(
          index,
          start.copyWith(
            size: start.size * knob.distance / knobStart.value.distance,
            rotation:
                start.rotation + knob.direction - knobStart.value.direction,
          ),
        ),
      );
    }

    void eraseAt(Offset point) {
      final erased = decoration.eraseStrokesAt(
        point,
        reach: _eraserReach / zoom,
      );
      if (!identical(erased, decoration)) onChanged(erased);
    }

    void onDrawStart(Offset local) {
      final point = toPoint(local);
      drawing.value = null;
      onEditStart();
      if (erasing) {
        eraseAt(point);
        return;
      }
      if (!decoration.canAddStroke) {
        onStrokeLimit();
        return;
      }
      drawing.value = CoverStroke(
        color: penColor,
        width: penWidth,
        points: [point],
      );
    }

    void onDrawUpdate(Offset local) {
      final point = toPoint(local);
      if (erasing) {
        eraseAt(point);
        return;
      }
      final stroke = drawing.value;
      if (stroke == null ||
          (point - stroke.points.last).distance < _minPointGap / zoom) {
        return;
      }
      drawing.value = stroke.copyWith(points: [...stroke.points, point]);
    }

    void onDrawEnd() {
      final stroke = drawing.value;
      if (stroke == null) return;
      drawing.value = null;
      onChanged(decoration.addStroke(stroke));
    }

    // 指の数は Listener で数える。Listener は指が触れたり離れたりしたとき、
    // 下の GestureDetector より先に呼ばれるので、2本目の指で描きかけの線が確定する前に捨てられる。
    void onPointerDown(PointerDownEvent event) {
      pointers.value.add(event.pointer);
      if (pointers.value.length == 1) {
        downAt.value = event.position;
        return;
      }
      pinching.value = true;
      drawing.value = null;
    }

    void onPointerUp(PointerEvent event) {
      pointers.value.remove(event.pointer);
      if (pointers.value.isEmpty) pinching.value = false;
    }

    void onDoodleStart(ScaleStartDetails details) {
      if (pinching.value) {
        if (details.pointerCount >= 2) onPinchStart(details);
        return;
      }
      onDrawStart(toCanvas(downAt.value));
    }

    void onDoodleUpdate(ScaleUpdateDetails details) {
      if (pinching.value) {
        // 2本のうち1本を離したあとは、指を足すまで動かさない。
        if (details.pointerCount >= 2) onPinchUpdate(details);
        return;
      }
      onDrawUpdate(toCanvas(details.focalPoint));
    }

    void onDoodleEnd(ScaleEndDetails details) {
      if (pinching.value) return;
      onDrawEnd();
    }

    final current = drawing.value;

    return Stack(
      key: canvasKey,
      children: [
        // らくがきや色を選んでいるあいだは、貼ったものを動かさない。
        IgnorePointer(
          ignoring: mode != CoverEditMode.stickers,
          child: Stack(
            children: [
              for (final (index, sticker) in decoration.stickers.indexed)
                PlacedCoverSticker(
                  sticker: sticker,
                  coverWidth: coverWidth,
                  child: Semantics(
                    container: true,
                    button: true,
                    selected: index == selected,
                    label: switch (sticker) {
                      CoverSticker(isName: true) => l10n.coverEditNameSemantics(
                        name,
                      ),
                      CoverSticker(:final text?) => l10n.coverEditTextSemantics(
                        text,
                      ),
                      _ => l10n.coverEditStickerSemantics(sticker.emoji ?? ''),
                    },
                    // 白いふちと影に使う同じ絵文字や文字は読み上げない。
                    excludeSemantics: true,
                    child: GestureDetector(
                      // 選んでいる文字をもう一度押したら書き換える。
                      onTap: index == selected && sticker.text != null
                          ? () => onEditText(index)
                          : () => onSelect(index),
                      onScaleStart: (details) => onScaleStart(index, details),
                      onScaleUpdate: (details) => onScaleUpdate(index, details),
                      child: _EditableSticker(
                        selected: index == selected,
                        knobLabel: l10n.coverEditKnob,
                        onKnobStart: (details) => onKnobStart(index, details),
                        onKnobUpdate: (details) => onKnobUpdate(index, details),
                        child: CoverStickerView(
                          sticker: sticker,
                          coverWidth: coverWidth,
                          name: name,
                          inkColor: inkColor,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: CoverStrokePainter(
              strokes: current == null
                  ? decoration.strokes
                  : [...decoration.strokes, current],
              coverWidth: coverWidth,
            ),
          ),
        ),
        if (mode == CoverEditMode.doodle)
          Positioned.fill(
            child: Semantics(
              container: true,
              label: l10n.coverEditDoodleArea,
              child: Listener(
                onPointerDown: onPointerDown,
                onPointerUp: onPointerUp,
                onPointerCancel: onPointerUp,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  // 動かさずに離したら点を打つ（消しゴムならそこの線を消す）。
                  onTapUp: (details) {
                    onDrawStart(details.localPosition);
                    onDrawEnd();
                  },
                  onScaleStart: onDoodleStart,
                  onScaleUpdate: onDoodleUpdate,
                  onScaleEnd: onDoodleEnd,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 編集中の貼ったもの1つ。選んでいると白い枠と、右下に回転と拡大縮小のつまみを出す。
class _EditableSticker extends StatelessWidget {
  const _EditableSticker({
    required this.selected,
    required this.knobLabel,
    required this.onKnobStart,
    required this.onKnobUpdate,
    required this.child,
  });

  final bool selected;
  final String knobLabel;
  final GestureDragStartCallback onKnobStart;
  final GestureDragUpdateCallback onKnobUpdate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // つまみが角にかかるよう、まわりを空けておく。
    // 空けたところの外は触っても届かないので、つまみもこの中に置く。
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(_knobRadius),
          child: Container(
            foregroundDecoration: selected
                ? BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                  )
                : null,
            child: child,
          ),
        ),
        if (selected)
          Positioned(
            right: 0,
            bottom: 0,
            child: Semantics(
              label: knobLabel,
              child: GestureDetector(
                dragStartBehavior: DragStartBehavior.down,
                onPanStart: onKnobStart,
                onPanUpdate: onKnobUpdate,
                child: Container(
                  width: _knobRadius * 2,
                  height: _knobRadius * 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.rotate_right,
                    size: 18,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
