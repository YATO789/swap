import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../domains/diary/diary.dart';
import '../../../infrastructures/repositories/diary_book_grid_repository.dart';
import '../../../infrastructures/repositories/post_hint_repository.dart';
import '../../../infrastructures/repositories/profile_repository.dart';
import '../../../infrastructures/repositories/theme_mode_repository.dart';
import '../../../l10n/l10n.dart';
import '../../../theme/app_theme.dart';
import '../../components/confirm_sheet.dart';
import '../../components/user_avatar.dart';
import '../router/router.dart';
import 'components/diary_book_layout_picker.dart';
import 'components/theme_mode_picker.dart';
import 'controller/my_page_controller.dart';

/// ホームの AppBar 右のアイコンから開く、プロフィールとその他の設定のページ。
class MyPage extends HookConsumerWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myName = ref.watch(profileRepositoryProvider).value?.displayName;
    final diaryBookGrid = ref.watch(diaryBookGridRepositoryProvider);
    final themeMode = ref.watch(themeModeRepositoryProvider);
    final showPostHint = ref.watch(postHintRepositoryProvider);

    // pubspec.yaml の version（ビルド番号を除く）。読み込むまでは空にしておく。
    final packageInfo = useFuture(useMemoized(PackageInfo.fromPlatform));
    final appVersion = packageInfo.data?.version ?? '';

    /// ログアウトかアカウント削除の処理中か。二度押しできないようにする。
    final busy = ref.watch(myPageControllerProvider).isLoading;
    final l10n = context.l10n;

    void showMessage(String message) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    }

    void showNotReady() => showMessage(l10n.commonComingSoon);

    Future<void> signOut() async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.settingsSignOutConfirmTitle,
        confirmLabel: l10n.settingsSignOut,
      );
      if (!confirmed || !context.mounted) return;

      // 成功したらルーターがウェルカム画面に切り替えるので、ここでは失敗だけ扱う。
      if (!await ref.read(myPageControllerProvider.notifier).signOut()) {
        showMessage(l10n.settingsSignOutFailed);
      }
    }

    Future<void> deleteAccount() async {
      final confirmed = await showConfirmSheet(
        context,
        title: l10n.settingsDeleteAccountConfirmTitle,
        message: l10n.settingsDeleteAccountConfirmMessage,
        irreversible: true,
        confirmLabel: l10n.commonDelete,
        destructive: true,
      );
      if (!confirmed || !context.mounted) return;

      // 成功したらルーターがウェルカム画面に切り替えるので、ここでは失敗だけ扱う。
      if (!await ref.read(myPageControllerProvider.notifier).deleteAccount()) {
        showMessage(l10n.settingsDeleteAccountFailed);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 32),
        children: [
          _ProfileTile(
            name: myName ?? '',
            onTap: () => const ProfileEditRoute().push<void>(context),
          ),
          _SectionHeader(l10n.settingsHomeLayoutSection),
          DiaryBookLayoutPicker(
            grid: diaryBookGrid,
            onChanged: ref.read(diaryBookGridRepositoryProvider.notifier).save,
          ),
          _SectionHeader(l10n.settingsDisplaySection),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.settingsTheme, style: _titleStyle),
                const SizedBox(height: 10),
                ThemeModePicker(
                  selected: themeMode,
                  onChanged: ref
                      .read(themeModeRepositoryProvider.notifier)
                      .save,
                ),
              ],
            ),
          ),
          SwitchListTile(
            contentPadding: _tilePadding,
            title: Text(l10n.settingsPostHint, style: _titleStyle),
            subtitle: Text(
              l10n.settingsPostHintDescription,
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.textSecondary,
              ),
            ),
            value: showPostHint,
            onChanged: ref.read(postHintRepositoryProvider.notifier).save,
          ),
          _SectionHeader(l10n.settingsDiarySection),
          _InfoTile(
            title: l10n.settingsDayStart,
            subtitle: l10n.settingsDayStartDescription,
            value: l10n.settingsDayStartValue(diaryDayStartHour),
          ),
          _SectionHeader(l10n.settingsOtherSection),
          _LinkTile(title: l10n.commonTermsOfService, onTap: showNotReady),
          _LinkTile(title: l10n.commonPrivacyPolicy, onTap: showNotReady),
          _InfoTile(title: l10n.settingsVersion, value: appVersion),
          _SectionHeader(l10n.settingsAccountSection),
          ListTile(
            contentPadding: _tilePadding,
            title: Text(l10n.settingsSignOut, style: _titleStyle),
            enabled: !busy,
            onTap: signOut,
          ),
          ListTile(
            contentPadding: _tilePadding,
            title: Text(
              l10n.settingsDeleteAccount,
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
      label: context.l10n.settingsProfileTileSemantics(name),
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
                      context.l10n.settingsEditProfile,
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
