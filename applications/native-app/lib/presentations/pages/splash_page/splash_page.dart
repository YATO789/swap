import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../providers/profile_notifier.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';

/// プロフィールを読んでいる間に出す画面。読めたらルーターが次の画面に切り替える。
class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final failed = ref.watch(profileProvider).hasError;

    return Scaffold(
      body: Center(
        child: failed
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.splashLoadFailed,
                    style: TextStyle(color: colors.textSecondary),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => ref.invalidate(profileProvider),
                    child: Text(context.l10n.commonRetry),
                  ),
                ],
              )
            : CircularProgressIndicator(color: colors.textSecondary),
      ),
    );
  }
}
