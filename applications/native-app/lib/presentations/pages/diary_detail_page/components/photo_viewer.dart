import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../l10n/l10n.dart';

/// 写真を黒い背景の全画面で、切り取らずに出す。
/// 指で広げて拡大でき、拡大していなければ下にスワイプして閉じられる。
Future<void> showPhotoViewer(
  BuildContext context, {
  required String url,
  required String cacheKey,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      pageBuilder: (_, _, _) => _PhotoViewer(url: url, cacheKey: cacheKey),
      transitionsBuilder: (_, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

class _PhotoViewer extends HookWidget {
  const _PhotoViewer({required this.url, required this.cacheKey});

  final String url;
  final String cacheKey;

  @override
  Widget build(BuildContext context) {
    final transformation = useTransformationController();

    /// 拡大しているか。拡大中は指で動かせるよう、スワイプで閉じるのを止める。
    final zoomed = useState(false);

    void syncZoomed() {
      zoomed.value = transformation.value.getMaxScaleOnAxis() > 1.01;
    }

    final photo = InteractiveViewer(
      transformationController: transformation,
      maxScale: 4,
      onInteractionEnd: (_) => syncZoomed(),
      child: Center(
        child: Semantics(
          image: true,
          label: context.l10n.diaryPhotoSemantics,
          child: CachedNetworkImage(
            imageUrl: url,
            cacheKey: cacheKey,
            fit: BoxFit.contain,
            placeholder: (_, _) =>
                const CircularProgressIndicator(color: Colors.white54),
            errorWidget: (_, _, _) =>
                const Icon(Icons.broken_image_outlined, color: Colors.white54),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      // 写真は画面いっぱいに広げる。Stack は位置を決めていない子の大きさになるので、
      // 閉じるボタンは位置を決めて左上に置き、Stack の大きさに関わらせない。
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (zoomed.value)
            photo
          else
            Dismissible(
              key: const ValueKey('photo'),
              direction: DismissDirection.down,
              onDismissed: (_) => Navigator.of(context).pop(),
              child: photo,
            ),
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: context.l10n.commonClose,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
