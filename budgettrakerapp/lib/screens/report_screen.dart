/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Displays summary reports of totals by category and month.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

/// Screen to show categorized and monthly summary totals of transactions.
class ReportsSummaryScreen extends StatefulWidget {
  @override
  _ReportsSummaryScreenState createState() => _ReportsSummaryScreenState();
}

class _ReportsSummaryScreenState extends State<ReportsSummaryScreen> {
  Map<String, double> categoryTotals = {};
  Map<String, double> monthTotals = {};

  @override
  void initState() {
    super.initState();
    loadSummary();
  }

  /// Loads and aggregates totals by category and month.
  Future<void> loadSummary() async {
    List<TransactionModel> txs = await DBHelper().getAllTransactions();

    Map<String, double> catTotals = {};
    Map<String, double> monTotals = {};

    for (var tx in txs) {
      // Aggregate totals by category
      catTotals[tx.category] = (catTotals[tx.category] ?? 0) + tx.amount;

      // Aggregate totals by year-month string "YYYY-MM"
      String month =
          "${tx.date.year}-${tx.date.month.toString().padLeft(2, '0')}";
      monTotals[month] = (monTotals[month] ?? 0) + tx.amount;
    }

    setState(() {
      categoryTotals = catTotals;
      monthTotals = monTotals;
    });
  }

  /// Helper widget to build Card displaying totals.
  Widget buildTotalsCard(String title, Map<String, double> totals) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            ...totals.entries
                .map(
                  (e) => ListTile(
                    dense: true,
                    title: Text(e.key),
                    trailing: Text(e.value.toStringAsFixed(2)),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports & Summary')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTotalsCard('Totals by Category', categoryTotals),
            SizedBox(height: 20),
            buildTotalsCard('Totals by Month', monthTotals),
          ],
        ),
      ),
    );
  }
}
