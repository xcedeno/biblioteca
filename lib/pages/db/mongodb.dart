import 'package:mongo_dart/mongo_dart.dart';

class MongoDatabase {
  static Db? db;
  static DbCollection? userCollection;
  static DbCollection? categoryCollection;
  static DbCollection? documentCollection;

  static Future<void> connect() async {
    db = await Db.create("mongodb://localhost:27017/masoneriaDB");
    await db!.open();

    userCollection = db!.collection("users");
    categoryCollection = db!.collection("categories");
    documentCollection = db!.collection("documents");
  }

  static bool isConnected() {
    return db != null && userCollection != null && categoryCollection != null && documentCollection != null;
  }
  // Método para desconectar de la base de datos
  static Future<void> disconnect() async {
    await db?.close(); // Cierra la conexión si está abierta
    db = null; // Resetea el objeto de conexión
    userCollection = null; // Resetea la colección
  }
}

