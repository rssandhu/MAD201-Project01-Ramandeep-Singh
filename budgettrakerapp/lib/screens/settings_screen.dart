/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Settings screen allowing to toggle theme and select currency, with currency API rate.
 */

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../helpers/preferences_helper.dart';

/// Settings screen for theme and currency preferences,
/// also fetches and displays current currency conversion rate.
class SettingsScreen extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;
  final String currency;
  final ValueChanged<String> onCurrencyChanged;

  SettingsScreen({
    required this.isDarkTheme,
    required this.onThemeChanged,
    required this.currency,
    required this.onCurrencyChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double? conversionRate;
  bool loadingRate = false;

  /// Fetches conversion rate from USD to selected currency.
  Future<void> fetchConversionRate() async {
    setState(() => loadingRate = true);
    try {
      final response = await http.get(
        Uri.parse('https://api.exchangerate-api.com/v4/latest/USD'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final rates = data['rates'] as Map<String, dynamic>;
        double rate = rates[widget.currency] is double
            ? rates[widget.currency]
            : (rates[widget.currency] as num).toDouble();
        setState(() {
          conversionRate = rate;
          loadingRate = false;
        });
      } else {
        setState(() => loadingRate = false);
      }
    } catch (e) {
      setState(() => loadingRate = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchConversionRate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text('Light'),
                Switch(
                  value: widget.isDarkTheme,
                  onChanged: widget.onThemeChanged,
                ),
                Text('Dark'),
              ],
            ),
            SizedBox(height: 20),
            Text('Currency', style: TextStyle(fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: widget.currency,
              items: [
                'USD',
                'CAD',
                'EUR',
              ].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) {
                if (val != null) {
                  widget.onCurrencyChanged(val);
                  fetchConversionRate();
                }
              },
            ),
            SizedBox(height: 20),
            loadingRate
                ? Row(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(width: 10),
                      Text('Fetching conversion rate...'),
                    ],
                  )
                : conversionRate != null
                ? Text('1 USD = $conversionRate ${widget.currency}')
                : Text('Failed to load conversion rate'),
          ],
        ),
      ),
    );
  }
}
