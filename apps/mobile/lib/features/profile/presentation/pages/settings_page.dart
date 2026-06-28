import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/features/profile/domain/entities/user_profile.dart';
import 'package:ai_pilot/features/profile/presentation/providers/profile_providers.dart';
import 'package:ai_pilot/features/profile/presentation/widgets/settings_hero_section.dart';
import 'package:ai_pilot/shared/providers/authenticated_user_provider.dart';
import 'package:ai_pilot/shared/providers/guest_mode_provider.dart';
import 'package:ai_pilot/shared/widgets/fade_slide_in.dart';
import 'package:ai_pilot/shared/widgets/settings_section_card.dart';

/// アプリのバージョン表示（MVP）。
const kAppVersionLabel = '0.1.0';

/// 設定画面。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _navigateToLogin(WidgetRef ref, BuildContext context) {
    disableGuestMode(ref);
    context.go('/login');
  }

  Future<void> _signOut(WidgetRef ref, BuildContext context) async {
    disableGuestMode(ref);
    await ref.read(authRepositoryProvider).signOut();
    if (!context.mounted) {
      return;
    }
    context.go('/login');
  }

  ({String title, String subtitle}) _heroContent({
    required bool isAuthenticated,
    required String? email,
    required AsyncValue<UserProfile?> profileAsync,
  }) {
    if (!isAuthenticated) {
      return (
        title: 'ゲスト利用中',
        subtitle: 'ログインすると、お気に入りや実行履歴を保存できます',
      );
    }

    final profile = profileAsync.valueOrNull;
    final displayName = profile?.displayName;
    if (displayName != null && displayName.isNotEmpty) {
      return (
        title: displayName,
        subtitle: email ?? 'AI Pilot アカウント',
      );
    }

    return (
      title: email ?? 'アカウント',
      subtitle: 'AI Pilot アカウント',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final currentUser = ref.watch(currentUserProvider);
    final profileAsync = isAuthenticated
        ? ref.watch(currentUserProfileProvider)
        : const AsyncValue<UserProfile?>.data(null);
    final hero = _heroContent(
      isAuthenticated: isAuthenticated,
      email: currentUser?.email,
      profileAsync: profileAsync,
    );

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.s32),
        children: [
          FadeSlideIn(
            index: 0,
            child: SettingsHeroSection(
              title: hero.title,
              subtitle: hero.subtitle,
              isGuest: !isAuthenticated,
            ),
          ),
          FadeSlideIn(
            index: 1,
            child: SettingsSectionCard(
              title: 'アカウント',
              children: [
                if (isAuthenticated)
                  SettingsActionTile(
                    label: 'ログアウト',
                    destructive: true,
                    icon: Icons.logout_rounded,
                    onPressed: () => _signOut(ref, context),
                  )
                else
                  SettingsActionTile(
                    label: 'ログインする',
                    icon: Icons.login_rounded,
                    onPressed: () => _navigateToLogin(ref, context),
                  ),
              ],
            ),
          ),
          FadeSlideIn(
            index: 2,
            child: SettingsSectionCard(
              title: 'アプリ情報',
              children: [
                SettingsListTile(
                  title: 'バージョン',
                  trailing: kAppVersionLabel,
                ),
                SettingsListTile(
                  title: 'AI Pilotについて',
                  showChevron: true,
                  onTap: () => context.push('/about'),
                ),
                SettingsListTile(
                  title: '利用規約',
                  showChevron: true,
                  onTap: () => context.push('/terms'),
                ),
                SettingsListTile(
                  title: 'プライバシーポリシー',
                  showChevron: true,
                  onTap: () => context.push('/privacy'),
                ),
              ],
            ),
          ),
          const FadeSlideIn(
            index: 3,
            child: SettingsPreviewBadge(),
          ),
        ],
      ),
    );
  }
}
