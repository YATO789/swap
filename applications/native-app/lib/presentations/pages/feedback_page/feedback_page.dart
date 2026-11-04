import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/discard_guard.dart';
import 'controller/feedback_page_controller.dart';

/// フィードバックの長さの上限。
const maxFeedbackLength = 1000;

/// 設定から開く、アプリへの意見や不具合を書いて送るページ。
class FeedbackPage extends HookConsumerWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final l10n = context.l10n;
    final bodyController = useTextEditingController();
    // 文字を打つたびに送信ボタンを更新する。
    useListenable(bodyController);
    final body = bodyController.text.trim();

    /// 送信中か。ボタンを押せなくして、処理中の表示を出す。
    final sending = ref.watch(feedbackPageControllerProvider).isLoading;

    Future<void> send() async {
      if (body.isEmpty || sending) return;
      FocusScope.of(context).unfocus();
      final messenger = ScaffoldMessenger.of(context);
      final succeeded = await ref
          .read(feedbackPageControllerProvider.notifier)
          .send(body);
      messenger.hideCurrentSnackBar();
      if (!succeeded) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.feedbackSendFailed)),
        );
        return;
      }
      if (context.mounted) context.pop();
      messenger.showSnackBar(SnackBar(content: Text(l10n.feedbackSent)));
    }

    return DiscardGuard(
      // 送信中に戻ると確認が出てしまうので、送り終わるまでは書きかけとみなさない。
      dirty: body.isNotEmpty && !sending,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.feedbackTitle),
          actions: [
            // 送信中は二度押しできないようにして、待っていることを見せる。
            if (sending)
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
                onPressed: body.isNotEmpty ? send : null,
                child: Text(l10n.feedbackSend),
              ),
            const SizedBox(width: 8),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          children: [
            Text(
              l10n.feedbackDescription,
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              autofocus: true,
              minLines: 8,
              maxLines: null,
              maxLength: maxFeedbackLength,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(hintText: l10n.feedbackHint),
            ),
          ],
        ),
      ),
    );
  }
}
