import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmCancelCorte extends StatelessWidget {
  const ConfirmCancelCorte({super.key});

  @override
  Widget build(BuildContext context) {
    final widhtScreen = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: widhtScreen,
        height: heighScreen,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              bottom: 0,
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(1)),
                width: widhtScreen,
                height: heighScreen,
                child: Image.asset(
                  opacity: const AlwaysStoppedAnimation<double>(0.35),
                  Estabelecimento.bannerAgendamento,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black54),
                    padding: const EdgeInsets.all(25),
                    child: const Icon(
                      Icons.event_busy,
                      size: 42,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Horário Retirado da Agenda \n com sucesso!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: widhtScreen * 0.8,
                      padding: const EdgeInsets.symmetric(vertical: 27),
                      decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
