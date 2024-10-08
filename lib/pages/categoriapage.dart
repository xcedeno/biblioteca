import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'db/mongodb.dart';

class CategoriaPage extends StatefulWidget {
  const CategoriaPage({super.key});

  @override
  CategoriaPageState createState() => CategoriaPageState();
}

class CategoriaPageState extends State<CategoriaPage> {
  List categories = [];

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  Future<void> _getCategories() async {
    try {
      if (MongoDatabase.isConnected()) {
        var data = await MongoDatabase.categoryCollection!.find().toList();
        setState(() {
          categories = data;
        });
      } else {
        // Manejar conexión no establecida
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo conectar a la base de datos')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Manejar errores de consulta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al obtener categorías: $e')),
      );
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await MongoDatabase.categoryCollection!.remove(mongo.where.id(mongo.ObjectId.parse(id)));
      _getCategories(); // Refrescar lista después de eliminar
    } catch (e) {
      // Manejar errores de eliminación
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar categoría: $e')),
      );
    }
  }

  void _showCategoryDialog({Map? category}) {
    final nameController = TextEditingController(text: category != null ? category['nombre'] : '');
    final gradoMinimoController = TextEditingController(text: category != null ? category['grado_minimo'] : '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(category == null ? 'Agregar Categoría' : 'Editar Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre de la Categoría')),
              TextField(controller: gradoMinimoController, decoration: const InputDecoration(labelText: 'Grado Mínimo')),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                try {
                  if (MongoDatabase.isConnected()) {
                    if (category == null) {
                      // Agregar nueva categoría
                      await MongoDatabase.categoryCollection!.insert({
                        "nombre": nameController.text,
                        "grado_minimo": gradoMinimoController.text
                      });
                    } else {
                      // Actualizar categoría existente
                      await MongoDatabase.categoryCollection!.update(
                        mongo.where.id(mongo.ObjectId.parse(category['_id'].toString())),
                        {
                          "nombre": nameController.text,
                          "grado_minimo": gradoMinimoController.text
                        },
                      );
                    }

                    if (mounted) {
                      Navigator.pop(context);
                    }
                    _getCategories(); // Refrescar lista
                  } else {
                    // Manejar conexión no establecida
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('No se pudo conectar a la base de datos')),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  // Manejar errores de inserción/actualización
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al guardar categoría: $e')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Categorías')),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          var category = categories[index];
          return ListTile(
            title: Text(category['nombre']),
            subtitle: Text('Grado Mínimo: ${category['grado_minimo']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showCategoryDialog(category: category)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteCategory(category['_id'].toString())),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
