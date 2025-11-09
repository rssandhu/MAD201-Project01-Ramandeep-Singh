/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Stores user settings using SharedPreferences.
 */

import 'package:shared_preferences/shared_preferences.dart';

/// Handles reading and saving user theme/currency preference.
class PreferencesHelper {
  SharedPreferences? _prefs;

  /// Initializes preferences storage.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Gets saved theme preference.
  bool getTheme() {
    return _prefs?.getBool('isDarkTheme') ?? false;
  }

  /// Saves theme preference.
  void setTheme(bool isDark) {
    _prefs?.setBool('isDarkTheme', isDark);
  }

  /// Gets user currency or defaults to USD.
  String getCurrency() {
    return _prefs?.getString('currency') ?? 'USD';
  }

  /// Saves user currency preference.
  void setCurrency(String currency) {
    _prefs?.setString('currency', currency);
  }
}
