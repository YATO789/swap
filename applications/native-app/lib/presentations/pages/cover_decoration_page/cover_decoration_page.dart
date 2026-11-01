import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/diary_book/cover_decoration.dart';
import '../../../domains/diary_book/diary_book.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/cover_color_picker.dart';
import '../../components/cover_decoration_layer.dart';
import '../../components/diary_book_icon.dart';
import '../../components/diary_cover.dart';
import '../../components/discard_guard.dart';
import '../../providers/diary_book_notifier.dart';
import 'components/bar_button.dart';
import 'components/color_palette.dart';
import 'components/cover_editor_canvas.dart';
import 'components/cover_text_sheet.dart';
import 'components/emoji_sheet.dart';
import 'components/pen_tools.dart';
import 'components/selection_bar.dart';
import 'components/text_style_bar.dart';
import 'controller/cover_decoration_page_controller.dart';

/// 元に戻すために覚えておく、変える前の色・飾り。
typedef _Snapshot = ({int? coverColor, CoverDecoration decoration});

/// 日記帳の表紙を編集するページ。色を変え、絵文字・文字を貼り、らくがきをする。
///
/// 名前も貼ったものの1つで、動かしたり表紙から外したりできる。名前そのものは
/// 日記帳の情報ページでしか変えない。選んでいる文字をもう一度押すと書き換えられる。
/// 貼ったものはドラッグで動かし、右下のつまみか2本指で回転と拡大縮小をする。
/// 「らくがき」を押すと表紙をなぞって線を描け、「色」を押すと表紙の色を選べる。
/// 「保存」を押すまでは日記帳に反映しない。
class CoverDecorationPage extends ConsumerWidget {
  const CoverDecorationPage({super.key, required this.diaryBookId});

  final String diaryBookId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diaryBook = ref
        .watch(diaryBookProvider)
        .value
        ?.where((diaryBook) => diaryBook.id == diaryBookId)
        .firstOrNull;
    // 一覧を読み込み中か、もう参加していない。
    if (diaryBook == null) return const Scaffold();
    // 新しいアプリで飾った表紙は、知らない飾りを消さないよう編集させない。
    // 入口でも止めているが、通知などから直接開いたときのためにここでも止める。
    if (!(diaryBook.coverDecoration?.isEditable ?? true)) {
      return Scaffold(
        appBar: AppBar(title: Text(context.l10n.coverEditTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              context.l10n.coverEditNeedsUpdate,
              textAlign: TextAlign.center,
              style: TextStyle(color: context.appColors.textSecondary),
            ),
          ),
        ),
      );
    }
    return _CoverEditor(original: diaryBook);
  }
}

class _CoverEditor extends HookConsumerWidget {
  const _CoverEditor({required this.original});

  /// 開いたときの日記帳。保存するときは、これと比べて変わったところだけを書く。
  /// 開いているあいだに一覧を読み直して変わっても、開いたときのままにする。
  final DiaryBook original;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;

    final opened = useState(original).value;
    // 名前はここでは変えない。
    final name = opened.name;
    final coverColor = useState(opened.coverColor);

    /// 開いたときの飾り。名前を貼ったものにする前の飾りなら、前と同じ場所と大きさの名前を一番上に足す。
    /// 名前を貼ったものに直しただけなら、変えていないことにする。
    final initialDecoration = useMemoized(() {
      final decoration =
          opened.coverDecoration ?? const CoverDecoration(version: 1);
      if (decoration.placesName) return decoration;
      return decoration.copyWith(
        version: coverDecorationVersion,
        stickers: [...decoration.stickers, _fixedNameSticker(name)],
      );
    });
    final decoration = useState(initialDecoration);
    final history = useState(const <_Snapshot>[]);
    final selected = useState<int?>(null);
    final mode = useState(CoverEditMode.stickers);
    final penColor = useState(penColors.first);
    final penWidth = useState(penWidths[1]);
    final erasing = useState(false);

    /// 今の操作を始めてから、元に戻す履歴をもう足したか。
    final remembered = useRef(false);
    final random = useMemoized(Random.new);

