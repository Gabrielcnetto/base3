import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SemItens extends StatelessWidget {
  const SemItens({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.height * 0.2,
              child: Image.asset(
                "imagesOfApp/semhistoricodecortes.jpeg",
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                "Este Dia ainda não tem horários preenchidos.",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      fontSize: 13),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Text(
                "Assim que o primeiro for agendado, a lista aparecerá aqui.",
                
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 13),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
