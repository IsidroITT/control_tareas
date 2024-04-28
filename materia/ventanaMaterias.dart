import '/materia/agregarMaterias.dart';
import '/materia/listarMaterias.dart';
import 'package:flutter/material.dart';

class ventanaMaterias extends StatefulWidget {
  const ventanaMaterias({super.key});

  @override
  State<ventanaMaterias> createState() => _ventanaMateriasState();
}

class _ventanaMateriasState extends State<ventanaMaterias> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Control tareas",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent,
            bottom: const TabBar(
              labelStyle: TextStyle(
                color: Colors.white
              ),
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(text: "Agregar", icon: Icon(Icons.add)),
                Tab(text: "Listar", icon: Icon(Icons.list)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [agregarMaterias(), listarMaterias()],
          ),
        ));
  }
}
