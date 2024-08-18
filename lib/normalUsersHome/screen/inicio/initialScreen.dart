
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreenApp extends StatelessWidget {
  const InitialScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    final widhtScreen = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: widhtScreen,
          height: heighScreen,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: widhtScreen,
                  height: heighScreen / 2,
                  child: Image.asset(
                    Estabelecimento.bannerInitial,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Seja bem vindo ao Nosso App",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Estabelecimento.secondaryColor),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Agende, Verifique seus pontos e seu ranking em nossa barbearia",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Estabelecimento.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Estabelecimento.primaryColor,
        onPressed: () {
          Navigator.of(context).pushReplacementNamed(AppRoutesApp.LoginScreen01);
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          child: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
