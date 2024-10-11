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
          CREATE TABLE usuarios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            password TEXT,
            grade TEXT
          )
        ''');
         print('Tabla "usuarios" creada'); // Confirmar que se crea la tabla
      },
    );
  }

Future<int> insertUser(Users user) async {
  final db = await database;
  int result = await db.insert('users', user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  print('Usuario insertado con ID: $result');
  return result;
}


Future<List<Users>> getUsers(String? searchQuery, String? grade) async {
  final db = await database;
  
  List<Map<String, dynamic>> maps;

  // Verifica si ambos searchQuery y grade no son nulos y no están vacíos
  if (searchQuery != null && searchQuery.isNotEmpty && grade != null && grade.isNotEmpty) {
    maps = await db.query(
      'users',
      where: 'name LIKE ? AND grade = ?',
      whereArgs: ['%$searchQuery%', grade],
    );
  }
  // Verifica si solo searchQuery no es nulo
  else if (searchQuery != null && searchQuery.isNotEmpty) {
    maps = await db.query(
      'users',
      where: 'name LIKE ?',
      whereArgs: ['%$searchQuery%'],
    );
  }
  // Verifica si solo grade no es nulo
  else if (grade != null && grade.isNotEmpty) {
    maps = await db.query(
      'users',
      where: 'grade = ?',
      whereArgs: [grade],
    );
  }
  // Si ninguno es proporcionado, trae todos los usuarios
  else {
    maps = await db.query('users');
  }

  // Convierte los resultados en una lista de objetos User
  return List.generate(maps.length, (i) {
    return Users(
      id: maps[i]['id'],
      name: maps[i]['name'],
      password: maps[i]['password'],
      grade: maps[i]['grade'],
    );
  });
}

// Llamar esta función y mostrar los usuarios en la consola
void mostrarUsuarios() async {
  String searchQuery = 'Juan'; // Por ejemplo, para buscar por nombre
  String grade = 'Aprendiz';   // O para buscar por grado
  List<Users> usuarios = await getUsers(searchQuery, grade); // Pasa los filtros
  for (var user in usuarios) {
    print('ID: ${user.id}, Nombre: ${user.name}, Grado: ${user.grade}');
  }
}



  Future<void> updateUser(Users user) async {
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
