// ignore_for_file: prefer_final_fields, unused_field, file_names

import 'package:flutter/cupertino.dart';
import 'package:easebase/classes/horarios.dart';

class AgendaData with ChangeNotifier {
  double _linhaPosicao = 0;
  double _alturaTela = 0;

  double get linhaPosicao => _linhaPosicao;

  void atualizarLinhaPosicao({
  required BuildContext context,
  required List<Horarios> listaHorarios,
}) {
  DateTime agora = DateTime.now();
  DateTime horaBrasilia = agora.toUtc().subtract(const Duration(hours: 3));

  int minutosAgora = horaBrasilia.hour * 60 + horaBrasilia.minute;

  // Encontrar o horário mais próximo ao minutosAgora na lista
  int indiceHorarioAtual = 0;
  for (int i = 0; i < listaHorarios.length; i++) {
    // Converter horário em minutos desde a meia-noite
    List<String> parts = listaHorarios[i].horario.split(":");
    int hora = int.parse(parts[0]);
    int minuto = int.parse(parts[1]);
    int minutosHorario = hora * 60 + minuto;

    if (minutosAgora >= minutosHorario) {
      indiceHorarioAtual = i;
    } else {
      break;
    }
  }

  // Calcular a posição vertical da linha com base no índice encontrado
  double linhaPosicao = indiceHorarioAtual * 80.0 + 40.0; // Ajuste conforme necessário

  // Atualizar a posição da linha na classe AgendaData usando Provider
  _linhaPosicao = linhaPosicao;
}

  void resetLinhaPosicao() {
    _linhaPosicao = 0.0;
    notifyListeners();
  }
}