    final saving = ref.watch(coverDecorationPageControllerProvider).isLoading;
    final edited = opened.copyWith(
      coverColor: coverColor.value,
      // 何も貼っていなくても飾りとして保存する（名前を外したことになる）。
      coverDecoration: decoration.value == initialDecoration
          ? opened.coverDecoration
          : decoration.value,
    );
    final isDirty = edited != opened;
    final selectedIndex = selected.value;
    final selectedSticker = selectedIndex == null
        ? null
        : decoration.value.stickers[selectedIndex];
    final inkColor = coverInkColor(
      coverColor.value == null
          ? defaultCoverColor(context)
          : Color(coverColor.value!),
    );

    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    void remember() {
      history.value = [
        ...history.value,
        (coverColor: coverColor.value, decoration: decoration.value),
      ];
    }

    /// 1回で戻せる変更をする。
    void edit(void Function() change) {
      remember();
      change();
    }

    void undo() {
      final previous = history.value.last;
      history.value = history.value.sublist(0, history.value.length - 1);
      coverColor.value = previous.coverColor;
      decoration.value = previous.decoration;
      selected.value = null;
    }

    /// ドラッグや線を描くあいだの変更。1回の操作のあいだは最初の1回だけ履歴を足す。
    void changeDecoration(CoverDecoration changed) {
      if (!remembered.value) {
        remember();
        remembered.value = true;
      }
      decoration.value = changed;
    }

    void setMode(CoverEditMode value) {
      mode.value = value;
      selected.value = null;
    }

    /// -[range]/2〜[range]/2 のどれか。まっすぐより少し傾いているほうが、貼ったように見える。
    double tilt(double range) {
      return (random.nextDouble() - 0.5) * range;
    }

    /// [sticker] を一番上に貼って選ぶ。
    void add(CoverSticker sticker) {
      edit(() {
        decoration.value = decoration.value.addSticker(sticker);
        selected.value = decoration.value.stickers.length - 1;
      });
    }

    Future<void> pickEmoji() async {
      if (!decoration.value.canAddSticker) {
        showMessage(l10n.coverEditStickerLimit(maxCoverStickers));
        return;
      }
      final emoji = await showEmojiSheet(context);
      if (emoji == null || !context.mounted) return;
      // 続けて貼っても重ならないよう、真ん中あたりで少しずらす。
      add(
        CoverSticker(
          emoji: emoji,
          x: 0.55 + tilt(0.3),
          y: 0.75 + tilt(0.4),
          size: 0.22,
          rotation: tilt(0.4),
        ),
      );
    }

    Future<void> pickText() async {
      final choice = await showCoverTextSheet(
        context,
        offerName: !decoration.value.hasName,
      );
      if (choice == null || !context.mounted) return;
      if (!decoration.value.canAddSticker) {
        showMessage(l10n.coverEditStickerLimit(maxCoverStickers));
        return;
      }
      if (choice.name) {
        add(_fixedNameSticker(name));
        return;
      }
      if (!decoration.value.canAddText) {
        showMessage(l10n.coverEditTextLimit(maxCoverTexts));
        return;
      }
      // 表紙の幅の 0.12 くらいの大きさの文字にする。長い文字は表紙に収まるよう小さくする。
      final size = (0.12 * coverTextWidth(choice.text) / coverTextBaseSize)
          .clamp(0.2, 0.86);
      add(
        CoverSticker(
          text: choice.text,
          x: 0.55 + tilt(0.2),
          y: 0.7 + tilt(0.3),
          size: size,
          rotation: tilt(0.2),
        ),
      );
    }

    /// [index] の文字を書き換える。文字の大きさが変わらないよう幅も変える。
    Future<void> editText(int index) async {
      final sticker = decoration.value.stickers[index];
      final text = sticker.text;
      if (text == null) return;
      final choice = await showCoverTextSheet(context, initialText: text);
      if (choice == null || choice.text == text || !context.mounted) return;
      edit(() {
        decoration.value = decoration.value.replaceSticker(
          index,
          resizedCoverText(
            sticker,
            text,
            choice.text,
          ).copyWith(text: choice.text),
        );
      });
    }

    void moveSelected(int offset) {
      final from = selectedIndex!;
      edit(() {
        decoration.value = decoration.value.moveSticker(from, from + offset);
        selected.value = from + offset;
      });
    }

