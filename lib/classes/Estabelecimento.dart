import 'package:flutter/material.dart';

class Estabelecimento {

  //visual e dados do estabelecimento
  static const String bannerAgendamento = "imagesOfApp/banners/telaagenda.jpg";
  static const String defaultAvatar =
      "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92";
  static const String nomeLocal = "Easebase";
  static const String bannerInitial = "imagesOfApp/bannerInitital.jpeg";
  static const String urlLogo = "imagesOfApp/barbeariaLogo.png";
  static Color primaryColor = const Color.fromRGBO(32, 32, 32, 1);
  static Color secondaryColor = const Color.fromRGBO(144, 144, 144, 1);
  static Color contraPrimaryColor = const Color.fromRGBO(255, 255, 255, 1);

  //manychat
  static const String myManyToken = "1438889:178a28fe8cd1db32c7fbd2e27a0c4415";
  static const String urlKeyManyChatFunctions =
      "https://us-central1-lionsbarber-easecorte.cloudfunctions.net/manyChatProxy";
  static const int AtualizarHorarioLembreteAoAgendar = 11266886;
  static const int enviarLembreteParaAtrasados = 11268302; 
  static const String fieldIdAgendamentoMensagem = "ReminderTime";
  static const String fieldIdLembreteAtrasados ="ramdomText_lembrete";
}
