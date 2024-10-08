import 'package:flutter/material.dart';
import 'db/database_helper.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  UsuarioPageState createState() => UsuarioPageState();
}

class UsuarioPageState extends State<UsuarioPage> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    _getUsers(); // Obtener usuarios al inicializar
  }

  void _getUsers() async {
    //var data = await DatabaseHelper().getUsers();
    setState(() {
      //users = data.cast<Map<String, dynamic>>();
    });
  }

  void _deleteUser(int id) async {
    await DatabaseHelper().deleteUser(id);
    _getUsers(); // Refrescar lista después de eliminar
  }

  void _showUserDialog({Map<String, dynamic>? user}) {
    final nameController = TextEditingController(text: user != null ? user['nombre'] : '');
    final passwordController = TextEditingController(text: user != null ? user['contraseña'] : '');
    final gradoController = TextEditingController(text: user != null ? user['grado'] : '');

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(user == null ? 'Agregar Usuario' : 'Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Contraseña')),
              TextField(controller: gradoController, decoration: const InputDecoration(labelText: 'Grado (aprendiz, compañero, maestro)')),
            ],
          ),
        
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Usuarios')),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return ListTile(
            title: Text(user['nombre']),
            subtitle: Text('Grado: ${user['grado']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showUserDialog(user: user)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteUser(user['id'])),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
