import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/header.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/homeHeaderSemItens.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/home_noItenswithLoading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class providerLoadingHistoryList extends StatefulWidget {
  final double widhtScreen;
  final double heighScren;
  final CorteClass corte;
  const providerLoadingHistoryList({
    super.key,
    required this.corte,
    required this.heighScren,
    required this.widhtScreen,
  });

  @override
  State<providerLoadingHistoryList> createState() =>
      _providerLoadingHistoryListState();
}



class _providerLoadingHistoryListState
    extends State<providerLoadingHistoryList> {
      bool exibirInformacoes = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        width: widget.widhtScreen,
        height:exibirInformacoes ?  widget.heighScren * 0.27 : widget.heighScren * 0.13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Estabelecimento.primaryColor.withOpacity(0.2),
        ),
        child: Column(
          mainAxisAlignment:exibirInformacoes ? MainAxisAlignment.start: MainAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(25, 25),
                          topRight: Radius.elliptical(25, 25),
                          bottomLeft: Radius.elliptical(25, 25),
                          bottomRight: Radius.elliptical(25, 25),
                        ),
                        color: Estabelecimento.primaryColor.withOpacity(0.35),
                      ),
                      child: Icon(
                        Icons.history,
                        size: 25,
                        color: Estabelecimento.contraPrimaryColor,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Corte Agendado",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              "${widget.corte.DiaDoCorte} de ${widget.corte.NomeMes} de ${widget.corte.dateCreateAgendamento.year}",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      exibirInformacoes = !exibirInformacoes;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Icon(
                        exibirInformacoes
                            ? Icons.expand_more
                            : Icons.chevron_right,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (exibirInformacoes == true)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    children: [
                      //INICIO PROFF
                      Row(
                        children: [
                          Text(
                            "Profissional:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.corte.profissionalSelect}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      //FIM PROF
                      const SizedBox(
                        height: 5,
                      ),
                      //INICIO barba
                      Row(
                        children: [
                          Text(
                            "barba:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.corte.barba == true ? "Sim" : "Não"}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                      //FIM barba
   
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            "EasePoints:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.blue.shade200.withOpacity(0.4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              "+3 pontos",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
