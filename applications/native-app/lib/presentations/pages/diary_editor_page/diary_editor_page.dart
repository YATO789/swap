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
import '../../components/diary_book_icon.dart';
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
/// 日記は日記帳ごとに書き、書く日記帳はページの上で選び直せる。
/// 「すべての日記帳」を選ぶと、参加している日記帳すべてに同じ日記を書く。
class DiaryEditorPage extends HookConsumerWidget {
  const DiaryEditorPage({super.key, required this.date, this.diaryBookId});

  final DateTime date;

  /// 書く日記帳。null ならすべての日記帳。
  final String? diaryBookId;

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

/// 日記を書く欄。保存済みの日記は、最初に作ったときと日記帳を選び直したときに読み込む。
class _DiaryEditor extends HookWidget {
  const _DiaryEditor({
    required this.date,
    required this.initialDiaryBookId,
    required this.diaryBooks,
    required this.state,
    required this.onSave,
  });

  final DateTime date;
  final String? initialDiaryBookId;
  final List<DiaryBook> diaryBooks;
  final DiaryEditorPageState state;

  /// [diaryBookIds] の日記帳に日記を書く。書けたら true。
  final Future<bool> Function({
    required List<String> diaryBookIds,
    required String title,
    required String body,
  })
  onSave;

  /// [diaryBookId] を選んだときに日記を書き込む日記帳の id。null ならすべての日記帳。
  /// 抜けた日記帳を選んでいたら空。
  List<String> _targetIdsOf(String? diaryBookId) => [
    for (final diaryBook in diaryBooks)
      if (diaryBookId == null || diaryBook.id == diaryBookId) diaryBook.id,
  ];

  /// 書き込む日記帳のうち、もう書いてある日記。
  List<Diary> _writtenIn(List<String> targetIds) => [
    for (final id in targetIds) ?state.diaries[id],
  ];

  /// 書いている日記の日。今日なら 'today'、昨日なら 'yesterday'。
  /// 文言の中で「今日」「昨日」を選び分けるのに使う。
  String get _day =>
      date == diaryDateOf(DateTime.now()) ? 'today' : 'yesterday';

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    /// 書く日記帳。null ならすべての日記帳。
    final diaryBookId = useState(initialDiaryBookId);
    final targetIds = _targetIdsOf(diaryBookId.value);
    final written = _writtenIn(targetIds);

    /// 入力欄に読み込む日記。すべての日記帳のときは、どれか1冊に書いたものを出す。
    final existing = written.firstOrNull;

    /// 書き込む日記帳すべてに、もう書いてあるか。
    final allWritten =
        targetIds.isNotEmpty && written.length == targetIds.length;

    final initial = useMemoized(
      () => _writtenIn(_targetIdsOf(initialDiaryBookId)).firstOrNull,
    );
    final titleController = useTextEditingController(
      text: initial?.title ?? '',
    );
    final bodyController = useTextEditingController(text: initial?.body ?? '');
    useListenable(titleController);
    useListenable(bodyController);

    /// 保存済みのタイトルと本文。書きかけかどうかを比べるのに使う。
    final savedTitle = useState(initial?.title ?? '');
    final savedBody = useState(initial?.body ?? '');
    final submitting = useState(false);

    final title = titleController.text.trim();
    final body = bodyController.text.trim();
    final isDirty = title != savedTitle.value || body != savedBody.value;
    // 書いたままの日記は送り直さなくてよいので、変えたときか、
    // まだ書いていない日記帳があるときだけ押せる。
    final canSubmit =
        targetIds.isNotEmpty &&
        body.isNotEmpty &&
        (isDirty || !allWritten) &&
        !submitting.value;

    /// 保存済みの日記を入力欄に読み込む。
    void loadSaved(Diary? diary) {
      savedTitle.value = diary?.title ?? '';
      savedBody.value = diary?.body ?? '';
      titleController.text = savedTitle.value;
      bodyController.text = savedBody.value;
    }

    /// 書く日記帳を選び直す。その日記帳にもう書いていれば、その日記を読み込む。
    Future<void> pickDiaryBook() async {
      final writtenCount = _writtenIn(_targetIdsOf(null)).length;
      final picked = await showDiaryBookPicker(
        context,
        title: l10n.editorPickerTitle,
        diaryBooks: diaryBooks,
        selectedId: diaryBookId.value ?? allDiaryBooks,
        allStatus: l10n.editorAllStatus(_day, diaryBooks.length, writtenCount),
        statusOf: (diaryBook) => state.diaries.containsKey(diaryBook.id)
            ? l10n.editorStatusWritten(_day)
            : l10n.editorStatusNotYet(_day),
      );
      if (picked == null || !context.mounted) return;
      final id = picked == allDiaryBooks ? null : picked;
      if (id == diaryBookId.value) return;
      // 書きかけは日記帳を変えると消えるので、確かめてから切り替える。
      if (isDirty && !await confirmDiscard(context)) return;
      diaryBookId.value = id;
      loadSaved(_writtenIn(_targetIdsOf(id)).firstOrNull);
    }

    Future<void> submit() async {
      if (!canSubmit) return;
      final isNew = existing == null;
      submitting.value = true;
      final ok = await onSave(
        diaryBookIds: targetIds,
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
          // 書く日記帳は日付の下に小さく出す。タイトルの位置は動かさないよう、
          // ツールバーの下に足す。
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(20),
            // ツールバーの余白に食い込ませて、日付のすぐ下に寄せる。
            child: Transform.translate(
              offset: const Offset(0, -10),
              // 押せる範囲を文字の幅だけにするため、真ん中に寄せて置く。
              child: Center(
                child: _DiaryBookSelector(
                  diaryBooks: diaryBooks,
                  diaryBookId: diaryBookId.value,
                  onTap: diaryBooks.length > 1 ? pickDiaryBook : null,
                ),
              ),
            ),
          ),
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
              autofocus: initial == null,
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

/// タイトルの下に小さく出す、日記を書く日記帳。[onTap] があれば押して選び直せる。
/// [diaryBookId] が null ならすべての日記帳（1冊だけならその日記帳）を出す。
class _DiaryBookSelector extends StatelessWidget {
  const _DiaryBookSelector({
    required this.diaryBooks,
    required this.diaryBookId,
    required this.onTap,
  });

  final List<DiaryBook> diaryBooks;
  final String? diaryBookId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // DatedTitle の日付と同じ大きさにする。
    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: colors.textSecondary,
    );
    final id = diaryBookId;
    final diaryBook = id != null
        ? diaryBooks.where((diaryBook) => diaryBook.id == id).firstOrNull
        : diaryBooks.length == 1
        ? diaryBooks.single
        : null;
    final isAll = id == null && diaryBooks.length > 1;
    if (diaryBook == null && !isAll) {
      return Text(context.l10n.editorNoDiaryBook, style: style);
    }
    final name = isAll ? context.l10n.diaryBookPickerAll : diaryBook!.name;

    return Semantics(
      button: onTap != null,
      label: context.l10n.editorDiaryBookSemantics(name),
      hint: onTap == null ? null : context.l10n.editorChangeDiaryBook,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAll)
                Icon(
                  Icons.library_books_outlined,
                  size: 14,
                  color: colors.textSecondary,
                )
              else
                DiaryBookIcon(
                  name: diaryBook!.name,
                  coverColor: diaryBook.coverColor,
                  size: 14,
                ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  name,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_drop_down,
                  size: 16,
                  color: colors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
