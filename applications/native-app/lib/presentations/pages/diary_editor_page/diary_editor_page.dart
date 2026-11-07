import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary/diary.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../providers/diary_book_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/format.dart';
import '../../components/confirm_sheet.dart';
import '../../components/discard_guard.dart';
import '../../components/post_line.dart';
import '../../components/ruled_lines.dart';
import 'components/diary_book_picker_sheet.dart';
import 'controller/diary_editor_page_controller.dart';

const _bodyFontSize = 16.0;
const _bodyLineHeight = 2.2;
const _bodyStyle = TextStyle(fontSize: _bodyFontSize, height: _bodyLineHeight);

/// 本文の1行の高さを固定する。罫線と文字が下の行までずれないようにするため。
const _bodyStrut = StrutStyle(
  fontSize: _bodyFontSize,
  height: _bodyLineHeight,
  forceStrutHeight: true,
);

/// 本文の入力欄の最低の行数。
const _bodyMinLines = 8;

/// 書いた行の下に足す、薄くなっていく罫線の本数。
const _fadingLines = 6;

/// 日記を書くページ。もう書いていれば編集になる。
/// 日記は日記帳ごとに書き、投稿を押したときにどの日記帳に書くかを選ぶ（何冊でも選べる）。
class DiaryEditorPage extends HookConsumerWidget {
  const DiaryEditorPage({
    super.key,
    required this.date,
    this.diaryBookId,
    this.blank = false,
  });

  final DateTime date;

  /// 開いた日記帳。投稿先として最初から選んでおく。null なら全冊を選んでおく。
  final String? diaryBookId;

  /// true なら、もう書いた日記があっても読み込まずに白紙で開く。
  final bool blank;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final provider = diaryEditorPageControllerProvider(date);
    final pageState = ref.watch(provider);
    final diaryBooksState = ref.watch(diaryBookProvider);

    Widget scaffold(Widget body) => Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: context.l10n.commonClose,
          icon: const Icon(Icons.close),
        ),
        title: Text(
          context.l10n.commonDiaryOfDate(formatMonthDay(context, date)),
        ),
      ),
      body: body,
    );

    return switch ((pageState, diaryBooksState)) {
      (
        AsyncValue(:final value?, hasError: false),
        AsyncValue(value: final diaryBooks?, hasError: false),
      ) =>
        _DiaryEditor(
          date: date,
          initialDiaryBookId: diaryBookId,
          blank: blank,
          diaryBooks: diaryBooks,
          state: value,
          onSave: ({required diaryBookIds, required title, required body}) =>
              ref
                  .read(provider.notifier)
                  .save(diaryBookIds: diaryBookIds, title: title, body: body),
        ),
      (AsyncError(), _) || (_, AsyncError()) => scaffold(
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.editorLoadFailed,
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  if (diaryBooksState.hasError) {
                    ref.invalidate(diaryBookProvider);
                  }
                  ref.read(provider.notifier).refresh();
                },
                child: Text(context.l10n.commonRetry),
              ),
            ],
          ),
        ),
      ),
      _ => scaffold(
        Center(child: CircularProgressIndicator(color: colors.textSecondary)),
      ),
    };
  }
}

/// 日記を書く欄。保存済みの日記は、最初に作ったときに読み込む。
class _DiaryEditor extends HookWidget {
  const _DiaryEditor({
    required this.date,
    required this.initialDiaryBookId,
    required this.blank,
    required this.diaryBooks,
    required this.state,
    required this.onSave,
  });

  final DateTime date;
  final String? initialDiaryBookId;
  final bool blank;
  final List<DiaryBook> diaryBooks;
  final DiaryEditorPageState state;

  /// [diaryBookIds] の日記帳に日記を書く。書けたら true。
  final Future<bool> Function({
    required List<String> diaryBookIds,
    required String title,
    required String body,
  })
  onSave;

