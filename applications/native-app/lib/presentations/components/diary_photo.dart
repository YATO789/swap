import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';

/// 日記を書くページと日記の詳細で、写真を出す枠の横と縦の比。
/// 同じにして、書いたとおりに見えるようにする。
const diaryPhotoAspectRatio = 4 / 3;

/// 日記に付けた写真。枠いっぱいに、写真の真ん中で切り取って出す。
/// 読み込み中や読めなかったときは、薄い灰色の面を出す。
class DiaryPhoto extends StatelessWidget {
  const DiaryPhoto({
    super.key,
    this.url,
    this.cacheKey,
    this.bytes,
    this.borderRadius = 10,
  });

  /// 写真を見るための URL。切れても読み直せるよう、キャッシュのキーは [cacheKey] にする。
  final String? url;

  /// 端末のキャッシュのキー。写真のパス（Diary.photoPath）を渡す。
  /// URL は読み直すたびに変わるので、キーにすると同じ写真を何度もダウンロードしてしまう。
  final String? cacheKey;

  /// まだ保存していない、選んだばかりの写真。[url] より優先する。
  final Uint8List? bytes;

  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final bytes = this.bytes;
    final url = this.url;
    final placeholder = ColoredBox(color: colors.placeholder);

    final Widget image;
    if (bytes != null) {
      image = Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
      );
    } else if (url != null) {
      image = CachedNetworkImage(
        imageUrl: url,
        cacheKey: cacheKey,
        fit: BoxFit.cover,
        placeholder: (_, _) => placeholder,
        errorWidget: (_, _, _) => placeholder,
      );
    } else {
      image = placeholder;
    }

    return Semantics(
      image: true,
      label: context.l10n.diaryPhotoSemantics,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: SizedBox.expand(child: image),
      ),
    );
  }
}
