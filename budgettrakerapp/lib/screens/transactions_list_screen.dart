/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Lists all transactions with options to delete entries.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

/// Displays list of transactions with delete option and color-coded amounts.
class TransactionsListScreen extends StatefulWidget {
  @override
  _TransactionsListScreenState createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  List<TransactionModel> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  /// Loads all transactions from the database.
  Future<void> _loadTransactions() async {
    final txs = await DBHelper().getAllTransactions();
    setState(() {
      _transactions = txs;
    });
  }

  /// Deletes a transaction by its [id].
  Future<void> _deleteTransaction(int id) async {
    await DBHelper().delete(id);
    _loadTransactions(); // Refresh after delete
  }

  @override
  Widget build(BuildContext context) {
    if (_transactions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Transactions')),
        body: Center(child: Text('No transactions')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (_, index) {
          final tx = _transactions[index];
          return ListTile(
            title: Text(tx.title),
            subtitle: Text(
              '${tx.category} - ${tx.date.toLocal().toString().split(" ")[0]}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Display amount with color for income/expense
                Text(
                  (tx.type == 'Income' ? '+' : '-') +
                      '${tx.amount.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: tx.type == 'Income' ? Colors.green : Colors.red,
                  ),
                ),
                // Delete button
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteTransaction(tx.id!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
