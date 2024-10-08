import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'db/mongodb.dart';

class DocumentoPage extends StatefulWidget {
  const DocumentoPage({super.key});

  @override
  DocumentoPageState createState() => DocumentoPageState();
}

class DocumentoPageState extends State<DocumentoPage> {
  List documents = [];

  @override
  void initState() {
    super.initState();
    _getDocuments();
  }

  void _getDocuments() async {
    var data = await MongoDatabase.documentCollection!.find().toList();
    setState(() {
      documents = data;
    });
  }

  void _deleteDocument(String id) async {
    await MongoDatabase.documentCollection!.remove(mongo.where.id(mongo.ObjectId.parse(id)));
    _getDocuments(); // Refrescar lista después de eliminar
  }

  void _showDocumentDialog({Map? document}) {
  // Controladores de texto locales
  final TextEditingController nameController = TextEditingController(
    text: document != null ? document['nombre'] : '',
  );
  final TextEditingController categoriaController = TextEditingController(
    text: document != null ? document['categoria'] : '',
  );
  final TextEditingController gradoMinimoController = TextEditingController(
    text: document != null ? document['grado_minimo'] : '',
  );
  Uint8List? fileBytes;
    String? fileName;
  
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(document == null ? 'Agregar Documento' : 'Editar Documento'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nombre del Documento')),
          TextField(controller: categoriaController, decoration: const InputDecoration(labelText: 'Categoría')),
          TextField(controller: gradoMinimoController, decoration: const InputDecoration(labelText: 'Grado Mínimo')),
          ElevatedButton(
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf'],
              );
              if (result != null) {
  if (!mounted) return;  // Verificar que el widget siga montado.
  
  fileBytes = result.files.first.bytes;
  fileName = result.files.first.name;
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Archivo seleccionado: $fileName')),
  );
} else {
  if (!mounted) return;  // Verificar que el widget siga montado.
  
  // El usuario canceló la selección de archivos
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('No se seleccionó ningún archivo')),
  );
}

            },
            child: const Text('Seleccionar PDF'),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            if (fileBytes == null && document == null) {
              // No hay un archivo cargado para un nuevo documento
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Por favor selecciona un archivo PDF')),
              );
              return;
            }

            if (document == null) {
              // Agregar nuevo documento
              await MongoDatabase.documentCollection!.insert({
                "nombre": nameController.text,
                "categoria": categoriaController.text,
                "grado_minimo": gradoMinimoController.text,
                "pdf_url": fileBytes != null ? await _uploadPdf(fileBytes!, fileName!) : "URL_del_archivo_subido"
              });
            } else {
              // Actualizar documento existente
              await MongoDatabase.documentCollection!.update(
                mongo.where.id(mongo.ObjectId.parse(document['_id'].toString())),
                {
                  "nombre": nameController.text,
                  "categoria": categoriaController.text,
                  "grado_minimo": gradoMinimoController.text,
                  if (fileBytes != null) "pdf_url": await _uploadPdf(fileBytes!, fileName!) // Solo actualizar si se seleccionó un nuevo archivo
                },
              );
            }
            if (mounted) {
              Navigator.pop(context);
            }
            _getDocuments(); // Refrescar lista de documentos
          },
          child: const Text('Guardar'),
        ),
      ],
    ),
  );
}

Future<String> _uploadPdf(Uint8List fileBytes, String fileName) async {
  // Aquí podrías implementar la lógica para subir el archivo a tu servidor o servicio de almacenamiento
  // Por ejemplo, podrías subirlo a Firebase Storage o algún servidor con capacidad para manejar archivos.
  
  // Simulación de URL de archivo subido
  await Future.delayed(const Duration(seconds: 2)); // Simula un tiempo de subida
  return "https://mi-servidor.com/uploads/$fileName"; // Cambia esto por la URL real del archivo subido
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Documentos')),
      body: ListView.builder(
        itemCount: documents.length,
        itemBuilder: (context, index) {
          var document = documents[index];
          return ListTile(
            title: Text(document['nombre']),
            subtitle: Text('Categoría: ${document['categoria']} (Grado Mínimo: ${document['grado_minimo']})'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showDocumentDialog(document: document)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteDocument(document['_id'].toString())),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDocumentDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
