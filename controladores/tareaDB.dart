import 'package:control_tareas/modelos/tarea.dart';
import 'package:control_tareas/modelos/tareaMateria.dart';

import '/controladores/conexionDB.dart';
import 'package:sqflite/sqflite.dart';

class DBTarea {
  static Future<int> insertar(Tarea t) async{
    Database base = await Conexion.abrirDB();
    return base.insert("TAREA", t.toJSON(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<int> eliminar(int id) async{
    Database base = await Conexion.abrirDB();
    return base.delete("TAREA", where: "IDTAREA=?", whereArgs: [id]);
  }

  static Future<List<TareaMateria>> consultar() async{
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> r = await base.query(
        "TAREA INNER JOIN MATERIA ON TAREA.IDMATERIA = MATERIA.IDMATERIA",
        columns: [
          "TAREA.IDTAREA",
          "TAREA.IDMATERIA",
          "TAREA.F_ENTREGA",
          "TAREA.DESCRIPCION",
          "MATERIA.NOMBRE",
          "MATERIA.SEMESTRE",
          "MATERIA.DOCENTE"
        ]);

    return List.generate(
        r.length,
        (index){
          return TareaMateria(
              IdTarea: r[index]["IDTAREA"],
              IdMateira: r[index]["IDMATERIA"],
              F_Entrega:r[index]["F_ENTREGA"],
              Descripcion: r[index]["DESCRIPCION"],
              NombreMateria: r[index]["NOMBRE"],
              SemestreMateria: r[index]["SEMESTRE"],
              DocenteMateria: r[index]["DOCENTE"]
          );
        });
  }
 static Future<List<TareaMateria>> consultarHoy() async{
    Database base = await Conexion.abrirDB();
    List<Map<String, dynamic>> r = await base.query(
        "TAREA INNER JOIN MATERIA ON TAREA.IDMATERIA = MATERIA.IDMATERIA",
        columns: [
          "TAREA.IDTAREA",
          "TAREA.IDMATERIA",
          "TAREA.F_ENTREGA",
          "TAREA.DESCRIPCION",
          "MATERIA.NOMBRE",
          "MATERIA.SEMESTRE",
          "MATERIA.DOCENTE"],
      where:"F_ENTREGA>=?", whereArgs: [DateTime.now().toString().split(" ")[0]],
      orderBy: "F_ENTREGA"
    );

    return List.generate(
        r.length,
        (index){
          return TareaMateria(
              IdTarea: r[index]["IDTAREA"],
              IdMateira: r[index]["IDMATERIA"],
              F_Entrega:r[index]["F_ENTREGA"],
              Descripcion: r[index]["DESCRIPCION"],
              NombreMateria: r[index]["NOMBRE"],
              SemestreMateria: r[index]["SEMESTRE"],
              DocenteMateria: r[index]["DOCENTE"]
          );
        });
  }

  static Future<int> actualizar(Tarea t, int i) async{
    Database base = await Conexion.abrirDB();
    return base.update("TAREA", t.toJSON(), where: "IDTAREA=?", whereArgs: [i]);
  }
}