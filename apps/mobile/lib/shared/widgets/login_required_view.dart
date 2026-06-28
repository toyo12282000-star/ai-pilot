import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ai_pilot/shared/navigation/login_navigation.dart';
import 'package:ai_pilot/shared/widgets/rich_empty_view.dart';

/// ログインが必要な機能へのアクセス時に表示する共通 UI。
class LoginRequiredView extends ConsumerWidget {
  const LoginRequiredView({
    super.key,
    this.onLogin,
  });

  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RichEmptyView(
      icon: Icons.login_rounded,
      title: 'ログインが必要です',
      subtitle: 'お気に入りや実行履歴を保存するにはログインしてください',
      actionLabel: 'ログインする',
      onAction: () {
        if (onLogin != null) {
          onLogin!();
          return;
        }
        navigateToLogin(ref, context);
      },
    );
  }
}
