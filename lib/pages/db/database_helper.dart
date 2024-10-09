// lib/db/database_helper.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '/model/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }
  

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'users.db'); // Nombre de la base de datos
     print('Path de la base de datos: $path'); // Imprimir el path
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            password TEXT,
            grade TEXT
          )
        ''');
         print('Tabla "users" creada'); // Confirmar que se crea la tabla
      },
    );
  }

Future<void> insertUser(User user) async {
  final db = await database;
  
  try {
    await db.insert(
      'users', 
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
    
    print("Usuario insertado correctamente");
  } catch (e) {
    print("Error al insertar usuario: $e");
    throw Exception('No se pudo insertar el usuario');
    
  }
  
}

  Future<List<User>> getUsers(String? searchQuery, String? grade) async {
  final db = await database;
  
  List<Map<String, dynamic>> maps;
  if (searchQuery != null && searchQuery.isNotEmpty) {
    maps = await db.query(
      'users',
      where: 'name LIKE ?',
      whereArgs: ['%$searchQuery%'],
    );
  } else if (grade != null && grade.isNotEmpty) {
    maps = await db.query(
      'users',
      where: 'grade = ?',
      whereArgs: [grade],
    );
  } else {
    maps = await db.query('users'); // Ensure it's 'users' not 'usuarios'
  }

  return List.generate(maps.length, (i) {
    return User(
      id: maps[i]['id'],
      name: maps[i]['name'],
      password: maps[i]['password'],
      grade: maps[i]['grade'],
    );
  });
}



  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }
  Future<int> getUserCount() async {
  final db = await database;
  final List<Map<String, dynamic>> maps = await db.query('users');
  return maps.length;
}

  
}
