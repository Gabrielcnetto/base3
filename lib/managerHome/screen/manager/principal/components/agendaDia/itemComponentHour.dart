import 'dart:math';

import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/functions/providerFilterStrings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemComponentHour extends StatefulWidget {
  final CorteClass Corte;
  const ItemComponentHour({
    super.key,
    required this.Corte,
  });

  @override
  State<ItemComponentHour> createState() => _ItemComponentHourState();
}

class _ItemComponentHourState extends State<ItemComponentHour> {
  Color _generateRandomLightColor() {
    Random random = Random();
    int minBrightness = 1; // ajuste este valor para controlar o brilho mínimo
    return Color.fromARGB(
      255,
      minBrightness + random.nextInt(200 - minBrightness), // red
      minBrightness + random.nextInt(200 - minBrightness), // green
      minBrightness + random.nextInt(200 - minBrightness), // blue
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GetAndConfigprofffilter();
    setState(() {});
  }

  // Função para abrir o navegador
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  String proffGet = "";
  void GetAndConfigprofffilter() {
    setState(() {
      proffGet =
          "${Provider.of<ProviderFilterManager>(context, listen: false).filtroParaUsar}";
    });
  }

  

  @override
  Widget build(BuildContext context) {
    Color _randomColor = _generateRandomLightColor();

    return widget.Corte.isActive == true &&
            widget.Corte.isActive != false &&
            (proffGet.isEmpty || proffGet == widget.Corte.profissionalSelect)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(AppRoutesApp.ModalDeEdicao,
                    arguments: widget.Corte);
              },
              child: Container(
                key: Key(widget.Corte.id),
                decoration: BoxDecoration(
                    color: _randomColor,
                    borderRadius: BorderRadius.circular(25)),
                width: MediaQuery.of(context).size.width * 1,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.8,
                              color: Colors.grey.shade100,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "${widget.Corte.profissionalSelect}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "${Estabelecimento.nomeLocal}",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "Cliente:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.Corte.clientName}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "barba:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.Corte.barba == true ? "Inclusa" : "Não Inclusa"}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 25,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.Corte.horarioCorte}h",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      AppRoutesApp.ModalDeEdicao,
                                      arguments: widget.Corte);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Ver mais",
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      const Icon(Icons.open_in_new),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : SizedBox.shrink(
            key: Key(widget.Corte.id),
          );
  }
}
