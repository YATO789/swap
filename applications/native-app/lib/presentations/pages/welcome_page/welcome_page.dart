import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/l10n.dart';
import '../../../theme/app_text_styles.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/legal_pages.dart';
import 'controller/welcome_page_controller.dart';

/// ログインしていないときに最初に出す画面。Apple アカウントでサインインする。
class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;

    /// サインインの処理中か。ボタンを押せなくして、処理中の表示を出す。
    final signingIn = ref.watch(welcomePageControllerProvider).isLoading;

    void showSnackBar(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    Future<void> openPage(Uri url) async {
      if (!await openLegalPage(url) && context.mounted) {
        showSnackBar(l10n.commonOpenLinkFailed);
      }
    }

    // 同意文の中の「利用規約」「プライバシーポリシー」を押せるようにする。
    final termsRecognizer = useMemoized(TapGestureRecognizer.new);
    final privacyRecognizer = useMemoized(TapGestureRecognizer.new);
    termsRecognizer.onTap = () => openPage(termsOfServiceUrl);
    privacyRecognizer.onTap = () => openPage(privacyPolicyUrl);
    useEffect(
      () => () {
        termsRecognizer.dispose();
        privacyRecognizer.dispose();
      },
      const [],
    );

    final controller = ref.read(welcomePageControllerProvider.notifier);

    //Apple・匿名ログインがあるため引数でログインの関数を取る
    Future<void> signIn(Future<SignInResult> Function() run) async {
      final result = await run();
      if (!context.mounted || result != SignInResult.failed) return;
      showSnackBar(l10n.welcomeSignInFailed);
    }

    final linkStyle = context.appTextStyles.link;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/swap_title.png',
                      height: 64,
                      semanticLabel: 'Swap!',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      l10n.welcomeTagline,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // 処理中は二度押しできないようにして、待っていることを見せる。
              FilledButton.icon(
                onPressed: signingIn
                    ? null
                    : () => signIn(controller.signInWithApple),
                icon: signingIn
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textSecondary,
                        ),
                      )
                    : const Icon(Icons.apple, size: 24),
                label: Text(
                  signingIn
                      ? l10n.welcomeSigningIn
                      : l10n.welcomeSignInWithApple,
                ),
              ),
              // Apple ID を入れていないシミュレータでも試せるように、開発中だけ出す。
              if (kDebugMode)
                TextButton(
                  onPressed: signingIn
                      ? null
                      : () => signIn(controller.signInAnonymously),
                  child: Text(l10n.welcomeTryAnonymously),
                ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: l10n.welcomeAgreementPrefix),
                    TextSpan(
                      text: l10n.commonTermsOfService,
                      style: linkStyle,
                      recognizer: termsRecognizer,
                    ),
                    TextSpan(text: l10n.welcomeAgreementConjunction),
                    TextSpan(
                      text: l10n.commonPrivacyPolicy,
                      style: linkStyle,
                      recognizer: privacyRecognizer,
                    ),
                    TextSpan(text: l10n.welcomeAgreementSuffix),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.6,
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
