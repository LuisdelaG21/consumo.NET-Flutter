import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  // colocar la URL para el Get y el post
  final String apiUrlGet = "http://10.0.2.2:5138/api/autores";
  final String apiUrlPost = "http://10.0.2.2:5138/api/autores/introducir"; 

  // Función para obtener autores
  Future<List<dynamic>> obtenerAutores() async {
    try {
      final response = await http.get(Uri.parse(apiUrlGet));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error del servidor: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("No se pudo conectar con la API: $e");
    }
  }

  // insertarAutor: Llama al método POST fijo en la API
  Future<void> insertarAutor() async {
    try {
      final response = await http.post(Uri.parse(apiUrlPost));

      if (response.statusCode == 200) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Autor registrado exitosamente!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al insertar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 153, 255),
        title: const Center(child: Text('Autores desde ASP.NET')),
      ),
      body: FutureBuilder(
        future: obtenerAutores(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay autores en la base de datos."));
          }

          final autores = snapshot.data!;

          return ListView.builder(
            itemCount: autores.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    child: Text(autores[index]['id'].toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  title: Text(autores[index]['nombre'], style: const TextStyle(fontSize: 16),),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: insertarAutor, // Llama a la nueva función al pulsar
        child: const Icon(Icons.add_task),
        tooltip: 'Insertar Autor Fijo',
      ),
    );
  }
}