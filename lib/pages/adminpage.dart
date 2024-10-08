import 'package:flutter/material.dart';
import 'categoriapage.dart';
import 'documentopage.dart';
import 'usuariopage.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Page')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Opciones Administrativas',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: const Text('Usuarios'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsuarioPage()),
              ),
            ),
            ListTile(
              title: const Text('Categorías'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CategoriaPage()),
              ),
            ),
            ListTile(
              title: const Text('Documentos'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DocumentoPage()),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UsuarioPage()),
                );
              },
              child: const Text('Crear Usuarios'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoriaPage()),
                );
              },
              child: const Text('Crear Categorías'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DocumentoPage()),
                );
              },
              child: const Text('Agregar Documentos'),
            ),
            const SizedBox(height: 32), // Separador para los botones de usuarios
            const Divider(), // Línea divisora entre opciones generales y las de usuarios
            const Text(
              'Gestión de Usuarios',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción para agregar usuarios
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuarioPage()),
                );
              },
              child: const Text('Agregar Usuario'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción para editar usuarios
                // Aquí puede ir la lógica para editar usuarios
              },
              child: const Text('Editar Usuario'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Acción para eliminar usuarios
                // Aquí puede ir la lógica para eliminar usuarios
              },
              child: const Text('Eliminar Usuario'),
            ),
          ],
        ),
      ),
    );
  }
}
