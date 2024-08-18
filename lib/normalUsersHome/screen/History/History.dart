import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/normalUsersHome/screen/History/providerLoading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).userCortesTotal;
    Provider.of<CorteProvider>(context, listen: false).loadHistoryCortes;
    print(
        "tamanho da lista carregada: ${Provider.of<CorteProvider>(context, listen: false).userCortesTotal.length}");
  }

  @override
  Widget build(BuildContext context) {
    List<CorteClass> _listaCortes =
        Provider.of<CorteProvider>(context, listen: false).userCortesTotal;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Seu Histórico de Cortes",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(32, 32, 32, 1),
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Text(
                          "Visualize o histórico de Cortes que você já realizou conosco",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color.fromRGBO(144, 144, 144, 1),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              _listaCortes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "imagesOfApp/semhistoricodecortes.jpeg",
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Realize seu Primeiro Agendamento",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: _listaCortes.map((corte) {
                        return providerLoadingHistoryList(
                          heighScren: MediaQuery.of(context).size.height,
                          widhtScreen: MediaQuery.of(context).size.width,
                          corte: corte,
                        );
                      }).toList(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
