import 'package:flutter/material.dart';

/// なぞって選べる文字。外をタップしたら選択を解く。
///
/// SelectableText はフォーカスが外れたときにしか選択を解かないが、
/// スマホでは外をタップしてもフォーカスが外れないので、自分で外す。
class DismissibleSelectableText extends StatefulWidget {
  const DismissibleSelectableText(
    this.text, {
    super.key,
    this.style,
    this.strutStyle,
  });

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;

  @override
  State<DismissibleSelectableText> createState() =>
      _DismissibleSelectableTextState();
}

class _DismissibleSelectableTextState extends State<DismissibleSelectableText> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTapOutside(PointerDownEvent event) {
    if (!_focusNode.hasFocus) return;
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // コピーなどのメニューは文字の外に出るので、そこを押したときは解かない。
    return TextFieldTapRegion(
      onTapOutside: _handleTapOutside,
      child: SelectableText(
        widget.text,
        focusNode: _focusNode,
        style: widget.style,
        strutStyle: widget.strutStyle,
      ),
    );
  }
}
