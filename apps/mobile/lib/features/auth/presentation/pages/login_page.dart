import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/design_system/colors.dart';
import 'package:ai_pilot/design_system/radius.dart';
import 'package:ai_pilot/design_system/spacing.dart';
import 'package:ai_pilot/design_system/typography.dart';
import 'package:ai_pilot/features/auth/presentation/providers/auth_providers.dart';
import 'package:ai_pilot/shared/providers/guest_mode_provider.dart';

/// ログイン画面。
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isLoading = false;

  Future<void> _runAuthAction(Future<void> Function() action) async {
    if (_isLoading) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await action();
    } catch (error) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('認証に失敗しました。もう一度お試しください')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _continueAsGuest() {
    enableGuestMode(ref);
  }

  Future<void> _openEmailAuth() async {
    await context.push('/login/email');
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.read(authRepositoryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.page,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _LogoSection(),
                  const SizedBox(height: AppSpacing.s48),
                  _AuthButton(
                    label: 'Googleで続ける',
                    icon: Icons.g_mobiledata,
                    onPressed: _isLoading
                        ? null
                        : () => _runAuthAction(repository.signInWithGoogle),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _AuthButton(
                    label: 'Appleで続ける',
                    icon: Icons.apple,
                    onPressed: _isLoading
                        ? null
                        : () => _runAuthAction(repository.signInWithApple),
                  ),
                  const SizedBox(height: AppSpacing.s12),
                  _AuthButton(
                    label: 'メールで続ける',
                    icon: Icons.mail_outline,
                    onPressed: _isLoading ? null : _openEmailAuth,
                  ),
                  const SizedBox(height: AppSpacing.s24),
                  TextButton(
                    onPressed: _isLoading ? null : _continueAsGuest,
                    child: const Text('ゲストで続ける'),
                  ),
                  if (_isLoading) ...[
                    const SizedBox(height: AppSpacing.s24),
                    const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withValues(alpha: 0.15),
                AppColors.secondary.withValues(alpha: 0.2),
              ],
            ),
            border: Border.all(color: AppColors.outline),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Text(
          'AI Pilot',
          style: AppTypography.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          'AI活用手順を、もっとシンプルに',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _AuthButton extends StatelessWidget {
  const _AuthButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.outline),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.medium),
          textStyle: AppTypography.labelLarge,
        ),
      ),
    );
  }
}
