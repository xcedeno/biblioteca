// ignore: file_names
import 'package:flutter/material.dart';
import 'adminpage.dart';
import 'homepage.dart';
import 'db/database_helper.dart';

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
      // Redirigir al usuario a la página de administración
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminPage(),
        ),
      );
      return;
    }

    // Verificar en la base de datos SQLite
    var user = await DatabaseHelper().getUsers(username, password);

    if (!mounted) return; // Verificar que el widget siga montado antes de usar el contexto.

    // Redirigir a la página de inicio del usuario
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(user: user),
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
