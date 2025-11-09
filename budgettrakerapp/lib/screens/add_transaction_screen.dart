/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Form to add transaction with validations and saving to DB.
 */

import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/transaction_model.dart';

/// Screen presenting a form for adding a new income or expense transaction.
class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  String _type = 'Income';
  String _category = 'General';
  DateTime _date = DateTime.now();

  final List<String> _categories = [
    'General',
    'Food',
    'Transport',
    'Bills',
    'Shopping',
  ];

  /// Validates and saves the form, then inserts transaction into the database.
  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final tx = TransactionModel(
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        type: _type,
        category: _category,
        date: _date,
      );
      await DBHelper().insert(tx); // Insert new transaction
      Navigator.pop(context); // Return to previous screen
    }
  }

  /// Opens date picker to select transaction date.
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Title input field with validation
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Enter title' : null,
              ),

              // Amount input field with numeric validation
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter amount';
                  if (double.tryParse(v) == null) return 'Enter valid number';
                  return null;
                },
              ),

              // Dropdown for selecting transaction type
              DropdownButtonFormField<String>(
                value: _type,
                decoration: InputDecoration(labelText: 'Type'),
                items: ['Income', 'Expense']
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (val) => setState(() => _type = val!),
              ),

              // Dropdown for selecting category
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((e) => DropdownMenuItem(child: Text(e), value: e))
                    .toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),

              // Row to display and pick date
              Row(
                children: [
                  Text('Date: ${_date.toLocal().toString().split(" ")[0]}'),
                  TextButton(onPressed: _pickDate, child: Text('Pick Date')),
                ],
              ),

              SizedBox(height: 20),

              // Save button
              ElevatedButton(onPressed: _save, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
