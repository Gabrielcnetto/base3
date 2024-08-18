import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/providerFilterStrings.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/agendaDia/diaListComponent.dart';
import 'package:easebase/rotas/Approutes.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CortesHojeLista extends StatefulWidget {
  const CortesHojeLista({super.key});

  @override
  State<CortesHojeLista> createState() => _CortesHojeListaState();
}

class _CortesHojeListaState extends State<CortesHojeLista> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).horariosListLoad;
    print("o nome do 1 é: ${profissional2}");
    filterProfissional1;
  }

  final String profissional1 = profList[0].nomeProf;
  final String profissional2 = profList[1].nomeProf;

  bool filterProfissional1 = false;
  bool filterProfissional2 = false;

  returnCorretct() {
    try {
      if (filterProfissional1 == true) {
        setState(() {
          Provider.of<ProviderFilterManager>(context, listen: false)
              .filtroParaUsar = profissional1;
        });
      } else if (filterProfissional2 == true) {
        setState(() {
          Provider.of<ProviderFilterManager>(context, listen: false)
              .filtroParaUsar = profissional2;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void setFilterProfissional1() async {
    setState(() {
      filterProfissional1 = true;

      filterProfissional2 = false;
      returnCorretct();
    });

    Navigator.of(context).pushReplacementNamed(
      AppRoutesApp.ManagerScreenView,
    );
  }

  void setFilterProfissional2() {
    try {
      setState(() {
        filterProfissional2 = true;
        filterProfissional1 = false;

        returnCorretct();
      });
      Navigator.of(context).pushReplacementNamed(
        AppRoutesApp.ManagerScreenView,
      );
    } catch (e) {
      print("sem barbeiro 2");
    }
  }

  

  void screenEncaixe() {
    Navigator.of(context).pushNamed(AppRoutesApp.EncaixeScreen);
  }

  @override
  Widget build(BuildContext context) {
    int diaAtual = DateTime.now().day;
    int mesAtual = DateTime.now().month;
    final List<Horarios> _horariosLOad =
        Provider.of<CorteProvider>(context, listen: false).horariosListLoad;
    return Padding(
      padding: const EdgeInsets.only(top:10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Agenda do dia",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 22,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Estabelecimento.primaryColor,
                          borderRadius: BorderRadius.circular(30)),
                      padding:
                          const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
                      child: Text(
                        "Dia ${diaAtual ?? "Carregando..."}/0${mesAtual ?? "Carregando..."}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    
                  ],
                ),
              ],
            ),
            const DiaListaComponent()
          ],
        ),
      ),
    );
  }
}
