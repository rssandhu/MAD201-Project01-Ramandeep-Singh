import 'package:budgettrakerapp/screens/report_screen.dart';
import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';
import 'add_transaction_screen.dart';
import 'transactions_list_screen.dart';
import 'report_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkTheme;
  final VoidCallback onThemeToggle; // VoidCallback (void Function())
  final String currency;
  final ValueChanged<String> onCurrencyChanged;

  /// Creates HomeScreen.
  ///
  /// Requires the current [isDarkTheme] status, callback [onThemeToggle]
  /// to toggle theme, current [currency] code, and [onCurrencyChanged]
  /// callback when user selects a different currency.
  const HomeScreen({
    Key? key,
    required this.isDarkTheme,
    required this.onThemeToggle,
    required this.currency,
    required this.onCurrencyChanged,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double totalIncome = 0.0;
  double totalExpense = 0.0;

  @override
  void initState() {
    super.initState();
    _updateTotals();
  }

  Future<void> _updateTotals() async {
    final List<TransactionModel> transactions = await DBHelper()
        .getAllTransactions();

    double income = 0.0;
    double expense = 0.0;

    for (final tx in transactions) {
      if (tx.type.toLowerCase() == 'income') {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    setState(() {
      totalIncome = income;
      totalExpense = expense;
    });
  }

  void _navigateToAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddTransactionScreen()),
    );
    _updateTotals(); // Refresh totals after possibly adding transactions
  }

  void _navigateToTransactionsList() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TransactionsListScreen()),
    );
    _updateTotals(); // Refresh totals after possible deletes/edits
  }

  void _navigateToReports() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReportsSummaryScreen()),
    );
  }

  void _navigateToSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          isDarkTheme: widget.isDarkTheme,
          // Wrap VoidCallback to ignore the bool parameter expected by SettingsScreen
          onThemeChanged: (_) => widget.onThemeToggle(),
          currency: widget.currency,
          onCurrencyChanged: widget.onCurrencyChanged,
        ),
      ),
    );
    _updateTotals(); // Possible reload needed if currency changed
  }

  @override
  Widget build(BuildContext context) {
    final balance = totalIncome - totalExpense;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Budget Tracker Lite'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
            tooltip: widget.isDarkTheme
                ? 'Switch to Light Theme'
                : 'Switch to Dark Theme',
            onPressed: widget.onThemeToggle,
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.currency_exchange),
            tooltip: 'Change Currency',
            onSelected: widget.onCurrencyChanged,
            itemBuilder: (_) => ['USD', 'CAD', 'EUR']
                .map(
                  (currency) =>
                      PopupMenuItem(value: currency, child: Text(currency)),
                )
                .toList(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: _navigateToSettings,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Total Income'),
                trailing: Text(
                  '${widget.currency} ${totalIncome.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Total Expenses'),
                trailing: Text(
                  '${widget.currency} ${totalExpense.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Balance'),
                trailing: Text(
                  '${widget.currency} ${balance.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: balance >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _navigateToAddTransaction,
              child: const Text('Add Transaction'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _navigateToTransactionsList,
              child: const Text('View Transactions'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _navigateToReports,
              child: const Text('Reports & Summary'),
            ),
          ],
        ),
      ),
    );
  }
}
