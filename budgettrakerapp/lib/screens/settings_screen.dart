/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Settings for theme, currency, and conversion rate (from API).
 */

import 'package:flutter/material.dart';
import '../helpers/preferences_helper.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Settings screen for theme, currency, and API rate
class SettingsScreen extends StatefulWidget {
  final PreferencesHelper prefs;
  final VoidCallback onThemeChanged;
  final String currency;
  final Function(String) onCurrencyChanged;

  SettingsScreen({
    required this.prefs,
    required this.onThemeChanged,
    required this.currency,
    required this.onCurrencyChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double? _rate;

  /// Fetches conversion rate from API
  void _fetchRate() async {
    final response = await http.get(
      Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      setState(() {
        _rate = json['rates']['CAD'] ?? null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Theme'),
              value: widget.prefs.getTheme(),
              onChanged: (v) => widget.onThemeChanged(),
            ),
            ListTile(
              title: Text('Currency'),
              trailing: DropdownButton<String>(
                value: widget.currency,
                items: ['USD', 'CAD']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) widget.onCurrencyChanged(val);
                },
              ),
            ),
            SizedBox(height: 14),
            _rate != null
                ? Text('USD to CAD Rate: $_rate')
                : Text('Loading conversion rate...'),
          ],
        ),
      ),
    );
  }
}
