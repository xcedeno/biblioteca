import 'package:biblioteca/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://heznwurkghqymlilvzoy.supabase.co', // Reemplaza con tu URL de Supabase
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhlem53dXJrZ2hxeW1saWx2em95Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjg1MjQ2NzcsImV4cCI6MjA0NDEwMDY3N30.Tz79FPJFeTgxjbzmGSnZZYUWVfBPz43QQzNy9M0uH-k', // Reemplaza con tu anon public key
  );
  runApp(const MyApp());
}
final supabase=Supabase.instance.client;
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biblioteca Masonica',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Cambiar aquí para que inicie en LoginPage
    );
  }
}