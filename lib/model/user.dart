// lib/models/user.dart
class User {
  final int? id;
  final String name;
  final String password;
  final String grade;

  User({this.id, required this.name, required this.password, required this.grade});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'grade': grade,
    };
  }
}