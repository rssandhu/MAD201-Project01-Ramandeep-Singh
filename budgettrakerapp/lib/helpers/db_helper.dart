/*
 * Course: MAD101 - Lab 3
 * Name: Ramandeep Singh
 * Student ID: A00194321
 * Description:
 * SQLite DB helper with platform-aware databaseFactory initialization,
 * explicit setting of databaseFactoryFfiWeb on Flutter Web,
 * and customizable database path per platform.
 */

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// FFI for desktop & test platforms
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// FFI for web platform
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

/// Transaction data model
class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'],
        title: map['title'],
        amount: map['amount'],
        type: map['type'],
        category: map['category'],
        date: map['date'],
      );
}

/// Singleton DBHelper with platform-aware initialization
class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _db;
  static bool _initialized = false;

  Future<Database> get database async {
    if (_db != null) return _db!;

    if (!_initialized) {
      if (kIsWeb) {
        // Explicitly set the database factory for Flutter web
        databaseFactory = databaseFactoryFfiWeb;
      } else {
        // Initialize ffi for desktop (and tests)
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
      _initialized = true;
    }

    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    // Set platform-specific database path
    final String path = kIsWeb
        ? 'budget.db'
        : join(await getDatabasesPath(), 'budget.db');

    print('DBHelper: Initializing database at $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print('DBHelper: Creating transactions table');
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
        print('DBHelper: Table created');
      },
      onOpen: (db) => print('DBHelper: Database opened'),
    );
  }

  Future<int> insert(TransactionModel tx) async {
    final db = await database;
    return await db.insert('transactions', tx.toMap());
  }

  Future<List<TransactionModel>> getAll() async {
    final db = await database;
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map((m) => TransactionModel.fromMap(m)).toList();
  }

  Future<int> update(TransactionModel tx) async {
    final db = await database;
    return await db.update(
      'transactions',
      tx.toMap(),
      where: 'id = ?',
      whereArgs: [tx.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
