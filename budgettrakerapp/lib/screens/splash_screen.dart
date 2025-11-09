import 'package:budgettrakerapp/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  bool _isDark = false;
  String _currency = 'USD';

  void _toggleTheme() {
    setState(() {
      _isDark = !_isDark;
    });
  }

  void _changeCurrency(String newCurrency) {
    setState(() {
      _currency = newCurrency;
    });
  }

  void initState() {
    super.initState();
    // Navigate after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              isDarkTheme: _isDark, // your current theme bool
              onThemeToggle: _toggleTheme, // your toggle theme function
              currency: _currency, // your selected currency string
              onCurrencyChanged: _changeCurrency,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Smart Budget Tracker Lite',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
