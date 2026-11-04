import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../domains/profile/profile.dart';
import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';
import '../../../components/user_avatar.dart';
import '../../../providers/profile_notifier.dart';
import '../controller/profile_controller.dart';
import 'avatar_action_sheet.dart';

/// 設定画面のいちばん上で、アイコンの画像と表示名をその場で変える欄。
/// 画像は選んだらすぐ保存し、名前は入力を終えたとき（完了を押すか、欄の外に移ったとき）に保存する。
class ProfileSection extends HookConsumerWidget {
  const ProfileSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profile = ref.watch(profileProvider).value;
    final savedName = profile?.displayName ?? '';
    final nameController = useTextEditingController(text: savedName);
    final focusNode = useFocusNode();
    // 文字を打つたびにエラーの表示を更新する。
    useListenable(nameController);
    useListenable(focusNode);
    final name = nameController.text.trim();

    /// 保存中か。続けて保存しないようにして、アイコンに処理中の印を出す。
    final saving = ref.watch(profileControllerProvider).isLoading;

    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    // 入力した直後は作り直す前に呼ばれることがあるので、名前は入力欄から読む。
    String enteredName() {
      return nameController.text.trim();
    }

    Future<bool> save({Uint8List? newAvatar, bool removesAvatar = false}) {
      final name = enteredName();
      return ref
          .read(profileControllerProvider.notifier)
          .save(
            // 名前が空のままなら、保存してある名前のまま画像だけ変える。
            name: name.isNotEmpty ? name : savedName,
            newAvatar: newAvatar,
            removesAvatar: removesAvatar,
          );
    }

    // 入力を終えたら、変えた名前を保存する。空のまま離れたら、保存してある名前に戻す。
    Future<void> saveName() async {
      final name = enteredName();
      if (name.isEmpty) {
        nameController.text = savedName;
        return;
      }
      if (name == savedName || ref.read(profileControllerProvider).isLoading) {
        return;
      }
      final succeeded = await save();
      if (!context.mounted) return;
      showMessage(
        succeeded ? l10n.profileEditSaved : l10n.profileEditSaveFailed,
      );
    }

    // 画像がなければ、外すものがないのでシートを出さずに写真を選ぶ。
    Future<void> changeAvatar() async {
      if (saving) return;
      FocusScope.of(context).unfocus();
      if (profile?.avatarUrl != null) {
        final action = await showAvatarActionSheet(context);
        if (action == null) return;
        if (action == AvatarAction.remove) {
          if (!await save(removesAvatar: true) && context.mounted) {
            showMessage(l10n.profileEditSaveFailed);
          }
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
        if (context.mounted) showMessage(l10n.profileEditPickAvatarFailed);
        return;
      }
      if (!await save(newAvatar: bytes) && context.mounted) {
        showMessage(l10n.profileEditSaveFailed);
      }
    }

    // アイコンを大きく真ん中に置き、その下に名前を横いっぱいの丸い欄で出す。
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: _AvatarButton(
              imageUrl: profile?.avatarUrl,
              saving: saving,
              onPressed: changeAvatar,
            ),
          ),
          const SizedBox(height: 24),
          // 欄の外に移ったら（完了を押したときも）保存する。
          Focus(
            skipTraversal: true,
            onFocusChange: (hasFocus) {
              if (!hasFocus) saveName();
            },
            child: _NameField(controller: nameController, focusNode: focusNode),
          ),
          if (focusNode.hasFocus && name.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
              child: Text(
                l10n.profileEditNameRequired,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 名前を真ん中に書いた、横いっぱいの丸い欄。右の鉛筆を押しても書き始められる。
class _NameField extends StatelessWidget {
  const _NameField({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  static const _height = 64.0;

  // 名前が真ん中に来るよう、右の鉛筆と同じ幅を左にもあける。
  static const _iconSpace = 56.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: colors.placeholder,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            const SizedBox(width: _iconSpace),
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                maxLength: maxDisplayNameLength,
                textAlign: TextAlign.center,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  hintText: context.l10n.commonEnterName,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  counterText: '',
                ),
              ),
            ),
            SizedBox(
              width: _iconSpace,
              child: IconButton(
                onPressed: focusNode.requestFocus,
                tooltip: context.l10n.commonName,
                icon: Icon(Icons.edit_outlined, color: colors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 押すとアイコンの画像を選べる大きなアバター。右下に鉛筆の印を浮かせ、保存中は処理中の印を重ねる。
class _AvatarButton extends StatelessWidget {
  const _AvatarButton({
    required this.imageUrl,
    required this.saving,
    required this.onPressed,
  });

  final String? imageUrl;
  final bool saving;
  final VoidCallback onPressed;

  static const _size = 104.0;

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
            UserAvatar(imageUrl: imageUrl, size: _size),
            if (saving)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface.withValues(alpha: 0.6),
                  ),
                  child: Center(
                    child: SizedBox.square(
                      dimension: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            Positioned(
              right: -4,
              bottom: -4,
              child: ExcludeSemantics(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(Icons.edit, size: 18, color: colors.textPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
