/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Shows text-only summary of totals by category and month.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

/// Displays budget summary and reports by category and month
class ReportScreen extends StatefulWidget {
  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final db = DBHelper();
  List<TransactionModel> _txs = [];
  Map<String, double> _byCategory = {};
  Map<String, double> _byMonth = {};

  /// Loads and calculates reports data
  void _load() async {
    _txs = await db.getAll();
    _byCategory = {};
    _byMonth = {};
    for (var tx in _txs) {
      _byCategory[tx.category] = (_byCategory[tx.category] ?? 0) + tx.amount;
      String month = tx.date.substring(0, 7); // YYYY-MM format
      _byMonth[month] = (_byMonth[month] ?? 0) + tx.amount;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reports & Summary')),
      body: ListView(
        children: [
          Card(child: ListTile(title: Text('Totals by Category'))),
          ..._byCategory.entries.map(
            (e) =>
                ListTile(title: Text('${e.key}'), trailing: Text('${e.value}')),
          ),
          SizedBox(height: 16),
          Card(child: ListTile(title: Text('Totals by Month'))),
          ..._byMonth.entries.map(
            (e) =>
                ListTile(title: Text('${e.key}'), trailing: Text('${e.value}')),
          ),
        ],
      ),
    );
  }
}
