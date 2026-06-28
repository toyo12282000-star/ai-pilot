import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:ai_pilot/shared/providers/guest_mode_provider.dart';

/// ゲストモードを解除してログイン画面へ遷移する。
void navigateToLogin(WidgetRef ref, BuildContext context) {
  disableGuestMode(ref);
  context.go('/login');
}
