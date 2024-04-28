class Tarea{
  int IdTarea;
  String IdMateria;
  String F_Entrega;
  String Descripcion;

  Tarea({
    required this.IdTarea,
    required this.IdMateria,
    required this.F_Entrega,
    required this.Descripcion
  });

  Map<String, dynamic> toJSON(){
    return {
      "idtarea": IdTarea,
      "idmateria": IdMateria,
      "f_entrega": F_Entrega,
      "descripcion": Descripcion
    };
  }
}