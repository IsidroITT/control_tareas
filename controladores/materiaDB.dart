import 'package:sqflite/sqflite.dart';
import '../modelos/materia.dart';
import 'conexionDB.dart';

class DBMateria {
  static Future<int> insertar(Materia m) async{
    Database base = await Conexion.abrirDB();
    return base.insert("MATERIA", m.toJSON(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(String i) async{
    Database base = await Conexion.abrirDB();
    return base.delete("MATERIA", where: "IDMATERIA=?", whereArgs: [i]);
  }

  static Future<List<Materia>> consultar() async{
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> r = await base.query("MATERIA");

    return List.generate(
        r.length,
            (index){
          return Materia(
              IdMateria: r[index]["IDMATERIA"],
              Nombre:  r[index]["NOMBRE"],
              Semestre:  r[index]["SEMESTRE"],
              Docente:  r[index]["DOCENTE"]
          );
        });
  }

  static Future<int> actualizar(Materia m, String i) async{
    Database base = await Conexion.abrirDB();
    return base.update("MATERIA", m.toJSON(), where: "IDMATERIA=?", whereArgs: [i]);
  }
}