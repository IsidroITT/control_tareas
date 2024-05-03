import '/controladores/materiaDB.dart';
import '/controladores/tareaDB.dart';
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
 List<TareaMateria> listaTareas = [];

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cargarMaterias();
  }

  void cargarMaterias() async {
   List<TareaMateria> lt = await DBTarea.consultarHoy();
   setState(() {
     listaTareas = lt;
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
          }, icon: const Icon(Icons.refresh,
            color: Colors.white,
          )),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(child: Column(
              children: [
                CircleAvatar(
                  child: Icon(Icons.account_box, size: 40,),
                  radius: 40,
                ),
                SizedBox(height: 8,),
                Text("ADEL",
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copyright,
                    size: 20,
                    color: Colors.white,
                    ),
                    SizedBox(width: 5,),
                    Text("Moviles 2024",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ],
                )
              ],
            ),
              decoration: BoxDecoration(
                color: Colors.pinkAccent
              ),
            ),
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
      default: return const VentanaTareas();
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

  void mensaje(String s){
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }
}
