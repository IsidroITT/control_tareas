import '/controladores/materiaDB.dart';
import 'package:flutter/material.dart';
import '../modelos/materia.dart';
import '../modelos/tareaMateria.dart';
import '../modelos/tarea.dart';
import '../controladores/tareaDB.dart';

class listarTareas extends StatefulWidget {
  const listarTareas({super.key});

  @override
  State<listarTareas> createState() => _listarTareasState();
}

class _listarTareasState extends State<listarTareas> {
  List<Materia> listaMaterias = [];
  List<TareaMateria> listaTareas = [];

  //region variables de diseño
  String idMateriaFK = '';
  final fechaDriver = TextEditingController();
  final descripcionDriver = TextEditingController();
  //endregion


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarDatos();
  }

  void cargarDatos() async{
    List<Materia> lm = await DBMateria.consultar();
    List<TareaMateria> lt = await DBTarea.consultar();
    setState(() {
      listaTareas = lt;
      listaMaterias = lm;
      if (listaMaterias.isNotEmpty) {
        idMateriaFK = listaMaterias.first.IdMateria;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: listaTareas.length,
        itemBuilder: (context, index){
          return ListTile(
            title: Text('${listaTareas[index].IdTarea}'),
            subtitle: Text("${listaTareas[index].Descripcion} \n ${listaTareas[index].F_Entrega}"),
            trailing: IconButton(onPressed: (){
              botonEliminar(index);
            }, icon: const Icon(Icons.delete)),
            onTap: (){
              idMateriaFK = listaTareas[index].IdMateira;
              fechaDriver.text = listaTareas[index].F_Entrega;
              descripcionDriver.text = listaTareas[index].Descripcion;
              ventanaActualizar(listaTareas[index].IdTarea);
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
            icon: const Icon(
              Icons.warning,
              color: Colors.white,
            ),
            backgroundColor: Colors.redAccent,
            title: const Text("Cuidado!",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
            content: Text("Estas seguro que deseas eliminar este elemento (${listaTareas[index].IdTarea}: ${listaTareas[index].Descripcion})",
              style: const TextStyle(
                  color: Colors.white
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (){
                    DBTarea.eliminar(listaTareas[index].IdTarea);
                    setState(() {
                      cargarDatos();
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("Eliminar",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: const Text("Cancelar",
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

  void ventanaActualizar(int index) {
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
                DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: 'Materia:',
                      icon: Icon(Icons.book),
                    ),
                    value: idMateriaFK,
                    items: listaMaterias.map((e){
                      return DropdownMenuItem(
                          value: e.IdMateria,
                          child: Text(e.Nombre));
                    }).toList(),
                    onChanged: (data){
                      setState(() {
                        idMateriaFK = data!;
                      });
                    }),
                const SizedBox(height: 10,),
                TextFormField(
                  controller: fechaDriver,
                  decoration: const InputDecoration(
                      labelText: 'Fecha de entrega:',
                      icon: Icon(Icons.date_range)
                  ),
                  readOnly: true,
                  onTap: (){
                    seleccionarFecha();
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: descripcionDriver,
                  decoration: const InputDecoration(
                      labelText: 'Descripción: ',
                      icon: Icon(Icons.description)
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: (){
                          Tarea t = Tarea(
                              IdTarea: -1,
                              IdMateria: idMateriaFK,
                              F_Entrega: fechaDriver.text,
                              Descripcion: descripcionDriver.text);
                          DBTarea.actualizar(t, index).then((value) {
                            if (value < 1) {
                              mensaje('Error al actualizar');
                              Navigator.pop(context);
                              return;
                            }
                            mensaje('Se actualizo con exito');
                            cargarDatos();
                            Navigator.pop(context);
                          });
                        },
                        child: const Icon(Icons.update, size: 25,)),
                    ElevatedButton(
                        onPressed: (){
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.cancel, size: 25,)),
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

  Future<void> seleccionarFecha() async {
    DateTime? fechaSelecionada = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      initialDate: DateTime.now(),
      lastDate: DateTime(2099),
    );

    if (fechaSelecionada != null){
      setState(() {
        fechaDriver.text = fechaSelecionada.toString().split(" ")[0];
      });
    }
  }
}
