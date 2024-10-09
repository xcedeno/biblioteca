// ignore: file_names
import 'package:flutter/material.dart';
import 'adminpage.dart';
import 'homepage.dart';
import 'db/database_helper.dart';
import 'package:biblioteca/model/user.dart';  // Importa el modelo de usuario

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    var username = _usernameController.text.trim();
    var password = _passwordController.text.trim();

    // Verificar si el usuario es el "master" con credenciales fijas
    if (username == 'master' && password == 'master') {
      // Crear un objeto User para el "master"
      final currentUser = User(
        name: username,
        password: password,  // Asegúrate de que tu modelo de usuario maneje esto
        grade: 'master',     // Asigna un grado según tu lógica
      );

      // Redirigir al usuario a la página de administración
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AdminPage(currentUser: currentUser),
        ),
      );
      return;
    }

    // Verificar en la base de datos SQLite
    var users = await DatabaseHelper().getUsers(username, password);

    if (users.isEmpty) {
      // Manejar caso en el que no se encuentra el usuario
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario o contraseña incorrectos')),
      );
      return;
    }

    var currentUser = users.first; // Suponiendo que el método devuelve una lista de usuarios

    if (!mounted) return; // Verificar que el widget siga montado antes de usar el contexto.

    // Redirigir a la página de inicio del usuario
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: currentUser),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Usuario"),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: "Contraseña"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Iniciar Sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
