class TareaMateria{
  int IdTarea;
  String IdMateira;
  String NombreMateria;
  String SemestreMateria;
  String DocenteMateria;
  String F_Entrega;
  String Descripcion;

  TareaMateria({
    required this.IdTarea,
    required this.IdMateira,
    required this.F_Entrega,
    required this.Descripcion,
    required this.NombreMateria,
    required this.SemestreMateria,
    required this.DocenteMateria
  });

  Map<String, dynamic> toJSON(){
    return {
      "idtarea": IdTarea,
      "idmateria": IdMateira,
      "f_entrega": F_Entrega,
      "descripcion": Descripcion
    };
  }
}