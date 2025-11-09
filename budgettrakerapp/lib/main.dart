/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Main entry point of the Smart Budget Tracker Lite app,
 * manages app-wide theme and currency settings, shows splash screen
 * and then navigates to HomeScreen passing required parameters.
 */

import 'package:flutter/material.dart';
import 'helpers/preferences_helper.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized before async calls
  WidgetsFlutterBinding.ensureInitialized();

  // Load stored user preferences from SharedPreferences
  await PreferencesHelper.init();

  runApp(MyApp());
}

/// Root widget of the app managing global theme and currency state.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = PreferencesHelper.getTheme(); // Current theme mode
  String _currency = PreferencesHelper.getCurrency(); // Selected currency

  /// Toggles between light and dark theme and saves preference.
  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      PreferencesHelper.setTheme(_isDark);
    });
  }

  /// Changes currency and saves preference.
  void _changeCurrency(String newCurrency) {
    setState(() {
      _currency = newCurrency;
      PreferencesHelper.setCurrency(_currency);
    });
  }

  @override
  Widget build(BuildContext context) {
    // MaterialApp setup with dynamic theme
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Budget Tracker Lite',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      // Show splash screen first with a callback to navigate to HomeScreen
      home: SplashScreenWrapper(
        isDarkTheme: _isDark,
        onThemeToggle: _toggleTheme,
        currency: _currency,
        onCurrencyChanged: _changeCurrency,
      ),
    );
  }
}

/// SplashScreen wrapper class that delays then navigates to HomeScreen.
class SplashScreenWrapper extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle;
  final String currency;
  final ValueChanged<String> onCurrencyChanged;

  const SplashScreenWrapper({
    Key? key,
    required this.isDarkTheme,
    required this.onThemeToggle,
    required this.currency,
    required this.onCurrencyChanged,
  }) : super(key: key);

  @override
  _SplashScreenWrapperState createState() => _SplashScreenWrapperState();
}

class _SplashScreenWrapperState extends State<SplashScreenWrapper> {
  @override
  void initState() {
    super.initState();

    // Navigate to HomeScreen after 3 second delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              isDarkTheme: widget.isDarkTheme,
              onThemeToggle: widget.onThemeToggle,
              currency: widget.currency,
              onCurrencyChanged: widget.onCurrencyChanged,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
