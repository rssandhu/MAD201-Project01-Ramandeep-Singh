/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Dashboard showing totals, balance, and main navigation buttons.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import 'add_transaction_screen.dart';
import 'transactions_list_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';
import '../helpers/preferences_helper.dart';

/// Home dashboard screen
class HomeScreen extends StatefulWidget {
  final PreferencesHelper prefs;
  final VoidCallback onThemeChanged;
  final String currency;
  final Function(String) onCurrencyChanged;

  HomeScreen({
    required this.prefs,
    required this.onThemeChanged,
    required this.currency,
    required this.onCurrencyChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// Displays current totals and navigation shortcuts
class _HomeScreenState extends State<HomeScreen> {
  double _income = 0;
  double _expenses = 0;
  double get _balance => _income - _expenses;

  /// Loads latest totals from DB
  void _loadTotals() async {
    final db = DBHelper();
    final txs = await db.getAll();
    setState(() {
      _income = txs
          .where((t) => t.type == 'Income')
          .fold(0.0, (sum, t) => sum + t.amount);
      _expenses = txs
          .where((t) => t.type == 'Expense')
          .fold(0.0, (sum, t) => sum + t.amount);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTotals();
  }

  /// Navigates to another screen and reloads totals after.
  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    ).then((_) => _loadTotals());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Budget Tracker Lite'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _navigateTo(
              SettingsScreen(
                prefs: widget.prefs,
                onThemeChanged: widget.onThemeChanged,
                currency: widget.currency,
                onCurrencyChanged: widget.onCurrencyChanged,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Card(
            child: ListTile(
              title: Text('Total Income'),
              trailing: Text(
                '${widget.currency} $_income',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Total Expenses'),
              trailing: Text(
                '${widget.currency} $_expenses',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Balance'),
              trailing: Text('${widget.currency} $_balance'),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Add Transaction'),
                onPressed: () => _navigateTo(AddTransactionScreen()),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.list),
                label: Text('View Transactions'),
                onPressed: () => _navigateTo(TransactionsListScreen()),
              ),
            ],
          ),
          SizedBox(height: 18),
          ElevatedButton(
            child: Text('View Reports & Summary'),
            onPressed: () => _navigateTo(ReportScreen()),
          ),
        ],
      ),
    );
  }
}
