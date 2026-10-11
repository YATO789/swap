import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/profile/profile.dart';
import '../../../theme/app_theme.dart';
import '../../components/form_field.dart';
import '../../components/user_avatar.dart';
import 'controller/onboarding_page_controller.dart';

/// サインインした直後に1回だけ出す初回設定。名前を決めるとホームへ進む。
class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final nameController = useTextEditingController();
    // 文字を打つたびに「はじめる」ボタンとアバターを更新する。
    useListenable(nameController);
    final name = nameController.text.trim();

    /// 名前の保存中か。ボタンを押せなくして、処理中の表示を出す。
    final saving = ref.watch(onboardingPageControllerProvider).isLoading;

    // 保存できたらルーターがホームに切り替えるので、ここでは失敗だけ扱う。
    Future<void> submit() async {
      if (name.isEmpty || saving) return;
      FocusScope.of(context).unfocus();
      final succeeded = await ref
          .read(onboardingPageControllerProvider.notifier)
          .saveName(name);
      if (!context.mounted || succeeded) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('名前を保存できませんでした。もう一度お試しください')),
        );
    }

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'なんて呼べばいい？',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '日記帳のメンバーに表示される名前です。あとから変えられます。',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Center(
                      child: UserAvatar(name: name, filled: true, size: 72),
                    ),
                    const SizedBox(height: 24),
                    const FieldLabel('名前'),
                    const SizedBox(height: 8),
                    InputField(
                      controller: nameController,
                      maxLength: maxDisplayNameLength,
                      hintText: '名前を入力',
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submit(),
                    ),
                  ],
                ),
              ),
              // 保存中は二度押しできないようにして、待っていることを見せる。
              FilledButton(
                onPressed: name.isEmpty || saving ? null : submit,
                child: saving
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textSecondary,
                        ),
                      )
                    : const Text('はじめる'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
