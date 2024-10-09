import 'package:biblioteca/pages/LoginPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';


void main() {
  // Verifica si está en la web y usa la fábrica de base de datos correcta
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Usa esta para web
  } else {
    databaseFactory = databaseFactoryFfi; // Usa esta para escritorio
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(), // Cambiar aquí para que inicie en LoginPage
    );
  }
}