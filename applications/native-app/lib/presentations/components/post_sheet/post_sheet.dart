import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/diary_book.dart';
import '../../../domains/post/post.dart';
import '../../providers/diary_book_notifier.dart';
import '../../providers/post_diary_book_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../discard_guard.dart';
import '../ruled_lines.dart';
import 'components/diary_book_chip.dart';
import 'controller/post_sheet_controller.dart';

const _lines = 3;
// 罫線の間隔は日記の本文と揃える。
const _fontSize = 16.0;
const _lineHeight = 2.2;

/// 「ひとこと」の投稿シートを開く。記録したら true を返す。
/// [diaryBook] を渡すとその日記帳にだけ投稿し、日記帳の選択は出さない。
/// 渡さなければ前に選んだ日記帳（今も参加しているもの）が選ばれた状態で、投稿先を選べる。
Future<bool> showPostSheet(BuildContext context, {DiaryBook? diaryBook}) async {
  final posted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _PostSheet(diaryBook: diaryBook),
  );
  return posted ?? false;
}

class _PostSheet extends HookConsumerWidget {
  const _PostSheet({required this.diaryBook});

  final DiaryBook? diaryBook;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final fixedDiaryBook = diaryBook;
    final diaryBooks =
        ref.watch(diaryBookProvider).value ?? const <DiaryBook>[];
    final controller = useTextEditingController();
    useListenable(controller);
    final message = controller.text.trim();

    final savedIds = ref.watch(postDiaryBookProvider);
    final selectedIds = fixedDiaryBook != null
        ? [fixedDiaryBook.id]
        // 抜けた日記帳は外す。並び順は日記帳一覧と揃える。
        : [
            for (final diaryBook in diaryBooks)
              if (savedIds.contains(diaryBook.id)) diaryBook.id,
          ];

    // 開いたまま時間が経っても、表示している時刻が古くならないようにする。
    final now = useState(DateTime.now());
    useEffect(() {
      final clock = Timer.periodic(const Duration(seconds: 5), (_) {
        final current = DateTime.now();
        if (current.minute != now.value.minute) now.value = current;
      });
      return clock.cancel;
    }, const []);

    final submitting = ref.watch(postSheetControllerProvider).isLoading;
    // 記録はどれかの日記帳に入れるので、1冊も選んでいなければ押せない。
    final canSubmit =
        message.isNotEmpty && selectedIds.isNotEmpty && !submitting;

    void toggleDiaryBook(String id) {
      final ids = {...selectedIds};
      if (!ids.remove(id)) ids.add(id);
      ref.read(postDiaryBookProvider.notifier).save(ids);
    }

    Future<void> submit() async {
      if (!canSubmit) return;
      final ok = await ref
          .read(postSheetControllerProvider.notifier)
          .submit(Post(message: message, diaryBookIds: selectedIds));
      if (!context.mounted) return;
      final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
      if (!ok) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.postSheetFailed)));
        return;
      }
      // 書けたので、書きかけの確認（DiscardGuard）を通さずに閉じる。
      Navigator.of(context).pop(true);
      messenger.showSnackBar(SnackBar(content: Text(l10n.postSheetPosted)));
    }

    return DiscardGuard(
      dirty: message.isNotEmpty,
      child: Padding(
        // キーボードが出たらその上に持ち上げる。
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          child: Padding(
            // 上はドラッグハンドルがあるので詰める。
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  formatTime(now.value),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                // 枠は付けず、時刻の見出しと左を揃えてそのまま書き込む。
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // 日記の本文と同じく、3行ぶんの罫線を敷いてノートに書くように見せる。
                      RuledLines(
                        lineHeight: _fontSize * _lineHeight,
                        lineCount: _lines,
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          maxLength: maxPostMessageLength,
                          minLines: _lines,
                          maxLines: _lines,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          style: const TextStyle(
                            fontSize: _fontSize,
                            height: _lineHeight,
                          ),
                          // 行の高さいっぱいだと罫線をはみ出すので、文字の高さに合わせる。
                          cursorHeight: _fontSize * 1.4,
                          decoration: InputDecoration(
                            hintText: l10n.commonSaySomething,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            // 文字数は入力欄の右下に自前で出す。
                            counterText: '',
                          ),
                        ),
                      ),
                      ExcludeSemantics(
                        child: Text(
                          '${controller.text.characters.length} / $maxPostMessageLength',
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (fixedDiaryBook != null)
                  // 投稿先が決まっているときも、どこに出るかは見せておく。
                  Text(
                    l10n.postSheetPostingTo(fixedDiaryBook.name),
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  )
                else if (diaryBooks.isNotEmpty) ...[
                  Text(
                    l10n.postSheetShareTo,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final diaryBook in diaryBooks)
                        DiaryBookChip(
                          label: diaryBook.name,
                          selected: selectedIds.contains(diaryBook.id),
                          onTap: () => toggleDiaryBook(diaryBook.id),
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: canSubmit ? submit : null,
                  child: submitting
                      ? SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.textSecondary,
                          ),
                        )
                      : Text(l10n.commonPost),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
