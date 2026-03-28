class Autor {
  final int id;
  final String nombre;

  Autor({required this.id, required this.nombre});

  // Mapeo del JSON de C# a objeto Dart
  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'],
      nombre: json['nombre'],
    );
  }
}