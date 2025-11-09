/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Form to add transaction with validations and saving to DB.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _type = 'Income';
  String _category = 'General';
  DateTime _date = DateTime.now();
  final _categories = ['General', 'Food', 'Transport', 'Shopping', 'Bills'];
  final db = DBHelper();

  void _save() async {
    String title = _titleController.text.trim();
    String amountText = _amountController.text.trim();

    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter title and amount')));
      return;
    }

    double? amount = double.tryParse(amountText);
    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number for amount')),
      );
      return;
    }

    final tx = TransactionModel(
      title: title,
      amount: amount,
      type: _type,
      category: _category,
      date: _date.toIso8601String(),
    );

    try {
      await db.insert(tx);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save transaction')));
    }
  }

  void _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: _type,
              items: [
                'Income',
                'Expense',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
              onChanged: (val) => setState(() => _type = val!),
            ),
            DropdownButton<String>(
              value: _category,
              items: _categories
                  .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                  .toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            Row(
              children: [
                Text('Date: ${_date.toLocal().toString().split(' ')[0]}'),
                SizedBox(width: 12),
                ElevatedButton(child: Text('Pick Date'), onPressed: _pickDate),
              ],
            ),
            SizedBox(height: 18),
            ElevatedButton(child: Text('Save'), onPressed: _save),
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
