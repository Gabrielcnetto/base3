import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/StreamHaveItems.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/header.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfissionalCode extends StatefulWidget {
  final CorteClass corte;
  const ProfissionalCode({
    super.key,
    required this.corte,
  });

  @override
  State<ProfissionalCode> createState() => _ProfissionalCodeState();
}

class _ProfissionalCodeState extends State<ProfissionalCode> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MonthCorte;
    LoadPrice();
    setDateCort();
    print("o barbeiro selecionado é ${widget.corte.profissionalSelect}");
    LoadMinutesDatabase();
    LoadSecondsDatabase();
  }

  //get do tempo da barba - inicio
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
  //get do tempo da barba - fim

  String? MonthCorte;
  Future<void> setDateCort() async {
    await initializeDateFormatting('pt_BR');
    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(widget.corte.diaCorte);
    setState(() {
      MonthCorte = monthName;
    });
  }

  Future<void> desmarcarCorte(
      BuildContext context, CorteClass corteparausar) async {
    print("entramos no showdialog");
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Gostaria de cancelar o seu agendamento?'),
            content: const Text(
                "Desmarcar permitirá que você reagende para outros horários disponíveis."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o diálogo
                  // Adicione a lógica para a primeira opção aqui
                },
                child: Text(
                  'Manter',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Provider.of<CorteProvider>(context, listen: false)
                      .desmarcarCorte(corteparausar);
                  Provider.of<CorteProvider>(context, listen: false)
                      .desmarcarCorteMeus(corteparausar);
                  Provider.of<CorteProvider>(context, listen: false)
                      .desmarcarAgendaManager(corteparausar);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  'Desmarcar',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showModalWithCode() {
    showModalBottomSheet(
        //isDismissible: true,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          String numberGeral = widget.corte.ramdomCode.toString();
          var num1 = int.parse(numberGeral[0]);
          var num2 = int.parse(numberGeral[1]);
          var num3 = int.parse(numberGeral[2]);
          var num4 = int.parse(numberGeral[3]);
          var num5 = int.parse(numberGeral[4]);
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.65,
            child: Container(
              padding: const EdgeInsets.only(
                top: 15,
                left: 20,
                right: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Código Único",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Apresente o código abaixo ao seu barbeiro antes de realizar seu procedimento.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        //DIGITO 1 - INICIO
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            "${num1}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Estabelecimento.contraPrimaryColor,
                              fontSize: 16,
                            )),
                          ),
                        ),
                        //DIGITO 1 - FIM
                        //DIGITO 2 - INICIO
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            "${num2}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Estabelecimento.contraPrimaryColor,
                              fontSize: 16,
                            )),
                          ),
                        ),
                        //DIGITO 2 - FIM

                        //DIGITO 3 - INICIO
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            "${num3}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Estabelecimento.contraPrimaryColor,
                              fontSize: 16,
                            )),
                          ),
                        ),
                        //DIGITO 3 - FIM
                        //DIGITO 4 - INICIO
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            "${num4}",
                            style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Estabelecimento.contraPrimaryColor,
                              fontSize: 16,
                            )),
                          ),
                        ),
                        //DIGITO 4 - FIM

                        //DIGITO 5 - INICIO
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: Text(
                            "${num5}",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Estabelecimento.contraPrimaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        //DIGITO 5 - FIM
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 50,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Estabelecimento.primaryColor,
                        ),
                        child: Text(
                          "Voltar",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //BOTAO DE CANCELAR O HORARIO
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () {
                        desmarcarCorte(context, widget.corte);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 1.3,
                        height: 50,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.redAccent,
                        ),
                        child: Text(
                          "Desmarcar Horário",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  int? atualPrice;

  Future<void> LoadPrice() async {
    int? priceDB = await ManagerScreenFunctions().getPriceCorte();
    print("pegamos a data do databse");

    setState(() {
      atualPrice = priceDB!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widhTela = MediaQuery.of(context).size.width;
    double heighTela = MediaQuery.of(context).size.width;

    return Positioned(
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 2,
        child: Container(
          width: widhTela,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          height: widhTela / 2.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(
              width: 0.2,
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Próximo agendamento",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                      color: Estabelecimento.secondaryColor,
                      fontWeight: FontWeight.w500,
                    )),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Estabelecimento.secondaryColor,
                    size: 20,
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: Container(
                      width: 90,
                      height: 90,
                      child: widget.corte.profissionalSelect != "Não Definido"
                          ? Image.asset(
                              widget.corte.profissionalSelect ==
                                      "${profList[0].nomeProf}"
                                  ? "imagesOfApp/barbeiros/fotobarbeiro1.jpeg"
                                  : widget.corte.profissionalSelect ==
                                          "${profList[1].nomeProf}"
                                      ? "imagesOfApp/barbeiros/foto02.jpg"
                                      : widget.corte.profissionalSelect ==
                                              "${profList[2].nomeProf}"
                                          ? "imagesOfApp/barbeiros/foto03.jpeg"
                                          : "",
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "imagesOfApp/barbeiros/naodefinidoimage.jpeg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Profissional:",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "${widget.corte.profissionalSelect}",
                            style: GoogleFonts.openSans(),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.corte.detalheDoProcedimento,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.corte.DiaDoCorte} de ${widget.corte.NomeMes} - ${widget.corte.horarioCorte}",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green.shade200.withOpacity(0.4),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Text(
                              widget.corte.pagoComCupom ? "Grátis":
                              widget.corte.pagoComCreditos || widget.corte.feitoporassinatura? 'PAGO' :
                              "R\$${widget.corte.totalValue ?? 00},00",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: Colors.green),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Estabelecimento.primaryColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: showModalWithCode,
                                  child: Text(
                                    "Alterar",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                          color: Estabelecimento
                                              .contraPrimaryColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottom: 0,
      left: 25,
      right: 25,
    );
  }
}
