
class GeralUser {
  final String userIdDatabase;
  final String assinaturaId;
  final String name;
  final String urlImage;
  final String PhoneNumber;
  final int listacortes;
  final bool isAssinatura;
  final bool isfuncionario;
  final bool isManager;
  final DateTime ultimoAgendamento;

  GeralUser({
    required this.userIdDatabase,
    required this.assinaturaId,
    required this.ultimoAgendamento,
    required this.isManager,
    required this.isAssinatura,
    required this.PhoneNumber,
    required this.listacortes,
    required this.isfuncionario,
    required this.name,
    required this.urlImage,
  });
}
