class Materia{
  String IdMateria;
  String Nombre;
  String Semestre;
  String Docente;

  Materia({
    required this.IdMateria,
    required this.Nombre,
    required this.Semestre,
    required this.Docente
  });

  Map<String, dynamic> toJSON(){
    return {
      "idmateria": IdMateria,
      "nombre": Nombre,
      "Semestre": Semestre,
      "docente": Docente
    };
  }
}