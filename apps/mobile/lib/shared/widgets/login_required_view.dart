import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/shared/widgets/rich_empty_view.dart';

/// ログインが必要な機能へのアクセス時に表示する共通 UI。
class LoginRequiredView extends StatelessWidget {
  const LoginRequiredView({
    super.key,
    this.onLogin,
  });

  final VoidCallback? onLogin;

  void _navigateToLogin(BuildContext context) {
    if (onLogin != null) {
      onLogin!();
      return;
    }
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return RichEmptyView(
      icon: Icons.login_rounded,
      title: 'ログインが必要です',
      subtitle: 'お気に入りや実行履歴を保存するにはログインしてください',
      actionLabel: 'ログインする',
      onAction: () => _navigateToLogin(context),
    );
  }
}
