import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ゲストモード（Supabase 未ログインでアプリを利用）。
final guestModeProvider = StateProvider<bool>((ref) => false);

/// ゲストモードを有効にする。
void enableGuestMode(WidgetRef ref) {
  ref.read(guestModeProvider.notifier).state = true;
}

/// ゲストモードを無効にする。
void disableGuestMode(WidgetRef ref) {
  ref.read(guestModeProvider.notifier).state = false;
}
