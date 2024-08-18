class cupomClass {
  final String name;
  final String id;
  final String horario;
  bool isActive;
  final String codigo;

  final int multiplicador;
  cupomClass({
    required this.codigo,
    required this.name,
    required this.horario,
    required this.id,
    required this.isActive,
    required this.multiplicador,
  });
}
