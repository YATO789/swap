import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../domains/diary/diary.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../theme/app_theme.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'controller/my_page_controller.dart';

/// ホームの AppBar 右のアイコンから開く、プロフィールとその他の設定のページ。
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myName = ref.watch(profileRepositoryProvider).value?.displayName;

    // TODO: 通知の仕組みができたら保存して、実際に通知する。今は見た目だけ。
    final postNotification = useState(true);
    final diaryReminder = useState(true);

    // pubspec.yaml の version（ビルド番号を除く）。読み込むまでは空にしておく。
    final packageInfo = useFuture(useMemoized(PackageInfo.fromPlatform));
    final appVersion = packageInfo.data?.version ?? '';

    /// ログアウトかアカウント削除の処理中か。二度押しできないようにする。
    final busy = ref.watch(myPageControllerProvider).isLoading;

    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    void showNotReady() => showMessage('準備中です');

    Future<void> signOut() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ログアウトしますか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('ログアウト'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;

      // 成功したらルーターがウェルカム画面に切り替えるので、ここでは失敗だけ扱う。
      if (!await ref.read(myPageControllerProvider.notifier).signOut()) {
        showMessage('ログアウトできませんでした。もう一度お試しください');
      }
    }

    Future<void> deleteAccount() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('アカウントを削除しますか？'),
          content: const Text(
            'プロフィール・記録・日記がすべて削除され、元に戻せません。'
            '日記帳からも抜け、ほかに誰もいない日記帳は削除されます。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('削除'),
            ),
          ],
        ),
      );
      if (confirmed != true || !context.mounted) return;

      // 成功したらルーターがウェルカム画面に切り替えるので、ここでは失敗だけ扱う。
      if (!await ref.read(myPageControllerProvider.notifier).deleteAccount()) {
        showMessage('アカウントを削除できませんでした。もう一度お試しください');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          _ProfileTile(
            name: myName ?? '',
            onTap: () => context.push(AppRoutes.profileEdit),
          ),
          const _SectionHeader('通知'),
          _SwitchTile(
            title: '記録の通知',
            subtitle: '日記帳の誰かが記録したときに通知します',
            value: postNotification.value,
            onChanged: (value) => postNotification.value = value,
          ),
          _SwitchTile(
            title: '日記のリマインド',
            subtitle: '夜に今日の日記を書くようお知らせします',
            value: diaryReminder.value,
            onChanged: (value) => diaryReminder.value = value,
          ),
          const _SectionHeader('日記'),
          const _InfoTile(
            title: '日付の切り替わり',
            subtitle: 'これより前に書いた記録や日記は前日の分になります',
            value: '朝$diaryDayStartHour:00',
          ),
          const _SectionHeader('その他'),
          _LinkTile(title: 'ヘルプ', onTap: showNotReady),
          _LinkTile(title: '利用規約', onTap: showNotReady),
          _LinkTile(title: 'プライバシーポリシー', onTap: showNotReady),
          _InfoTile(title: 'バージョン', value: appVersion),
          const _SectionHeader('アカウント'),
          ListTile(
            contentPadding: _tilePadding,
            title: const Text('ログアウト', style: _titleStyle),
            enabled: !busy,
            onTap: signOut,
          ),
          ListTile(
            contentPadding: _tilePadding,
            title: Text(
              'アカウントを削除',
              style: _titleStyle.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            enabled: !busy,
            onTap: deleteAccount,
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      button: true,
      label: '$name、プロフィールを編集',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              UserAvatar(name: name, filled: true, size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'プロフィールを編集',
                      style: TextStyle(
                        fontSize: 13,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Semantics(
      header: true,
      child: Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 4),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}

const _titleStyle = TextStyle(fontSize: 16);
const _tilePadding = EdgeInsets.symmetric(horizontal: 24);

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: _tilePadding,
      title: Text(title, style: _titleStyle),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: context.appColors.textSecondary),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: _tilePadding,
      title: Text(title, style: _titleStyle),
      trailing: Icon(
        Icons.chevron_right,
        color: context.appColors.textSecondary,
      ),
      onTap: onTap,
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.title, required this.value, this.subtitle});

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return ListTile(
      contentPadding: _tilePadding,
      title: Text(title, style: _titleStyle),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: colors.textSecondary),
            ),
      trailing: Text(
        value,
        style: TextStyle(fontSize: 15, color: colors.textSecondary),
      ),
    );
  }
}
