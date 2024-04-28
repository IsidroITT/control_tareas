import 'package:control_tareas/controladores/materiaDB.dart';
import 'package:control_tareas/controladores/tareaDB.dart';
import 'package:control_tareas/modelos/tarea.dart';
import 'package:control_tareas/tarea/agregarTarea.dart';
import 'package:control_tareas/tarea/listarTareas.dart';

import '/materia/ventanaMaterias.dart';
import 'package:flutter/material.dart';

import 'modelos/materia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de tareas',
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Control de tareas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 int _indice = 0;

 // estas variables tampoco :p
 final fecha = TextEditingController();
 final descripcion = TextEditingController();
 List<Materia> listaMaterias = [];
 String materiallaveforanea = "";

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async {
   List<Materia> lm = await DBMateria.consultar();
   setState(() {
     listaMaterias = lm;
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Control tareas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          agregarTarea();
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column()),
            itemDrawer(1, Icons.book, "Materias"),
            itemDrawer(2, Icons.edit, "Tareas"),
          ],
        ),
      ),
    );
  }

  Widget dinamico(){
    switch(_indice){
      case 1: return ventanaMaterias();
      case 2: return listarTareas();
      default: return ListView();
    }
  }

  Widget itemDrawer(int i, IconData icono, String texto){
    return ListTile(
      onTap: (){
        setState(() {
          _indice = i;
        });
        // Enlace con las paginas de la aplicacion
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => dinamico())
        );
      },
      title: Row(
        children: [
          Expanded(child: Icon(icono),),
          Expanded(child: Text(texto), flex: 2,),
        ],
      )
    );
  }

  // Los metodos de abajo no deberian estar aqui :c
  void agregarTarea(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ListView(
            padding: EdgeInsets.all(15),
            children: [
              SizedBox(height: 20),
              DropdownButtonFormField(
                  value: materiallaveforanea,
                  items: listaMaterias.map((e){
                    return DropdownMenuItem(
                        value: e.IdMateria,
                        child: Text("${e.Nombre} - ${e.Docente}")
                    );
                  }).toList(),
                  onChanged: (valor){
                    setState(() {
                      materiallaveforanea = valor!;
                    });
                  }
              ),
              SizedBox(height: 15),
              TextField(
                controller: fecha,
                decoration: InputDecoration(
                  labelText: "Fecha de entrega:",
                  icon: Icon(Icons.date_range)
                ),
                readOnly: true,
                onTap: (){
                  selecionarFecha();
                },
              ),
              SizedBox(height: 15,),
              TextField(
                controller: descripcion,
                decoration: InputDecoration(
                    labelText: "Descripción:",
                    icon: Icon(Icons.content_paste_sharp)
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    Tarea t = Tarea(
                        IdTarea: -1,
                        IdMateria: materiallaveforanea,
                        F_Entrega: fecha.text,
                        Descripcion: descripcion.text
                    );

                    DBTarea.insertar(t).then((value){
                      if(value < 1){
                        mensaje("Error al insertar");
                        Navigator.pop(context);
                        return;
                      }

                      mensaje("Se inserto con exito");
                      Navigator.pop(context);
                    });
                  }, child: Text("Agregar")),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Cancelar"))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> selecionarFecha() async{
   DateTime? fechaSelecionada = await showDatePicker(
       context: context,
       firstDate: DateTime.now(),
       lastDate: DateTime(3000)
   );

   if (fechaSelecionada != null){
     setState(() {
       fecha.text = fechaSelecionada.toString().split(" ")[0];
     });
   }
  }

  void mensaje(String s){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
