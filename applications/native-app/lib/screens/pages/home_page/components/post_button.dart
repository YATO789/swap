import 'package:flutter/material.dart';

import '../../../../theme/app_theme.dart';

/// 画面の下に置く書き込みバー。左は「今なにしてる？」の入力欄風の欄で、
/// 押すと投稿シートを開く。右のペンは日記を書くページを開く。
/// 浮かぶボタンだと一覧に重なるので、画面の一部として置く。
class PostButton extends StatelessWidget {
  const PostButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: '記録する',
                excludeSemantics: true,
                // 角丸の四角に薄いグレーを敷いただけの、枠もアイコンもない入力欄の見た目。
                child: Material(
                  color: colors.placeholder,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // TODO: 投稿シートを開く。
                    onTap: () {},
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '今なにしてる？',
                        style: TextStyle(
                          fontSize: 17,
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              // TODO: 日記を書くページを開く。
              onPressed: () {},
              tooltip: '今日の日記を書く',
              style: IconButton.styleFrom(
                fixedSize: const Size(48, 48),
                backgroundColor: colors.textPrimary,
                foregroundColor: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
