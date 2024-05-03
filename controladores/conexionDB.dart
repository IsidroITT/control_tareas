import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion{
  static Future<Database> abrirDB() async{
    return openDatabase(
      join(await getDatabasesPath(), "practica1.db"),
      onCreate: (db, version){
        return _script(db);
      },
      version: 1
    );
  }

  static Future<void> _script(Database db) async{
    await db.execute("CREATE TABLE MATERIA("
        "IDMATERIA TEXT PRIMARY KEY,"
        "NOMBRE TEXT,"
        "SEMESTRE TEXT,"
        "DOCENTE TEXT"
        ")");

    await db.execute("CREATE TABLE TAREA("
        "IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT,"
        "IDMATERIA TEXT,"
        "F_ENTREGA TEXT,"
        "DESCRIPCION TEXT,"
        "FOREIGN KEY (IDMATERIA) REFERENCES MATERIA(IDMATERIA)"
        ")");
  }
}