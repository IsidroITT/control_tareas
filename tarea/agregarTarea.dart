//region imports
import '/controladores/tareaDB.dart';
import '/controladores/materiaDB.dart';
import '/modelos/tarea.dart';
import '/modelos/materia.dart';
import 'package:flutter/material.dart';
//endregion

class AgregarTarea extends StatefulWidget {
  const AgregarTarea({super.key});

  @override
  State<AgregarTarea> createState() => _AgregarTareaState();
}

class _AgregarTareaState extends State<AgregarTarea> {
  //region variables para la funcción de componentes
  final descripcionDriver = TextEditingController();
  final fechaDriver = TextEditingController();
  List<Materia> listaMaterias = [];
  String idMateriaFK = '';
  //endregion

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarListas();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
     padding: const EdgeInsets.all(50),
     children: [
       //region componentes para capturar la info
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
       //endregion
      const SizedBox(height: 20,),
      Center(
       child: FilledButton(onPressed: (){
        Tarea t = Tarea(
            IdTarea: -1,
            IdMateria: idMateriaFK,
            F_Entrega: fechaDriver.text,
            Descripcion: descripcionDriver.text);
        DBTarea.insertar(t).then((value){
          if(value < 1){
            mensaje('Error al insertar');
            return;
          }
          mensaje('Se inserto con exito');
          descripcionDriver.clear();
          fechaDriver.clear();
        });
       },
           child: const Icon(Icons.save, size: 40),),
      ),
     ],
    );
  }

  //region métodos: mensaje, cargar y seleccionar Fecha
  void mensaje(String s) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s))
    );
  }

  void cargarListas() async{
    listaMaterias = await DBMateria.consultar();
    setState(() {
      if(listaMaterias.isNotEmpty){
        idMateriaFK = listaMaterias.first.IdMateria;
      }
    });
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
//endregion

}

