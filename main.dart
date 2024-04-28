import 'package:control_tareas/materia/ventanaMaterias.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          // ya tu sabe xd
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
            itemDrawer(3, Icons.book, "Materias"),
          ],
        ),
      ),
    );
  }

  Widget dinamico(){
    switch(_indice){
      case 1: return ventanaMaterias();
      case 2: return ListView();
      case 3: return ListView();
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
}
