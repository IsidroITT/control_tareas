import '/controladores/materiaDB.dart';
import 'package:flutter/material.dart';
import '../modelos/materia.dart';

class listarMaterias extends StatefulWidget {
  const listarMaterias({super.key});

  @override
  State<listarMaterias> createState() => _listarMateriasState();
}

class _listarMateriasState extends State<listarMaterias> {
  List<Materia> listaMaterias = [];

  // Controladores de texto
  final idmateriaController = TextEditingController();
  final nombreController = TextEditingController();
  final semestreController = TextEditingController();
  final docenteController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async{
    List<Materia> lm = await DBMateria.consultar();
    setState(() {
      listaMaterias = lm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: listaMaterias.length,
      itemBuilder: (context, index){
        return ListTile(
          title: Text(listaMaterias[index].Nombre),
          subtitle: Text("${listaMaterias[index].Docente} - ${listaMaterias[index].Semestre}"),
          trailing: IconButton(onPressed: (){
            botonEliminar(index);
          }, icon: Icon(Icons.delete)),
          onTap: (){
            nombreController.text = listaMaterias[index].Nombre;
            semestreController.text = listaMaterias[index].Semestre;
            docenteController.text = listaMaterias[index].Docente;

            ventanaActualizar(listaMaterias[index].IdMateria);
          },
        );
      }
    );
  }

  void botonEliminar(int index){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            icon: Icon(
              Icons.warning,
              color: Colors.white,
            ),
            backgroundColor: Colors.redAccent,
            title: Text("Cuidado!",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            content: Text("Estas seguro que deseas eliminar este elemento (${listaMaterias[index].Nombre} - ${listaMaterias[index].Docente})",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    DBMateria.eliminar(listaMaterias[index].IdMateria);
                    setState(() {
                      cargarMaterias();
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Eliminar",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancelar",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
            ],
          );
        }
    );
  }

  void ventanaActualizar(String index) {
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (builder){
          return Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 40,
              right: 40,
              bottom: MediaQuery.of(context).viewInsets.bottom+300,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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

                      DBMateria.actualizar(m, index).then((value){
                        if(value < 1){
                          mensaje("Error al actualizar");
                          Navigator.pop(context);
                          return;
                        }

                        mensaje("Se actualizo con exito");
                        cargarMaterias();
                        Navigator.pop(context);
                      });
                    }, child: Text("Actualizar")),
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Cancelar"))
                  ],
                )
              ],
            ),
          );
        });
  }

  void mensaje (String s){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s))
    );
  }
}
