import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:biblioteca/pages/adminpage.dart';
import 'package:biblioteca/pages/homepage.dart';
import 'package:biblioteca/model/user.dart';  // Asegúrate de importar tu modelo de usuario

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

    try {
      // Autenticación usando Supabase
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: username,
        password: password,
      );

      if (response.error != null) {
        // Mostrar mensaje de error si las credenciales son incorrectas
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.error!.message)),
        );
        return;
      }

      // Obtener información adicional del usuario
      final userData = await Supabase.instance.client
          .from('users') // Cambia 'users' al nombre de tu tabla si es diferente
          .select()
          .eq('email', username)
          .single();

      // Verificar si se encontraron datos del usuario
      // ignore: unrelated_type_equality_checks
      if (userData == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Usuario no encontrado.')),
        );
        return;
      }

      // Asegúrate de que los campos existen
      if (userData['name'] == null || userData['grade'] == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Datos de usuario incompletos.')),
        );
        return;
      }

      // Crear la instancia de User con los datos obtenidos
      final currentUser = Users(
        name: userData['name'], // Asegúrate de que tu tabla tenga este campo
        password: password,      // Considera no guardar la contraseña directamente
        grade: userData['grade'], // Asegúrate de que este campo exista en tu tabla
      );

      // Redirigir a la página de inicio del usuario
      if (currentUser.grade == 'master') {
        // Redirigir al AdminPage si el grado es 'master'
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPage(currentUser: currentUser)),
        );
      } else {
        // Redirigir al HomePage para otros grados
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: currentUser)),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de inicio de sesión: $error')),
      );
    }
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

extension on AuthResponse {
  get error => null;
}
