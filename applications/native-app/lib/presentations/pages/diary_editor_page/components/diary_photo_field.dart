import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/diary_photo.dart';

/// 日記を書くページの、タイトルの上に置く写真の欄。
/// 写真がなければ「写真を付ける」の枠を出し、あれば写真と、外すボタンを出す。
/// 写真を押すと選び直せる。
class DiaryPhotoField extends StatelessWidget {
  const DiaryPhotoField({
    super.key,
    required this.hasPhoto,
    this.url,
    this.cacheKey,
    this.bytes,
    required this.onPick,
    required this.onRemove,
  });

  /// 写真が付いているか。保存してある写真の URL をもらえなかったときも、付いていれば true。
  final bool hasPhoto;

  /// 保存してある写真の URL とキャッシュのキー（写真のパス）。
  final String? url;
  final String? cacheKey;

  /// 選んだばかりで、まだ保存していない写真。
  final Uint8List? bytes;

  final VoidCallback onPick;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    if (!hasPhoto) {
      return Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.border),
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                Icon(
                  Icons.add_photo_alternate_outlined,
                  color: colors.textSecondary,
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.editorAddPhoto,
                  style: TextStyle(fontSize: 13, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: diaryPhotoAspectRatio,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: onPick,
            child: DiaryPhoto(url: url, cacheKey: cacheKey, bytes: bytes),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: onRemove,
              tooltip: l10n.editorRemovePhoto,
              icon: const Icon(Icons.close, size: 18),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                foregroundColor: Colors.white,
                minimumSize: const Size.square(32),
                fixedSize: const Size.square(32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
