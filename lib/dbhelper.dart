import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cards/user.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'user_data.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE users(
              id INTEGER PRIMARY KEY,
              firstName TEXT,
              lastName TEXT,
              maidenName TEXT,
              age INTEGER,
              gender TEXT,
              email TEXT
            )''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(
      'users',
      {
        'id': user.id,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'maidenName': user.maidenName,
        'age': user.age,
        'gender': user.gender,
        'email': user.email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, 
    );
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(
      maps.length,
      (i) => User(
        id: maps[i]['id'],
        firstName: maps[i]['firstName'],
        lastName: maps[i]['lastName'],
        maidenName: maps[i]['maidenName'],
        age: maps[i]['age'],
        gender: maps[i]['gender'],
        email: maps[i]['email'],
      ),
    );
  }

  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('users'); 
  }
}