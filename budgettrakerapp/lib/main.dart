/*
 * Course: MAD101 - Lab 3
 * Name: [Your Full Name]
 * Student ID: [Your Student ID]
 * Description: Entry point for Smart Budget Tracker Lite.
 * Handles splash screen timing, theme, currency preference, and app navigation.
 */

import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'helpers/preferences_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesHelper();
  await prefs.init();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  final PreferencesHelper prefs;

  MyApp({required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;
  bool _isDark = false;
  String _currency = 'USD';

  @override
  void initState() {
    super.initState();
    _isDark = widget.prefs.getTheme();
    _currency = widget.prefs.getCurrency();

    // Show splash for 3 seconds then show HomeScreen
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
      widget.prefs.setTheme(_isDark);
    });
  }

  void _changeCurrency(String currency) {
    setState(() {
      _currency = currency;
      widget.prefs.setCurrency(currency);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Budget Tracker Lite',
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: _showSplash
          ? SplashScreen()
          : HomeScreen(
              prefs: widget.prefs,
              onThemeChanged: _toggleTheme,
              currency: _currency,
              onCurrencyChanged: _changeCurrency,
            ),
    );
  }
}
