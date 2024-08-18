// ignore_for_file: file_names, non_constant_identifier_names, duplicate_ignore

class CorteClass {
  final bool pagoComCreditos;
  final bool feitoporassinatura;
  final int easepoints;
  final String id;
  final bool isActive;
  final bool pagoComCupom;
  final String clientName;
  final String numeroContato;
  final bool barba;
  // ignore: non_constant_identifier_names
  final int DiaDoCorte;
  // ignore: non_constant_identifier_names
  final String NomeMes;
  final DateTime diaCorte;
  final int ramdomCode;
  final String horarioCorte;
  final String profissionalSelect;
  final DateTime dateCreateAgendamento;
  final int totalValue;
  final List<String> horariosExtra;
  final String detalheDoProcedimento;
  final bool apenasBarba;
  CorteClass({
    required this.feitoporassinatura,
    required this.pagoComCreditos,
    required this.pagoComCupom,
    required this.easepoints,
    required this.detalheDoProcedimento,
    required this.apenasBarba,
    required this.isActive,
    required this.DiaDoCorte,
    required this.clientName,
    required this.totalValue,
    required this.NomeMes,
    required this.id,
    required this.numeroContato,
    required this.profissionalSelect,
    required this.diaCorte,
    required this.horarioCorte,
    required this.barba,
    required this.ramdomCode,
    required this.dateCreateAgendamento,
    required this.horariosExtra,
  });
}
