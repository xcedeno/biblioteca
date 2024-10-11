class Users {
  final int? id;                // ID del usuario, puede ser nulo si no se especifica
  final String name;           // Nombre del usuario
  final String password;       // Contraseña del usuario (considera no almacenar esto)
  final String grade;          // Grado del usuario

  // Constructor de la clase, usando required para asegurar que los campos no sean nulos
  Users({
    this.id, 
    required this.name, 
    required this.password, 
    required this.grade,
  });

  // Método para convertir el objeto User a un mapa (útil para enviar a una base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'grade': grade,
    };
  }

  // Método para crear un objeto User desde un mapa
  factory Users.fromMap(Map<String, dynamic> map) {
    return Users(
      id: map['id'], // Asegúrate de que el campo 'id' exista en el mapa
      name: map['name'], // Asegúrate de que el campo 'name' exista en el mapa
      password: map['password'], // Asegúrate de que el campo 'password' exista en el mapa
      grade: map['grade'], // Asegúrate de que el campo 'grade' exista en el mapa
    );
  }
}
