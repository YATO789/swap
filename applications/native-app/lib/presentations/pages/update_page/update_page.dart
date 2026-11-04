import 'package:flutter/material.dart';

import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/store_pages.dart';

/// アップデートしないと使えないバージョンのときに出す画面。
/// ルーターがほかの画面に行かせないので、ストアでアップデートするしかない。
class UpdatePage extends StatelessWidget {
  const UpdatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    Future<void> openStore() async {
      if (!await openStorePage() && context.mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.commonOpenLinkFailed)));
      }
    }

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
                      height: 48,
                      semanticLabel: 'Swap!',
                    ),
                    const SizedBox(height: 32),
                    Text(
                      l10n.updateRequiredTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.4,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.updateRequiredMessage,
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
              FilledButton(onPressed: openStore, child: Text(l10n.updateNow)),
            ],
          ),
        ),
      ),
    );
  }
}
