import 'package:flutter/material.dart';

import '../controladores/materiaDB.dart';
import '../modelos/materia.dart';

class agregarMaterias extends StatefulWidget {
  const agregarMaterias({super.key});

  @override
  State<agregarMaterias> createState() => _agregarMateriasState();
}

class _agregarMateriasState extends State<agregarMaterias> {
  // Controladores de texto
  final idmateriaController = TextEditingController();
  final nombreController = TextEditingController();
  final semestreController = TextEditingController();
  final docenteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(50),
      children: [
        TextFormField(
          controller: idmateriaController,
          decoration: const InputDecoration(
              icon: Icon(Icons.book),
              labelText: "ID"
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: nombreController,
          decoration: const InputDecoration(
              icon: Icon(Icons.border_color),
              labelText: "Nombre"
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: semestreController,
          decoration: const InputDecoration(
              icon: Icon(Icons.school),
              labelText: "Semestre"
          ),
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: docenteController,
          decoration: const InputDecoration(
              icon: Icon(Icons.person),
              labelText: "Docente"
          ),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: (){
              Materia m = Materia(
                  IdMateria: idmateriaController.text,
                  Nombre: nombreController.text,
                  Semestre: semestreController.text,
                  Docente: docenteController.text
              );

              DBMateria.insertar(m).then((value){
                if(value < 1){
                  mensaje("Error al insertar");
                  return;
                }

                mensaje("Se inserto con exito");
                limpiarCampos();
              });
            }, child: Text("Agregar")),
            ElevatedButton(onPressed: (){
              limpiarCampos();
            }, child: Text("Limpiar"))
          ],
        )
      ],
    );
  }

  void limpiarCampos(){
    idmateriaController.clear();
    nombreController.clear();
    semestreController.clear();
    docenteController.clear();
  }

  void mensaje (String s){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s))
    );
  }
}
