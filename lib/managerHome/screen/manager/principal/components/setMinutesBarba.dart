import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SetMinutesBarba extends StatefulWidget {
  const SetMinutesBarba({super.key});

  @override
  State<SetMinutesBarba> createState() => _SetMinutesBarbaState();
}

class _SetMinutesBarbaState extends State<SetMinutesBarba> {
  int minutesView = 0;

  Future<void> LoadMinutesDatabase() async {
    int? minutosDatabaseGet = await ManagerScreenFunctions().getMinutes();
    print("pegamos a data do databse");

    setState(() {
      minutesView = minutosDatabaseGet!;
      LoadSecondsDatabase();
    });
  }

  int secondsView = 0;
  Future<void> LoadSecondsDatabase() async {
    int? secondsDatabase = await ManagerScreenFunctions().getSeconds();
    print("pegamos a data do databse");

    setState(() {
      secondsView = secondsDatabase!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoadMinutesDatabase();
    LoadSecondsDatabase();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getMinutes();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getSeconds();
  }

  void aumentarMinutos() {
    setState(() {
      if (minutesView == 5) {
        minutesView = 0;
      }
      if (minutesView <= 5) {
        minutesView += 1;
      }
    });
  }

  void reduzirMinutos() {
    setState(() {
      if (minutesView == 0) {
        minutesView = 0;
      }
      if (minutesView > 1) {
        minutesView -= 1;
      }
    });
  }

  //segundos
  void aumentarSegundos() {
    setState(() {
      if (secondsView >= 9) {
        secondsView = 0;
      }
      if (secondsView <= 9) {
        secondsView += 1;
      }
    });
  }

  void reduzirSegundos() {
    setState(() {
      if (secondsView == 0) {
        secondsView = 0;
      }
      if (secondsView >= 1) {
        secondsView -= 1;
      }
    });
  }

  Future<void> setTempoBarba() async {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Adicionar Tempo extra?"),
            content: const Text(
              "Caso o cliente selecionar Cabelo + barba este tempo será informado, e também será usado para organizar a sua agenda automaticamente.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setTimerBarbaandCabelo(
                    MinutoSelecionado: minutesView,
                    segundoSelecionado: secondsView,
                  );
             Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Salvar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.only(
        top: 25,
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Adicione minutos extra",
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            "Isto é para controle e informar ao cliente quanto tempo seu serviço pode levar a mais, para manter sua agenda organizada e o cliente informado.",
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //horas - container 1 - inicio
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.7,
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300.withOpacity(0.7),
                  ),
                  child: Text(
                    "0",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                //horas - container 1 - fim
                //horas - container 2 - inicio
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.15,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.7,
                      color: Colors.grey.shade400,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey.shade300.withOpacity(0.7),
                  ),
                  child: Text(
                    "0",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                //horas - container 2 - fim
                Container(
                  child: Text(
                    ":",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                //fim do :
                //horas - container 3 - inicio
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: aumentarMinutos,
                        child: const Icon(
                          Icons.arrow_drop_up,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.7,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300.withOpacity(0.7),
                        ),
                        child: Text(
                          "${minutesView}",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: reduzirMinutos,
                        child: const Icon(
                          Icons.arrow_drop_down,
                        ),
                      ),
                    ],
                  ),
                ),
                //horas - container 3 - fim
                //horas - container 4 - inicio
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: aumentarSegundos,
                        child: const Icon(
                          Icons.arrow_drop_up,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.7,
                            color: Colors.grey.shade400,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade300.withOpacity(0.7),
                        ),
                        child: Text(
                          "${secondsView}",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: reduzirSegundos,
                        child: const Icon(
                          Icons.arrow_drop_down,
                        ),
                      ),
                    ],
                  ),
                ),
                //horas - container 4 - fim
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: setTempoBarba,
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.35,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Estabelecimento.primaryColor,
                  ),
                  child: Text(
                    "Salvar",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Estabelecimento.contraPrimaryColor,
                    )),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
