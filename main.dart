import 'package:control_tareas/controladores/materiaDB.dart';
import 'package:control_tareas/controladores/tareaDB.dart';
import 'package:control_tareas/modelos/tarea.dart';
import '/tarea/ventanaTareas.dart';
import '/materia/ventanaMaterias.dart';
import './modelos/tareaMateria.dart';
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
    return const MaterialApp(
      title: 'Control de tareas',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Control de tareas'),
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
 List<TareaMateria> listaTareas = [];
 String materiallaveforanea = "";

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async {
   List<Materia> lm = await DBMateria.consultar();
   List<TareaMateria> lt = await DBTarea.consultarHoy();
   setState(() {
     listaTareas = lt;
     listaMaterias = lm;
     if (lm.isNotEmpty) {
       materiallaveforanea = lm.first.IdMateria;
     }
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Control tareas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(onPressed: (){
            cargarMaterias();
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          agregarTarea();
        },
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Column()),
            itemDrawer(1, Icons.book, "Materias"),
            itemDrawer(2, Icons.edit, "Tareas"),
          ],
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: listaTareas.length,
          itemBuilder: (context, index){
            return ListTile(
              leading: const Icon(Icons.pending_actions, color: Colors.yellow,),
              title: Text(listaTareas[index].F_Entrega),
              subtitle: Text('${listaTareas[index].NombreMateria}: ${listaTareas[index].Descripcion}'),
            );
          },),
    );
  }

  Widget dinamico(){
    switch(_indice){
      case 1: return const ventanaMaterias();
      case 2: return const VentanaTareas();
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
          Expanded(flex: 2,child: Text(texto)),
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
            padding: const EdgeInsets.all(15),
            children: [
              const SizedBox(height: 20),
              DropdownButtonFormField(
                  value: materiallaveforanea,
                  items: listaMaterias.map((e){
                    return DropdownMenuItem(
                        value: e.IdMateria,
                        child: Text(e.Nombre)
                    );
                  }).toList(),
                  onChanged: (valor){
                    setState(() {
                      materiallaveforanea = valor!;
                    });
                  }
              ),
              const SizedBox(height: 15),
              TextField(
                controller: fecha,
                decoration: const InputDecoration(
                  labelText: "Fecha de entrega:",
                  icon: Icon(Icons.date_range)
                ),
                readOnly: true,
                onTap: (){
                  selecionarFecha();
                },
              ),
              const SizedBox(height: 15,),
              TextField(
                controller: descripcion,
                decoration: const InputDecoration(
                    labelText: "Descripción:",
                    icon: Icon(Icons.content_paste_sharp)
                ),
              ),
              const SizedBox(height: 30),
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
                  }, child: const Text("Agregar")),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: const Text("Cancelar"))
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
