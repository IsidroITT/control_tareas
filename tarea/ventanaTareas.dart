import 'package:flutter/material.dart';
import '/tarea/agregarTarea.dart';
import '/tarea/listarTareas.dart';

class VentanaTareas extends StatefulWidget {
  const VentanaTareas({super.key});

  @override
  State<VentanaTareas> createState() => _VentanaTareasState();
}

class _VentanaTareasState extends State<VentanaTareas> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Control de tareas',
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent,
            bottom: const TabBar(
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                unselectedLabelColor: Colors.black,
                tabs: [
                  Tab(text: 'Agregar', icon: Icon(Icons.add)),
                  Tab(text: 'Listar', icon: Icon(Icons.list))
                ]),
          ),
          body: const TabBarView(
              children: [AgregarTarea(), listarTareas()]),
        ));
  }
}
