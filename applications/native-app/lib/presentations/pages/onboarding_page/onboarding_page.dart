import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domains/profile/profile.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/avatar_color_picker.dart';
import '../../components/form_field.dart';
import '../../components/user_avatar.dart';
import 'components/notification_step.dart';
import 'controller/onboarding_page_controller.dart';

/// サインインした直後に1回だけ出す初回設定。名前とアイコンの色を決め、通知の許可を聞いてからホームへ進む。
class OnboardingPage extends HookConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final nameController = useTextEditingController();
    // 変更を監視し、変更があったときに Widget を再ビルドする Flutter Hooks の関数
    useListenable(nameController);
    final name = nameController.text.trim();
    final avatarColor = useState(initialAvatarColor);

    /// 通知のページを出しているか。名前は最後にまとめて保存するので、ここでは進んだことだけ覚える。
    final showsNotificationStep = useState(false);

    /// 名前の保存中か。ボタンを押せなくして、処理中の表示を出す。
    final saving = ref.watch(onboardingPageControllerProvider).isLoading;

    /// 「あとで」で始めたか。処理中の表示を押したほうのボタンに出す。
    final skipsNotification = useState(false);

    void next() {
      if (name.isEmpty) return;
      FocusScope.of(context).unfocus();
      showsNotificationStep.value = true;
    }

    // 保存できたらルーターがホームに切り替えるので、ここでは失敗だけ扱う。
    Future<void> start({required bool requestsNotification}) async {
      if (saving) return;
      skipsNotification.value = !requestsNotification;
      final succeeded = await ref
          .read(onboardingPageControllerProvider.notifier)
          .start(
            name,
            avatarColor: avatarColor.value,
            requestsNotification: requestsNotification,
          );
      if (!context.mounted || succeeded) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.onboardingSaveNameFailed)));
    }

    void back() => showsNotificationStep.value = false;

    return PopScope(
      // 通知のページでは、戻ると名前のページに戻す。
      canPop: !showsNotificationStep.value,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !saving) back();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: showsNotificationStep.value
              ? BackButton(onPressed: saving ? null : back)
              : null,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: showsNotificationStep.value
                      ? const NotificationStep()
                      : ListView(
                          children: [
                            Text(
                              l10n.onboardingNameTitle,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.onboardingNameDescription,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: colors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 32),
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
                              autofocus: true,
                              textInputAction: TextInputAction.next,
                              onSubmitted: (_) => next(),
                            ),
                            const SizedBox(height: 24),
                            FieldLabel(l10n.commonAvatarColor),
                            const SizedBox(height: 8),
                            AvatarColorPicker(
                              selected: avatarColor.value,
                              onSelected: (color) => avatarColor.value = color,
                            ),
                          ],
                        ),
                ),
                if (showsNotificationStep.value) ...[
                  // 許可を聞いて保存している間は二度押しできないようにして、待っていることを見せる。
                  FilledButton(
                    onPressed: saving
                        ? null
                        : () => start(requestsNotification: true),
                    child: saving && !skipsNotification.value
                        ? SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.textSecondary,
                            ),
                          )
                        : Text(l10n.onboardingAllowNotifications),
                  ),
                  const SizedBox(height: 8),
                  // 許可を聞かずに名前だけ保存して始める。通知はあとから端末の設定でオンにできる。
                  TextButton(
                    onPressed: saving
                        ? null
                        : () => start(requestsNotification: false),
                    child: saving && skipsNotification.value
                        ? SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colors.textSecondary,
                            ),
                          )
                        : Text(l10n.onboardingLater),
                  ),
                ] else
                  FilledButton(
                    onPressed: name.isEmpty ? null : next,
                    child: Text(l10n.onboardingNext),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
