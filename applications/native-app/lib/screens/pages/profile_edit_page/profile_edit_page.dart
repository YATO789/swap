import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/profile/profile.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/cover_color_picker.dart';
import '../../components/discard_guard.dart';
import '../../components/form_field.dart';
import '../../components/user_avatar.dart';
import 'controller/profile_edit_page_controller.dart';

/// 選べるアイコンの色。先頭の null は決まった塗り。
/// 表紙と同じ明るいパステルに、表紙にない色を足して色相の順に並べる。
/// 黒は決まった塗りと見分けにくいので入れない。
const _avatarColors = <Color?>[
  null,
  Color(0xFFFFB4A8),
  Color(0xFFFFC98A),
  Color(0xFFFFE07A),
  Color(0xFFC8E68C),
  Color(0xFF9EE6C4),
  Color(0xFF9EDCF0),
  Color(0xFFA8C8FF),
  Color(0xFFD9C2FF),
  Color(0xFFFFB3D9),
];

/// 表示名とアイコンの色を編集するページ。
class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final profile = ref.watch(profileRepositoryProvider).value;
    final savedName = profile?.displayName ?? '';
    final savedColor = profile?.avatarColor;
    final nameController = useTextEditingController(text: savedName);
    // 文字を打つたびに保存ボタンやエラー表示、アバターを更新する。
    useListenable(nameController);
    final name = nameController.text.trim();
    final avatarColor = useState(savedColor);
    final isDirty = name != savedName || avatarColor.value != savedColor;

    /// 保存中か。ボタンを押せなくして、処理中の表示を出す。
    final saving = ref.watch(profileEditPageControllerProvider).isLoading;

    Future<void> save() async {
      if (name.isEmpty || !isDirty || saving) return;
      FocusScope.of(context).unfocus();
      final messenger = ScaffoldMessenger.of(context);
      final succeeded = await ref
          .read(profileEditPageControllerProvider.notifier)
          .save(name: name, avatarColor: avatarColor.value);
      messenger.hideCurrentSnackBar();
      if (!succeeded) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.profileEditSaveFailed)),
        );
        return;
      }
      if (context.mounted) context.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.profileEditSaved)));
    }

    return DiscardGuard(
      // 保存中に戻ると確認が出てしまうので、保存が済むまでは書きかけとみなさない。
      dirty: isDirty && !saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.profileEditTitle),
          actions: [
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
                onPressed: name.isNotEmpty && isDirty ? save : null,
                child: Text(l10n.profileEditSave),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            Center(
              child: UserAvatar(
                name: name,
                filled: true,
                color: avatarColor.value,
                size: 72,
              ),
            ),
            const SizedBox(height: 24),
            FieldLabel(l10n.commonName),
            const SizedBox(height: 8),
            InputField(
              controller: nameController,
              maxLength: maxDisplayNameLength,
              hintText: l10n.commonEnterName,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => save(),
              errorText: name.isEmpty ? l10n.profileEditNameRequired : null,
            ),
            const SizedBox(height: 24),
            FieldLabel(l10n.profileEditAvatarColor),
            const SizedBox(height: 8),
            CoverColorPicker(
              alignment: WrapAlignment.start,
              choices: _avatarColors,
              // 色を選ばなければ、自分のアイコンはいつもの塗りつぶしになる。
              defaultColor: colors.textPrimary,
              label: l10n.profileEditAvatarColor,
              selected: avatarColor.value == null
                  ? null
                  : Color(avatarColor.value!),
              onSelected: (color) => avatarColor.value = color?.toARGB32(),
            ),
          ],
        ),
      ),
    );
  }
}
