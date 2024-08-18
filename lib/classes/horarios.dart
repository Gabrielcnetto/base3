import 'dart:math';

class Horarios {
  final String horario;
  final String id;
  final int quantidadeHorarios;
  Horarios({
    required this.quantidadeHorarios,
    required this.horario,
    required this.id,
  });
}

List<Horarios> hourLists = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),

];
//Horarios apenas de sabado:
List<Horarios> sabadoHorarios = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),

];

//HORARIOS QUEBRADOS PARA ENCAIXE
List<Horarios> listaHorariosEncaixe = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),

];

//encaixes para sabado
List<Horarios> sabadoHorariosEncaixe = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
      Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
    Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
];
List<Horarios> listaHorariosdaLateral = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "20:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
];
List<Horarios> listaHorariosEncaixev2 = [
  Horarios(
    horario: "08:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "08:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "09:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "10:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "11:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "12:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "13:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "14:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "15:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "16:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "17:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "18:50",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:00",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:20",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),
  Horarios(
    horario: "19:30",
    id: Random().nextDouble().toString(),
    quantidadeHorarios: 1,
  ),

];