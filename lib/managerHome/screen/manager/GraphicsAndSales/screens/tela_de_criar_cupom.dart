import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cupomClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/confirmationCreateCupom.dart';
import 'package:provider/provider.dart';

import '../../../../../functions/cupomProvider.dart';

class CreateInfsCupom extends StatefulWidget {
  const CreateInfsCupom({super.key});

  @override
  State<CreateInfsCupom> createState() => _CreateInfsCupomState();
}

class _CreateInfsCupomState extends State<CreateInfsCupom> {
  final cupomNameControler = TextEditingController();
  final codeHashTagControler = TextEditingController();

  //funcoes de set
  DateTime? dataSelectedInModal;
  List<Horarios> _horariosLivres = hourLists;

  int selectedIndex = -1;
  Map<int, Color> itemColors = {};
  Map<int, Color> _textColor = {};
  String? hourSetForUser;

  Future<void> sendCupomForDataBase() async {
    try {
      await Provider.of<CupomProvider>(context, listen: false).postNewCoupum(
        cupomClassInfs: cupomClass(
          codigo: codeHashTagControler.text,
          name: cupomNameControler.text,
          horario: hourSetForUser ?? "",
          id: Random().nextDouble().toString(),
          isActive: true,
          multiplicador: porcentagemMultiplicada,
        ),
      );
      Navigator.of(context).push(
        DialogRoute(
            context: context,
            builder: (ctx) {
              return ConfirmCreateCupomImage(
                cupomCode: codeHashTagControler.text,
                horarioCupom: hourSetForUser ?? "",
              );
            }),
      );
    } catch (e) {
      print("ao criar o cupom deu este erro:${e}");
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Erro ao criar cupom",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
            content: Text(
              "Verifique se todas os dados foram preenchidos, tente novamente, se persistir aguarde alguns minutos",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Fechar",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ))
            ],
          );
        },
      );
    }
  }

  //funcoes da porcentagem;
  int porcentagemMultiplicada = 0;
  void transformPorcentagemMultiplicadora() {
    String finalValue = "${digito1}${digito2}";
    setState(() {
      porcentagemMultiplicada = int.parse(finalValue);
    });
    print("#98valor final: ${porcentagemMultiplicada}");
  }

  int digito1 = 0;
  int digito2 = 0;
  void aumentarDigito1() {
    if (digito1 == 9) {
      setState(() {
        digito1 = 0;
        transformPorcentagemMultiplicadora();
      });
    } else if (digito1 < 9) {
      setState(() {
        digito1 += 1;
        transformPorcentagemMultiplicadora();
      });
    }
    print("#98digito 1: ${digito1}");
  }

  void aumentarDigito2() {
    if (digito2 == 9) {
      setState(() {
        digito2 = 0;
        transformPorcentagemMultiplicadora();
      });
    } else if (digito2 < 9) {
      setState(() {
        digito2 += 1;
        transformPorcentagemMultiplicadora();
      });
    }
    print("#98digito 1: ${digito2}");
  }

  void reduzirDigito1() {
    if (digito1 == 0) {
      setState(() {
        digito1 = 0;
        transformPorcentagemMultiplicadora();
      });
    } else if (digito1 >= 1) {
      setState(() {
        digito1 -= 1;
        transformPorcentagemMultiplicadora();
      });
    }
    print("####14${porcentagemMultiplicada}");
  }

  void reduzirDigito2() {
    if (digito2 == 0) {
      setState(() {
        digito2 = 0;
        transformPorcentagemMultiplicadora();
      });
    } else if (digito2 >= 1) {
      setState(() {
        digito2 -= 1;
        transformPorcentagemMultiplicadora();
      });
    }
    print("####14${porcentagemMultiplicada}");
  }

  //modal confirmation
  void showModalConfirmation() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Confirme as informações",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: const Color.fromARGB(255, 171, 168, 168).withOpacity(0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //NOME DO CUPOM - INICIO

                    Row(
                      children: [
                        Text(
                          "Nome do cupom:",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${cupomNameControler.text ?? "pendente"}",
                        ),
                      ],
                    ),
                    //NOME DO CUPOM - FIM
                    //HORARIO DO CUPOM - INICIO

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Horário para ser ativado:",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${hourSetForUser ?? "pendente"}",
                          ),
                        ],
                      ),
                    ),
                    //HORARIO DO CUPOM - FIM
                    //porcentagem DO CUPOM - INICIO

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Multiplica por:",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${porcentagemMultiplicada ?? 0}x",
                          ),
                        ],
                      ),
                    ),
                    //porcentagem DO CUPOM - FIM
                    //porcentagem DO CUPOM - INICIO

                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Text(
                            "Código de ativação:",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${codeHashTagControler.text ?? "pendente"}",
                          ),
                        ],
                      ),
                    ),
                    //porcentagem DO CUPOM - FIM
                  ],
                ),
              ),
              InkWell(
                onTap: sendCupomForDataBase,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Estabelecimento.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "Confirmar e criar cupom",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Estabelecimento.contraPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 30,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Vamos criar seu cupom.",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                              "Ao adicionar as informações novas etapas aparecerão",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                //ETAPAS
                const SizedBox(
                  height: 30,
                ),
                // ETAPA 1 - NOME DO CUPOM (MAXIMO 5 DIGITOS) - INICIO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Qual o nome do cupom?",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.9,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        maxLength: 15,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        controller: cupomNameControler,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            "Insira um nome",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // ETAPA 1 - NOME DO CUPOM (MAXIMO 5 DIGITOS) - FIM
                // ETAPA 2 - Horario - inicio
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Qual horário poderá ser ativado?",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: GridView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _horariosLivres.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 2.3,
                            childAspectRatio: 2.3,
                          ),
                          itemBuilder: (BuildContext ctx, int index) {
                            Color color = selectedIndex == index
                                ? Colors.amber
                                : Estabelecimento.primaryColor;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedIndex =
                                      selectedIndex == index ? -1 : index;

                                  hourSetForUser =
                                      _horariosLivres[index].horario;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 3),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.elliptical(20, 20),
                                      bottomRight: Radius.elliptical(20, 20),
                                      topLeft: Radius.elliptical(20, 20),
                                      topRight: Radius.elliptical(20, 20),
                                    ),
                                    color: color,
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    "${_horariosLivres[index].horario}",
                                    style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 15,
                                    )),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // ETAPA 2 - Horario - fim
                //ETAPA DA PORCENTAGEM - INICIO
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Quantos Vezes ele multiplica os pontos?",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.elliptical(20, 20),
                      bottomRight: Radius.elliptical(20, 20),
                      topLeft: Radius.elliptical(20, 20),
                      bottomLeft: Radius.elliptical(20, 20),
                    ),
                    border: Border.all(
                      width: 0.3,
                      color: Colors.blue.shade600,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(20, 20),
                            bottomLeft: Radius.elliptical(20, 20),
                          ),
                        ),
                        child: const Icon(
                          Icons.one_x_mobiledata,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // digito 1
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: aumentarDigito1,
                                    child: const Icon(
                                      Icons.arrow_drop_up,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${digito1}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: reduzirDigito1,
                                    child: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              //digito 2
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: aumentarDigito2,
                                    child: const Icon(
                                      Icons.arrow_drop_up,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${digito2}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: reduzirDigito2,
                                    child: const Icon(
                                      Icons.arrow_drop_down,
                                      size: 45,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //ETAPA DA PORCETANGEM - FIM
                const SizedBox(
                  height: 15,
                ),

                // ETAPA 3 - CODIGO # - INICIO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Crie um identificador # para o cupom:",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 0.9,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'#')),
                        ],
                        maxLength: 7,
                        maxLengthEnforcement: MaxLengthEnforcement
                            .enforced, // Força o limite máximo

                        controller: codeHashTagControler,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            "Insira um código de até 7 digitos(Sem inserir simbolo #)",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                // ETAPA 3 - CODIGO # - FIM

                //end botao de finaliar
                InkWell(
                  onTap: showModalConfirmation,
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Estabelecimento.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        "CRIAR CUPOM AGORA",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Estabelecimento.contraPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
