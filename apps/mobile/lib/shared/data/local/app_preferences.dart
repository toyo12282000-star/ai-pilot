import 'package:shared_preferences/shared_preferences.dart';

/// アプリ内の軽量ローカル設定。
class AppPreferences {
  AppPreferences(this._prefs);

  static const homeWelcomeDismissedKey = 'home_welcome_dismissed_v1';

  final SharedPreferences _prefs;

  bool get isHomeWelcomeDismissed =>
      _prefs.getBool(homeWelcomeDismissedKey) ?? false;

  Future<void> setHomeWelcomeDismissed(bool value) {
    return _prefs.setBool(homeWelcomeDismissedKey, value);
  }
}
