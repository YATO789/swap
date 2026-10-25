import 'package:flutter/material.dart';

import '../../../../l10n/l10n.dart';
import '../../../../theme/app_theme.dart';

/// オンボーディングの2ページ目。どんな通知が届くかを見本で見せて、許可をお願いする。
class NotificationStep extends StatelessWidget {
  const NotificationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final l10n = context.l10n;

    return ListView(
      children: [
        Text(
          l10n.notificationStepTitle,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.notificationStepDescription,
          style: TextStyle(
            fontSize: 14,
            height: 1.6,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 32),
        _NotificationSample(
          title: l10n.notificationStepSample1Name,
          body: l10n.notificationStepSample1Body,
          time: l10n.notificationStepSample1Time,
        ),
        const SizedBox(height: 12),
        _NotificationSample(
          title: l10n.notificationStepSample2Name,
          body: l10n.notificationStepSample2Body,
          time: l10n.notificationStepSample2Time,
        ),
        const SizedBox(height: 32),
        Text(
          l10n.notificationStepFootnote,
          style: TextStyle(
            fontSize: 13,
            height: 1.6,
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// 端末に届く通知の見本。送られる通知と同じく、題名に書いた人の名前、本文に何を書いたかを出す。
class _NotificationSample extends StatelessWidget {
  const _NotificationSample({
    required this.title,
    required this.body,
    required this.time,
  });

  final String title;
  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Image.asset(
              'assets/icons/app_icon_mint.png',
              width: 38,
              height: 38,
              excludeFromSemantics: true,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(body, style: const TextStyle(fontSize: 14, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