  /// 書いている日記の日。今日なら 'today'、昨日なら 'yesterday'。
  /// 文言の中で「今日」「昨日」を選び分けるのに使う。
  String get _day {
    return date == diaryToday() ? 'today' : 'yesterday';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    /// 入力欄に読み込む日記。開いた日記帳にもう書いていればその日記、
    /// 日記帳を決めずに開いたときは、どれか1冊に書いたものを出す。白紙で開くときは null。
    final existing = useMemoized(() {
      if (blank) return null;
      final id = initialDiaryBookId;
      if (id != null) return state.diaries[id];
      return [for (final diaryBook in diaryBooks) ?state.diaries[diaryBook.id]]
          .firstOrNull;
    });

    /// 投稿先を聞くシートで、最初から選んでおく日記帳。
    /// 前に選んだものがあればそれを使う。
    final pickedIds = useState<Set<String>>({
      for (final diaryBook in diaryBooks)
        if (initialDiaryBookId == null || diaryBook.id == initialDiaryBookId)
          diaryBook.id,
    });

    /// 参加している日記帳すべてに、もう書いてあるか。
    final allWritten =
        diaryBooks.isNotEmpty &&
        diaryBooks.every(
          (diaryBook) => state.diaries.containsKey(diaryBook.id),
        );

    final titleController = useTextEditingController(
      text: existing?.title ?? '',
    );
    final bodyController = useTextEditingController(text: existing?.body ?? '');
    useListenable(titleController);
    useListenable(bodyController);
    final submitting = useState(false);

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final isDirty =
        title != (existing?.title ?? '') || body != (existing?.body ?? '');
    // 書いたままの日記は送り直さなくてよいので、変えたときか、
    // まだ書いていない日記帳があるときだけ押せる。
    final canSubmit =
        diaryBooks.isNotEmpty &&
        body.isNotEmpty &&
        (isDirty || !allWritten) &&
        !submitting.value;

    /// 投稿する日記帳を聞く。1冊しかなければ聞かずにその日記帳にする。
    /// やめたら null。
    Future<List<String>?> askDiaryBookIds() async {
      if (diaryBooks.length == 1) return [diaryBooks.single.id];
      final picked = await showDiaryBookPicker(
        context,
        title: l10n.editorPickerTitle,
        confirmLabel: existing == null ? l10n.editorPost : l10n.editorUpdate,
        diaryBooks: diaryBooks,
        initialIds: pickedIds.value,
        statusOf: (diaryBook) {
          return state.diaries.containsKey(diaryBook.id)
              ? l10n.editorStatusWritten(_day)
              : l10n.editorStatusNotYet(_day);
        },
      );
      if (picked != null) pickedIds.value = picked.toSet();
      return picked;
    }

    /// [diaryBookIds] のうち、ほかの日記がもう書いてある日記帳があれば、上書きしてよいかを聞く。
    /// 読み込んで直している日記そのものは、上書きするのが当たり前なので聞かない。
    Future<bool> confirmOverwrite(List<String> diaryBookIds) async {
      final overwritten = [
        for (final diaryBook in diaryBooks)
          if (diaryBookIds.contains(diaryBook.id) &&
              state.diaries[diaryBook.id] != null &&
              state.diaries[diaryBook.id] != existing)
            diaryBook,
      ];
      if (overwritten.isEmpty) return true;
      final isJa = Localizations.localeOf(context).languageCode == 'ja';
      final names = isJa
          ? overwritten.map((diaryBook) => '「${diaryBook.name}」').join()
          : overwritten.map((diaryBook) => '"${diaryBook.name}"').join(', ');
      return showConfirmSheet(
        context,
        title: l10n.editorOverwriteTitle,
        message: l10n.editorOverwriteMessage(names, _day),
        confirmLabel: l10n.editorOverwriteConfirm,
        destructive: true,
      );
    }

    Future<void> submit() async {
      if (!canSubmit) return;
      final diaryBookIds = await askDiaryBookIds();
      if (diaryBookIds == null || diaryBookIds.isEmpty || !context.mounted) {
        return;
      }
      if (!await confirmOverwrite(diaryBookIds) || !context.mounted) return;
      final isNew = existing == null;
      submitting.value = true;
      final ok = await onSave(
        diaryBookIds: diaryBookIds,
        title: title,
        body: body,
      );
      if (!context.mounted) return;
      submitting.value = false;
      final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
      if (!ok) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.editorSaveFailed)));
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(isNew ? l10n.editorPosted : l10n.editorUpdated)),
      );
      // 書けたので、書きかけの確認（DiscardGuard）を通さずに閉じる。
      Navigator.of(context).pop();
    }

    return DiscardGuard(
      dirty: isDirty,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            // 書きかけなら確認を挟むので maybePop にする。
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: l10n.commonClose,
            icon: const Icon(Icons.close),
          ),
          title: Text(l10n.commonDiaryOfDate(formatMonthDay(context, date))),
          actions: [
            TextButton(
              onPressed: canSubmit ? submit : null,
              child: submitting.value
                  ? SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textSecondary,
                      ),
                    )
                  : Text(
                      existing == null ? l10n.editorPost : l10n.editorUpdate,
                    ),
            ),
            const SizedBox(width: 8),
          ],
          // 日記帳がないと書けないので、日付の下に小さく知らせる。
          // タイトルの位置は動かさないよう、ツールバーの下に足す。
          bottom: diaryBooks.isEmpty
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(20),
                  // ツールバーの余白に食い込ませて、日付のすぐ下に寄せる。
                  child: Transform.translate(
                    offset: const Offset(0, -10),
                    child: Text(
                      l10n.editorNoDiaryBook,
                      // DatedTitle の日付と同じ大きさにする。
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              l10n.editorDayPosts(_day),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            if (state.posts.isEmpty)
              Text(
                l10n.commonNoPostsThisDay,
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              )
            else
              for (final post in state.posts) PostLine(post: post),
            // 日記の詳細と同じく、記録と本文を線で分ける。
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            // タイトルは任意。空なら本文だけの日記になる。
            // まだ書いていない日を開いたときは、タイトルから書き始められるようにする。
            TextField(
              controller: titleController,
              autofocus: existing == null,
              maxLength: maxDiaryTitleLength,
              textInputAction: TextInputAction.next,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              decoration: InputDecoration(
                hintText: l10n.editorTitleHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                counterText: '',
              ),
            ),
            // タイトルの下には、書いたあとも線を引いておく。
            const SizedBox(height: 8),
            Container(height: 1, color: colors.border),
            const SizedBox(height: 8),
            // 書いた行には罫線を引き、その下にだんだん薄くなる罫線を足しておく。
            // 改行や折り返しで行が増えるたびに、罫線も入力欄も伸ばす。
            LayoutBuilder(
              builder: (context, constraints) {
                final lines = measureTextLines(
                  context,
                  text: bodyController.text,
                  // TextField と同じく、テーマの文字の大きさに本文の指定を重ねて測る。
                  style: Theme.of(context).textTheme.titleMedium!
                      .merge(_bodyStyle),
                  strutStyle: _bodyStrut,
                  width: constraints.maxWidth,
                );
                final filledLines = lines.count;
                return RuledLines(
                  lineHeight: lines.lineHeight,
                  lineCount: _fadingLines,
                  filledLines: filledLines,
                  child: TextField(
                    controller: bodyController,
                    maxLength: maxDiaryBodyLength,
                    minLines: max(_bodyMinLines, filledLines + _fadingLines),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    textCapitalization: TextCapitalization.sentences,
                    style: _bodyStyle,
                    strutStyle: _bodyStrut,
                    // 行の高さいっぱいだと罫線をはみ出すので、文字の高さに合わせる。
                    cursorHeight: _bodyFontSize * 1.4,
                    decoration: InputDecoration(
                      hintText: l10n.editorBodyHint(_day),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      // 上限はかけるが、残りの文字数は出さない。
                      counterText: '',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
