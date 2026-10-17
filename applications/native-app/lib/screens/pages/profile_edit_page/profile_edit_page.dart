import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/profile/profile.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/discard_guard.dart';
import '../../components/form_field.dart';
import '../../components/user_avatar.dart';
import 'controller/profile_edit_page_controller.dart';

/// 表示名を編集するページ。
class ProfileEditPage extends HookConsumerWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final savedName =
        ref.watch(profileRepositoryProvider).value?.displayName ?? '';
    final nameController = useTextEditingController(text: savedName);
    // 文字を打つたびに保存ボタンやエラー表示、アバターを更新する。
    useListenable(nameController);
    final name = nameController.text.trim();
    final isDirty = name != savedName;

    /// 名前の保存中か。ボタンを押せなくして、処理中の表示を出す。
    final saving = ref.watch(profileEditPageControllerProvider).isLoading;

    Future<void> save() async {
      if (name.isEmpty || !isDirty || saving) return;
      FocusScope.of(context).unfocus();
      final messenger = ScaffoldMessenger.of(context);
      final succeeded = await ref
          .read(profileEditPageControllerProvider.notifier)
          .saveName(name);
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
            Center(child: UserAvatar(name: name, filled: true, size: 72)),
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
