import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ai_pilot/shared/data/local/app_preferences.dart';

/// [SharedPreferences] インスタンス。
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) {
  return SharedPreferences.getInstance();
});

/// [AppPreferences] ラッパー。
final appPreferencesProvider = FutureProvider<AppPreferences>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return AppPreferences(prefs);
});