    Future<void> save() async {
      if (!isDirty || saving) return;
      final messenger = ScaffoldMessenger.of(context);
      final succeeded = await ref
          .read(coverDecorationPageControllerProvider.notifier)
          .save(opened, edited);
      messenger.hideCurrentSnackBar();
      if (!succeeded) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.coverEditSaveFailed)),
        );
        return;
      }
      if (context.mounted) Navigator.of(context).pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.coverEditSaved)));
    }

    return DiscardGuard(
      // 保存中に戻ると確認が出てしまうので、保存が済むまでは書きかけとみなさない。
      dirty: isDirty && !saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.coverEditTitle),
          actions: [
            IconButton(
              onPressed: history.value.isEmpty || saving ? null : undo,
              tooltip: l10n.coverEditUndo,
              icon: const Icon(Icons.undo),
            ),
            // 保存中は二度押しできないようにして、待っていることを見せる。
            if (saving)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox.square(
                  dimension: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colors.textSecondary,
                  ),
                ),
              )
            else
              TextButton(
                onPressed: isDirty ? save : null,
                child: Text(l10n.commonSave),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ColoredBox(
                color: colors.placeholder,
                // 表紙のまわりや、何も貼っていないところを押したら選ぶのをやめる。
                child: GestureDetector(
                  onTap: () => selected.value = null,
                  behavior: HitTestBehavior.opaque,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = min(
                        constraints.maxWidth - 40,
                        (constraints.maxHeight - 40) / coverHeightRatio,
                      );
                      return Center(
                        child: DiaryCover(
                          name: name,
                          color: coverColor.value == null
                              ? null
                              : Color(coverColor.value!),
                          width: width,
                          decorationLayer: CoverEditorCanvas(
                            decoration: decoration.value,
                            coverWidth: width,
                            name: name,
                            inkColor: inkColor,
                            mode: mode.value,
                            selected: selectedIndex,
                            penColor: penColor.value,
                            penWidth: penWidth.value,
                            erasing: erasing.value,
                            onSelect: (index) => selected.value = index,
                            onEditStart: () => remembered.value = false,
                            onChanged: changeDecoration,
                            onEditText: editText,
                            onStrokeLimit: () =>
                                showMessage(l10n.coverEditStrokeLimit),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            switch (mode.value) {
              CoverEditMode.doodle => PenColorBar(
                color: erasing.value ? null : penColor.value,
                onSelected: (color) {
                  penColor.value = color;
                  erasing.value = false;
                },
              ),
              CoverEditMode.stickers => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedSticker != null && selectedSticker.isText)
                    TextStyleBar(
                      sticker: selectedSticker,
                      onEdit: selectedSticker.text == null
                          ? null
                          : () => editText(selectedIndex!),
                      onColor: (color) => edit(() {
                        decoration.value = decoration.value.replaceSticker(
                          selectedIndex!,
                          selectedSticker.copyWith(color: color),
                        );
                      }),
                    ),
                  SelectionBar(
                    sticker: selectedSticker,
                    hint: decoration.value.canAddSticker
                        ? l10n.coverEditHint
                        : l10n.coverEditStickerLimit(maxCoverStickers),
                    canMoveUp:
                        selectedIndex != null &&
                        selectedIndex < decoration.value.stickers.length - 1,
                    canMoveDown: selectedIndex != null && selectedIndex > 0,
                    onMoveUp: () => moveSelected(1),
                    onMoveDown: () => moveSelected(-1),
                    onToggleFrame: () => edit(() {
                      decoration.value = decoration.value.replaceSticker(
                        selectedIndex!,
                        selectedSticker!.copyWith(
                          frame: !selectedSticker.frame,
                        ),
                      );
                    }),
                    onRemove: () => edit(() {
                      decoration.value = decoration.value.removeSticker(
                        selectedIndex!,
                      );
                      selected.value = null;
                    }),
                  ),
                ],
              ),
              CoverEditMode.color => const SizedBox.shrink(),
            },
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 12),
                child: switch (mode.value) {
                  CoverEditMode.stickers => _ModeButtons(
                    enabled: !saving,
                    canAddSticker: decoration.value.canAddSticker,
                    // 文字を置けなくても、外した名前は置き直せるようにする。
                    canAddText:
                        decoration.value.canAddText ||
                        (decoration.value.canAddSticker &&
                            !decoration.value.hasName),
                    onEmoji: pickEmoji,
                    onText: pickText,
                    onDoodle: () => setMode(CoverEditMode.doodle),
                    onColor: () => setMode(CoverEditMode.color),
                  ),
                  CoverEditMode.doodle => PenTools(
                    width: penWidth.value,
                    erasing: erasing.value,
                    onWidthSelected: (width) {
                      penWidth.value = width;
                      erasing.value = false;
                    },
                    onEraserToggled: () => erasing.value = !erasing.value,
                    onDone: () => setMode(CoverEditMode.stickers),
                  ),
                  CoverEditMode.color => _ColorTools(
                    selected: coverColor.value,
                    onSelected: (color) {
                      if (color == coverColor.value) return;
                      edit(() => coverColor.value = color);
                    },
                    onDone: () => setMode(CoverEditMode.stickers),
                  ),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 絵文字・文字・らくがき・色を選ぶボタン。絵を上に、名前を下に置く。
class _ModeButtons extends StatelessWidget {
  const _ModeButtons({
    required this.enabled,
    required this.canAddSticker,
    required this.canAddText,
    required this.onEmoji,
    required this.onText,
    required this.onDoodle,
    required this.onColor,
  });

  final bool enabled;
  final bool canAddSticker;
  final bool canAddText;
  final VoidCallback onEmoji;
  final VoidCallback onText;
  final VoidCallback onDoodle;
  final VoidCallback onColor;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      children: [
        for (final (index, (icon, label, onPressed)) in [
          (
            Icons.add_reaction_outlined,
            l10n.coverEditEmoji,
            canAddSticker ? onEmoji : null,
          ),
          (Icons.text_fields, l10n.coverEditText, canAddText ? onText : null),
          (Icons.gesture, l10n.coverEditDoodle, onDoodle),
          (Icons.palette_outlined, l10n.coverEditColor, onColor),
        ].indexed) ...[
          if (index > 0) const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: enabled ? onPressed : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 60),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 22),
                  const SizedBox(height: 4),
                  Text(label, maxLines: 1),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// 飾りのない表紙で名前を出している場所・大きさの、名前の貼ったもの。
///
/// 飾りのない表紙では、幅 168 の表紙で左 28・右 16 を空けた真ん中、上から 40 のところに、
/// 名前の長さで 22・19・16 の大きさで名前を出す（[DiaryCover]）。収まらない長い名前は1行のまま縮める。
CoverSticker _fixedNameSticker(String name) {
  final length = name.runes.length;
  final fontSize = (length <= 6 ? 22.0 : (length <= 12 ? 19.0 : 16.0)) / 168;
  const maxWidth = (168 - 28 - 16) / 168;
  final textWidth = coverTextWidth(name);
  final width = min(fontSize * textWidth / coverTextBaseSize, maxWidth);
  final shownSize = width * coverTextBaseSize / textWidth;
  return CoverSticker(
    isName: true,
    x: (28 + (168 - 28 - 16) / 2) / 168,
    y: 40 / 168 + shownSize * coverTextHeight / 2,
    size: width,
  );
}

/// [color] が決まった表紙の色（[coverColors]）のどれかか。null は決まったグレー。
bool _isPresetCoverColor(int? color) {
  return coverColors.any((preset) => preset?.toARGB32() == color);
}

/// 色を選んでいるあいだの、表紙の色を選ぶ丸の並びと終わるボタン。
/// 決まった色の後ろの虹色の丸で、パレットから好きな色を選べる。
class _ColorTools extends StatelessWidget {
  const _ColorTools({
    required this.selected,
    required this.onSelected,
    required this.onDone,
  });

  /// 選んでいる表紙の色（0xAARRGGBB）。null なら決まったグレー。
  final int? selected;
  final ValueChanged<int?> onSelected;
  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    final selected = this.selected;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        CoverColorPicker(
          selected: selected == null ? null : Color(selected),
          onSelected: (color) => onSelected(color?.toARGB32()),
          // 決まった色の丸と同じ 32 の枠に、中の丸と同じ大きさで置く。
          trailing: SizedBox.square(
            dimension: 32,
            child: Center(
              child: PaletteDot(
                title: context.l10n.colorPaletteCoverTitle,
                custom: _isPresetCoverColor(selected) ? null : selected,
                onSelected: onSelected,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: DoneButton(
            label: context.l10n.coverEditDone,
            onPressed: onDone,
          ),
        ),
      ],
    );
  }
}
