import 'package:flutter/material.dart';
import 'db/mongodb.dart';

class HomePage extends StatelessWidget {
  final dynamic user;
  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categorías')),
      body: FutureBuilder(
        future: MongoDatabase.categoryCollection!.find({"grado_minimo": {"\$lte": user['grado']}}).toList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            var categories = snapshot.data as List;
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                var category = categories[index];
                return Card(
                  child: ListTile(
                    title: Text(category['nombre']),
                    onTap: () {
                      // Redirigir a la lista de documentos de esa categoría
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No hay categorías disponibles.'));
          }
        },
      ),
    );
  }
}
