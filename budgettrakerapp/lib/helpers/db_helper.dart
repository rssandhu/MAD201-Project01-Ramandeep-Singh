/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description: Handles all database operations (CRUD) for transactions.
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/transaction_model.dart';

/// Database helper singleton for managing SQLite database operations.
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  static Database? _db;
  static bool _initialized = false;

  DBHelper._internal();

  factory DBHelper() => _instance;

  /// Returns the opened database, initializing with correct factory if necessary.
  Future<Database> get database async {
    if (_db != null) return _db!;

    if (!_initialized) {
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      } else {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      _initialized = true;
    }

    final path = kIsWeb
        ? 'budget_database.db'
        : join(await getDatabasesPath(), 'budget_database.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            amount REAL,
            type TEXT,
            category TEXT,
            date TEXT
          )
        ''');
      },
    );
    return _db!;
  }

  /// Inserts a new [TransactionModel] into the database.
  Future<int> insert(TransactionModel tx) async {
    final db = await database;
    return await db.insert('transactions', tx.toMap());
  }

  /// Retrieves all transactions ordered by date descending.
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final results = await db.query('transactions', orderBy: 'date DESC');
    return results.map((map) => TransactionModel.fromMap(map)).toList();
  }

  /// Deletes a transaction by id.
  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  /// Updates existing transaction.
  Future<int> update(TransactionModel tx) async {
    final db = await database;
    return await db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }
}
