import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'floating_surface.dart';

/// 戻るボタンと [trailing] のボタンを、ページの上に浮かせて並べる。Scaffold の appBar に置く。
/// 真ん中は空けておき、ページに書いた [PaperTitle] がのぞくようにする。
class FloatingTopBar extends StatelessWidget implements PreferredSizeWidget {
  const FloatingTopBar({super.key, this.trailing});

  /// 右に浮かせるボタン。[FloatingSurface] に載せて渡す。
  final Widget? trailing;

  static const _padding = EdgeInsets.fromLTRB(20, 8, 20, 8);

  /// ステータスバーを除いた高さ。
  static const height = floatingButtonSize + 16;

  /// 左右のボタンが占める幅。真ん中に置くものは、これだけ両側をあける。
  static const sideWidth = 20 + floatingButtonSize * 2 + 8;

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;
    // AppBar と同じく、戻れるときだけ戻るボタンを出す。
    final canPop = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
    final dark = Theme.of(context).brightness == Brightness.dark;

    // AppBar がないので、ステータスバーの文字の色は紙の色に合わせて自分で決める。
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: _padding,
          child: Row(
            children: [
              if (canPop)
                FloatingIconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  icon: const BackButtonIcon(),
                ),
              const Spacer(),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
