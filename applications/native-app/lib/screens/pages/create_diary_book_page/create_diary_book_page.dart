import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/cover_color_picker.dart';
import '../../components/diary_cover.dart';
import '../../components/discard_guard.dart';
import 'controller/create_diary_book_page_controller.dart';

/// 日記帳を作るページ。作ったら閉じて、作った日記帳を返す。
///
/// 名前を打つと、真ん中の日記帳の表紙にその場で書き込まれていく。
class CreateDiaryBookPage extends HookConsumerWidget {
  const CreateDiaryBookPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final nameController = useTextEditingController();
    // 文字を打つたびに表紙のプレビューと作成ボタンを更新する。
    useListenable(nameController);
    final name = nameController.text.trim();

    /// 選んでいる表紙の色。null なら決まったグレー。最初は黒を選んでおく。
    final coverColor = useState<Color?>(initialCoverColor);

    /// 作成中か。ボタンを押せなくして、処理中の表示を出す。
    final creating = ref.watch(createDiaryBookPageControllerProvider).isLoading;
    final canCreate = name.isNotEmpty && !creating;

    Future<void> create() async {
      if (!canCreate) return;
      final diaryBook = await ref
          .read(createDiaryBookPageControllerProvider.notifier)
          .create(name, coverColor: coverColor.value?.toARGB32());
      if (!context.mounted) return;
      if (diaryBook == null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(context.l10n.createDiaryBookFailed)),
          );
        return;
      }
      // 作れたので、書きかけの確認（DiscardGuard）を通さずに閉じる。
      Navigator.of(context).pop(diaryBook);
    }

    return DiscardGuard(
      dirty: name.isNotEmpty,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.commonCreateDiaryBook),
          leadingWidth: 112,
          // 閉じるときも DiscardGuard の確認を通す。
          leading: TextButton(
            onPressed: () => Navigator.of(context).maybePop(),
            style: TextButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            child: Text(
              context.l10n.commonCancel,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          actions: [
            TextButton(
              onPressed: canCreate ? create : null,
              child: creating
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textSecondary,
                      ),
                    )
                  : Text(context.l10n.createDiaryBookCreate),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              children: [
                Expanded(
                  // 空いている場所いっぱいまで日記帳を大きくする。
                  // キーボードが出て狭くなったら、そのぶん小さくなる。
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = min(
                        constraints.maxWidth * 0.72,
                        constraints.maxHeight * 0.82 * 3 / 4,
                      );
                      return Center(
                        // 名前が入ると、日記帳がぐっと手前に寄ってくる。
                        child: AnimatedScale(
                          scale: name.isEmpty ? 0.9 : 1.0,
                          duration: const Duration(milliseconds: 380),
                          curve: Curves.easeOutBack,
                          child: DiaryCover(
                            name: name,
                            color: coverColor.value,
                            width: width,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                CoverColorPicker(
                  selected: coverColor.value,
                  onSelected: (color) => coverColor.value = color,
                ),
                const SizedBox(height: 20),
                _NameField(controller: nameController, onSubmitted: create),
                const SizedBox(height: 12),
                Text(
                  context.l10n.createDiaryBookIconHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 枠線のない、角の丸い名前の入力欄。文字は真ん中に寄せる。
class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.onSubmitted});

  final TextEditingController controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return TextField(
      controller: controller,
      maxLength: maxDiaryBookNameLength,
      autofocus: true,
      textAlign: TextAlign.center,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => onSubmitted(),
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: context.l10n.commonDiaryBookNameHint,
        // 上限で止まるだけにして、文字数の表示は出さない。
        counterText: '',
        filled: true,
        fillColor: colors.placeholder,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
