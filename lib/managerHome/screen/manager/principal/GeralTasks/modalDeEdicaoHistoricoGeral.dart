import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/atualizacaodePrecoManager.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/changeHourAndData.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class ModalDeEdicaoHistoricoGeral extends StatefulWidget {
  final CorteClass infoRoutes;
  const ModalDeEdicaoHistoricoGeral({
    super.key,
    required this.infoRoutes,
  });

  @override
  State<ModalDeEdicaoHistoricoGeral> createState() =>
      _ModalDeEdicaoHistoricoGeralState();
}

class _ModalDeEdicaoHistoricoGeralState
    extends State<ModalDeEdicaoHistoricoGeral> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getFolga;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    //nome do cliente - inico
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nome do Cliente",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.infoRoutes.clientName}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Nome do cliente - fim
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Valor",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "R\$${widget.infoRoutes.totalValue},00",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (ctx) {
                                      return AtualizacaoDePrecoDoManager(
                                        corteWidget: widget.infoRoutes,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade500,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //CONTAINER DA DURACAO - INICIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Duração",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.infoRoutes.barba == true ? "60min" : "30min"}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //CONTAINER DA DURACAO - FIM
                    //CONTAINER DO PROFISSIONAL - INCIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profissional",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${widget.infoRoutes.profissionalSelect}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //CONTAINER DO PROFISSIONAL - FIM
                    //CONTAINER DO DATA/HORA - INICIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Data/Hora",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            //"${DateFormat('dd/MM/yyyy').format(widget.infoRoutes.diaCorte)} - ${widget.infoRoutes.horarioCorte}",
                            "${widget.infoRoutes.DiaDoCorte} de ${widget.infoRoutes.NomeMes} - ${widget.infoRoutes.horarioCorte}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //CONTAINER DO DATA/HORA - FIM
                  ],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade200),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Comanda nº ${widget.infoRoutes.ramdomCode}",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
