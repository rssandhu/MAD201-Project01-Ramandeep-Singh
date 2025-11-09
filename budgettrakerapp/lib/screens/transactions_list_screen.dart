/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Shows list of all transactions with edit/delete options.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

/// List view for all transactions
class TransactionsListScreen extends StatefulWidget {
  @override
  State<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends State<TransactionsListScreen> {
  final db = DBHelper();
  List<TransactionModel> _txs = [];

  /// Loads transactions from DB
  void _load() async {
    _txs = await db.getAll();
    setState(() {});
  }

  /// Deletes transaction by id
  void _delete(int id) async {
    await db.delete(id);
    _load();
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Transactions')),
      body: ListView.builder(
        itemCount: _txs.length,
        itemBuilder: (context, idx) {
          final tx = _txs[idx];
          return Card(
            child: ListTile(
              leading: Icon(
                tx.type == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
                color: tx.type == 'Income' ? Colors.green : Colors.red,
              ),
              title: Text(tx.title),
              subtitle: Text('${tx.category} • ${tx.date.split('T')[0]}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      /* Optional: Edit screen */
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _delete(tx.id!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
