/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Helper class for managing user preferences with SharedPreferences.
 */

import 'package:shared_preferences/shared_preferences.dart';

/// Manages app user preferences like theme and currency using SharedPreferences.
class PreferencesHelper {
  static const String keyTheme = 'theme_is_dark';
  static const String keyCurrency = 'currency';

  static SharedPreferences? _prefs;

  /// Initialize the SharedPreferences instance.
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get current theme mode.
  static bool getTheme() => _prefs?.getBool(keyTheme) ?? false;

  /// Save theme preference.
  static Future<bool> setTheme(bool value) async =>
      _prefs?.setBool(keyTheme, value) ?? Future.value(false);

  /// Get current currency.
  static String getCurrency() => _prefs?.getString(keyCurrency) ?? 'USD';

  /// Save currency preference.
  static Future<bool> setCurrency(String value) async =>
      _prefs?.setString(keyCurrency, value) ?? Future.value(false);
}
