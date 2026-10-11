import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../theme/app_theme.dart';
import '../home_page/home_page.dart';

/// ログインしていないときに最初に出す画面。Apple アカウントでサインインする。
class WelcomePage extends HookWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    /// サインインの処理中か。ボタンを押せなくして、処理中の表示を出す。
    final signingIn = useState(false);

    void showComingSoon() {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('準備中です')));
    }

    // 同意文の中の「利用規約」「プライバシーポリシー」を押せるようにする。
    final termsRecognizer = useMemoized(TapGestureRecognizer.new);
    final privacyRecognizer = useMemoized(TapGestureRecognizer.new);
    termsRecognizer.onTap = showComingSoon;
    privacyRecognizer.onTap = showComingSoon;
    useEffect(
      () => () {
        termsRecognizer.dispose();
        privacyRecognizer.dispose();
      },
      const [],
    );

    Future<void> signIn() async {
      signingIn.value = true;
      // TODO: Supabase で Apple サインインする。今は少し待ってホームへ進むだけ。
      await Future<void>.delayed(const Duration(milliseconds: 600));
      if (!context.mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
      );
    }

    final linkStyle = TextStyle(
      color: colors.textPrimary,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    );

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
                    Icon(
                      Icons.menu_book_outlined,
                      size: 56,
                      color: colors.textPrimary,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Swap!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '日記帳で「今なにしてる」と\n1日の日記を共有しよう',
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
                onPressed: signingIn.value ? null : signIn,
                icon: signingIn.value
                    ? SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colors.textSecondary,
                        ),
                      )
                    : const Icon(Icons.apple, size: 24),
                label: Text(signingIn.value ? 'サインイン中…' : 'Appleでサインイン'),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '続けると、'),
                    TextSpan(
                      text: '利用規約',
                      style: linkStyle,
                      recognizer: termsRecognizer,
                    ),
                    const TextSpan(text: 'と'),
                    TextSpan(
                      text: 'プライバシーポリシー',
                      style: linkStyle,
                      recognizer: privacyRecognizer,
                    ),
                    const TextSpan(text: 'に\n同意したことになります'),
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
