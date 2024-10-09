// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'categoriapage.dart';
import 'documentopage.dart';
import 'usuariopage.dart';
import 'db/database_helper.dart'; // Importar tu archivo SQLite
import 'package:biblioteca/model/user.dart'; // Importar el modelo de usuario
import 'package:biblioteca/model/grades.dart'; // Archivo que contiene la lista de grados

class AdminPage extends StatefulWidget {
  final User currentUser; // Campo para el usuario actual

  const AdminPage({super.key, required this.currentUser}); // Constructor actualizado

  @override
  AdminPageState createState() => AdminPageState();
}

class AdminPageState extends State<AdminPage> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Cargar usuarios al inicio
  }

  Future<void> _loadUsers() async {
    final users = await DatabaseHelper().getUsers('', '');
    print('Usuarios cargados: ${users.length}'); // Agrega esta línea para depuración
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text('Bienvenido, ${widget.currentUser.name} ${widget.currentUser.grade != null ? '(${widget.currentUser.grade})' : ''}'),
            ),
          ),
        ],
      ),
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
          children: [
            ElevatedButton(
              onPressed: () {
                _showAddUserDialog(context);
              },
              child: const Text('Agregar Usuario'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text('Grado: ${user.grade}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditUserDialog(context, user);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _confirmDeleteUser(context, user.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final userController = TextEditingController();
    final passwordController = TextEditingController();
    String? selectedGrade;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Agregar Usuario'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: userController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true, // Esto hace que el texto ingresado sea seguro
                  ),
                  DropdownButton<String>(
                    hint: const Text('Seleccionar Grado'),
                    value: selectedGrade,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGrade = newValue;
                      });
                    },
                    items: gradesList.map<DropdownMenuItem<String>>((String grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (userController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        selectedGrade != null) {
                      // Crear un nuevo usuario
                      final newUser = User(
                        name: userController.text, // Usamos 'name' como 'Usuario'
                        password: passwordController.text, // Guardar la contraseña
                        grade: selectedGrade!, // Grado seleccionado
                      );

                      try {
                        // Guardar en SQLite
                        await DatabaseHelper().insertUser(newUser);

                        // Cerrar el diálogo
                        Navigator.of(context).pop();

                        // Recargar usuarios
                        _loadUsers();

                        // Mostrar mensaje de éxito en el Scaffold principal
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Usuario agregado correctamente')),
                        );
                      } catch (e) {
                        // Captura errores en caso de que algo falle
                        print('Error al insertar el usuario: $e');

                        // Cerrar el diálogo
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error al guardar el usuario')),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, User user) {
    final userController = TextEditingController(text: user.name);
    final passwordController = TextEditingController(text: user.password);
    String? selectedGrade = user.grade;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Usuario'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: userController,
                    decoration: const InputDecoration(labelText: 'Usuario'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true, // Esto hace que el texto ingresado sea seguro
                  ),
                  DropdownButton<String>(
                    hint: const Text('Seleccionar Grado'),
                    value: selectedGrade,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGrade = newValue;
                      });
                    },
                    items: gradesList.map<DropdownMenuItem<String>>((String grade) {
                      return DropdownMenuItem<String>(
                        value: grade,
                        child: Text(grade),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (userController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty &&
                        selectedGrade != null) {
                      // Actualizar usuario
                      final updatedUser = User(
                        id: user.id, // Asegúrate de que tienes un campo id en tu modelo User
                        name: userController.text,
                        password: passwordController.text,
                        grade: selectedGrade!,
                      );

                      try {
                        await DatabaseHelper().updateUser(updatedUser);

                        Navigator.of(context).pop();
                        _loadUsers();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Usuario editado correctamente')),
                        );
                      } catch (e) {
                        print('Error al actualizar el usuario: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hubo un error al editar el usuario')),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteUser(BuildContext context, int? userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Usuario'),
          content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await DatabaseHelper().deleteUser(userId!);
                  _loadUsers();
                  Navigator.of(context).pop(); // Cerrar diálogo

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Usuario eliminado correctamente')),
                  );
                } catch (e) {
                  print('Error al eliminar el usuario: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hubo un error al eliminar el usuario')),
                  );
                }
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
