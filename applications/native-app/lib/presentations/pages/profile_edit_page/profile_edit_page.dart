import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domains/profile/profile.dart';
import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/discard_guard.dart';
import '../../components/form_field.dart';
import '../../components/user_avatar.dart';
import 'components/avatar_action_sheet.dart';
import 'controller/profile_edit_page_controller.dart';

/// 表示名とアイコンの画像を編集するページ。
class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider).value;
    final savedName = profile?.displayName ?? '';
    final savedAvatarUrl = profile?.avatarUrl;
    final nameController = useTextEditingController(text: savedName);
    // 文字を打つたびに保存ボタンやエラー表示を更新する。
    useListenable(nameController);
    final name = nameController.text.trim();

    /// 選んだが、まだ保存していない画像。
    final newAvatar = useState<Uint8List?>(null);

    /// 今の画像を外したか。
    final removesAvatar = useState(false);
    final hasAvatar =
        newAvatar.value != null ||
        (!removesAvatar.value && savedAvatarUrl != null);
    final isDirty =
        name != savedName || newAvatar.value != null || removesAvatar.value;

    /// 保存中か。ボタンを押せなくして、処理中の表示を出す。
    final saving = ref.watch(profileEditPageControllerProvider).isLoading;

    Future<void> save() async {
      if (name.isEmpty || !isDirty || saving) return;
      FocusScope.of(context).unfocus();
      final messenger = ScaffoldMessenger.of(context);
      final succeeded = await ref
          .read(profileEditPageControllerProvider.notifier)
          .save(
            name: name,
            newAvatar: newAvatar.value,
            removesAvatar: removesAvatar.value,
          );
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

    // 画像がなければ、外すものがないのでシートを出さずに写真を選ぶ。
    Future<void> changeAvatar() async {
      if (saving) return;
      final messenger = ScaffoldMessenger.of(context);
      if (hasAvatar) {
        final action = await showAvatarActionSheet(context);
        if (action == null) return;
        if (action == AvatarAction.remove) {
          newAvatar.value = null;
          removesAvatar.value = true;
          return;
        }
      }
      final Uint8List bytes;
      try {
        // 長い辺を 256px に縮め、JPEG の画質 75 にして容量を抑える。
        final file = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 256,
          maxHeight: 256,
          imageQuality: 75,
        );
        if (file == null) return;
        bytes = await file.readAsBytes();
      } on Object catch (e, stackTrace) {
        debugPrint('写真を読み込めませんでした: $e\n$stackTrace');
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(l10n.profileEditPickAvatarFailed)),
          );
        return;
      }
      newAvatar.value = bytes;
      removesAvatar.value = false;
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
              child: _AvatarButton(
                imageUrl: removesAvatar.value ? null : savedAvatarUrl,
                imageBytes: newAvatar.value,
                onPressed: changeAvatar,
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
          ],
        ),
      ),
    );
  }
}

/// 押すとアイコンの画像を選べるアバター。右下にカメラの印を付ける。
class _AvatarButton extends StatelessWidget {
  const _AvatarButton({
    required this.imageUrl,
    required this.imageBytes,
    required this.onPressed,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final VoidCallback onPressed;

  static const _size = 72.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: context.l10n.profileEditChangeAvatar,
      child: GestureDetector(
        onTap: onPressed,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            UserAvatar(
              imageUrl: imageUrl,
              imageBytes: imageBytes,
              size: _size,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: ExcludeSemantics(
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.textPrimary,
                    border: Border.all(color: colors.surface, width: 2),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: 13,
                    color: colors.surface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
