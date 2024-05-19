import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: lanzamientos(),
    );
  }
}

class lanzamientos extends StatefulWidget {
  @override
  _lanzamientosState createState() => _lanzamientosState();
}

class _lanzamientosState extends State<lanzamientos> {
  List lanzamientos = [];
  @override
  void initState() {
    super.initState();
    fetchLaunches();
  }

  Future<void> fetchLaunches() async {
    final response = await http.get(Uri.parse('https://api.spacexdata.com/v5/launches'));
    if (response.statusCode == 200) {
      setState(() {
        lanzamientos = json.decode(response.body);
      });
    } else {
      print('No se pudo cargar los datos');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lanzamientos'),
      ),
      body: ListView.builder(
        itemCount: lanzamientos.length,
        itemBuilder: (context, index) {
          var lanzamiento = lanzamientos[index];
          return Card(
            child: ListTile(
              title: Text(lanzamiento['name'] ?? 'Inexistente'),
              subtitle: Text('Fecha: ${lanzamiento['date_utc'] ?? ' '} \nEstado: ${lanzamiento['success'] == null ? 'A futuro' : (lanzamiento['success'] ? 'Completado' : 'Fracaso')}',),
              leading: Image.network(lanzamiento['links']['patch']['small'] ?? 'https://via.placeholder.com/50', width: 50, height: 100,),
            ),
          );
        },
      ),
    );
  }
}
