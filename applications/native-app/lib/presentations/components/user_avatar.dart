import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// 丸いアイコン。画像がなければ、人のシルエットを出す。
/// 名前はいつも横に並べて出すので、読み上げでは飾りとして扱う。
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.imageUrl,
    this.imageBytes,
    this.size = 34,
  });

  /// アイコンの画像の URL。読み込み中や読めなかったときはシルエットを出す。
  final String? imageUrl;

  /// まだ保存していない、選んだばかりの画像。[imageUrl] より優先する。
  final Uint8List? imageBytes;
  final double size;

  @override
  Widget build(BuildContext context) {
    final imageBytes = this.imageBytes;
    final imageUrl = this.imageUrl;
    final silhouette = _Silhouette(size: size);
    // 丸の中は画像の中央で切り取る。
    final Widget image;
    if (imageBytes != null) {
      image = Image.memory(
        imageBytes,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => silhouette,
      );
    } else if (imageUrl != null) {
      image = CachedNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => silhouette,
        errorWidget: (_, _, _) => silhouette,
      );
    } else {
      image = silhouette;
    }

    return ExcludeSemantics(
      child: ClipOval(
        child: SizedBox.square(dimension: size, child: image),
      ),
    );
  }
}

/// 画像のないときのアイコン。薄い丸の中に、頭と肩を置く。
class _Silhouette extends StatelessWidget {
  const _Silhouette({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return CustomPaint(
      size: Size.square(size),
      painter: _SilhouettePainter(
        background: colors.avatarBackground,
        figure: colors.avatarSilhouette,
      ),
    );
  }
}

class _SilhouettePainter extends CustomPainter {
  const _SilhouettePainter({required this.background, required this.figure});

  final Color background;
  final Color figure;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    final paint = Paint()..color = figure;
    // 頭。
    canvas.drawCircle(Offset(s * 0.5, s * 0.4), s * 0.2, paint);
    // 肩。下は丸の縁で切れる。
    canvas.drawOval(
      Rect.fromLTRB(s * 0.12, s * 0.67, s * 0.88, s * 1.45),
      paint,
    );
  }

  @override
  bool shouldRepaint(_SilhouettePainter oldDelegate) {
    return background != oldDelegate.background ||
        figure != oldDelegate.figure;
  }
}
