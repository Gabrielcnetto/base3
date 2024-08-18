import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/procedimentos_extras.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class PriceEporcentagemNewPrice extends StatefulWidget {
  const PriceEporcentagemNewPrice({super.key});

  @override
  State<PriceEporcentagemNewPrice> createState() =>
      _PriceEporcentagemNewPriceState();
}

class _PriceEporcentagemNewPriceState extends State<PriceEporcentagemNewPrice> {
  //controles para armazenar os valores - inicio
  final newpriceControler = TextEditingController();
  final newBarbaPriceControler = TextEditingController();
  final PorcentagemFuncionarioControler = TextEditingController();
  //controles para armazenar os valores - fim

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLoads();
  }

  void allLoads() async {
    setState(() {
      LoadPrice();
      LoadPriceAdicionalBarba();
      LoadPercentual();
      LoadPriceAdicionalIndex2();
      LoadPriceAdicionalIndex3();
      LoadPriceAdicionalIndex4();
      LoadPriceAdicionalIndex5();
    });
  }

  //AQUI TODAS AS VARIAVEIS USADAS - INICIO
  int? atualPrice;
  int barbaPriceFinal = 0;
  int? loadPercentual;
  //AQUI TODAS AS VARIAVEIS USADAS - FIM

  //TODOS AS FUNCOES DE LOADS - INICIO
  int number1priceCorteNormal = 0;
  int number2priceCorteNormal = 0;
  String ValorCorteFinal = "";
  void concatenarValoresCorteNormal() {
    setState(() {
      String concatenatedNumber =
          "${number1priceCorteNormal}${number2priceCorteNormal}";
      ValorCorteFinal = concatenatedNumber;
    });
    print("#9 o valor final: ${ValorCorteFinal}");
  }

  void aumentarNumbero1PriceCorteNormal() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceCorteNormal == 9) {
      setState(() {
        number1priceCorteNormal = 0;
      });
    }
    setState(() {
      number1priceCorteNormal += 1;
      concatenarValoresCorteNormal();
    });
    print("valor final:${number1priceCorteNormal}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoPadraoCorte();
  }

  void DiminuirNumbero1PriceCorteNormal() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceCorteNormal == 0) {
      return;
    }
    if (number1priceCorteNormal >= 1) {
      setState(() {
        number1priceCorteNormal -= 1;
        concatenarValoresCorteNormal();
      });
    }
    print("valor final:${number1priceCorteNormal}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoPadraoCorte();
  }

  void aumentarNumbero2PriceCorteNormal() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceCorteNormal == 9) {
      setState(() {
        number2priceCorteNormal = 0;
      });
    }
    setState(() {
      number2priceCorteNormal += 1;
      concatenarValoresCorteNormal();
    });
    print("valor final:${number2priceCorteNormal}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoPadraoCorte();
  }

  void DiminuirNumbero2PriceCorteNormal() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceCorteNormal == 0) {
      return;
    }
    if (number2priceCorteNormal >= 1) {
      setState(() {
        number2priceCorteNormal -= 1;
        concatenarValoresCorteNormal();
      });
    }
    print("valor final:${number2priceCorteNormal}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoPadraoCorte();
  }

  Future<void> LoadPrice() async {
    int? priceDB = await ManagerScreenFunctions().getPriceCorte();
    print("pegamos a data do databse");

    setState(() {
      atualPrice = priceDB!;
    });
  }

  int number1priceAdicionalBarba = 0;
  int number2priceAdicionalBarba = 0;
  String ValorAdicionalBarba = "";
  void concatenarValoresAdicionalBarba() {
    setState(() {
      String concatenatedNumber =
          "${number1priceAdicionalBarba}${number2priceAdicionalBarba}";
      ValorAdicionalBarba = concatenatedNumber;
    });
  }

  void aumentarNumbero1AdicionalBarba() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalBarba == 9) {
      setState(() {
        number1priceAdicionalBarba = 0;
      });
    }
    setState(() {
      number1priceAdicionalBarba += 1;
      concatenarValoresAdicionalBarba();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalBarba();
  }

  void DiminuirNumbero1AdicionalBarba() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalBarba == 0) {
      return;
    }
    if (number1priceAdicionalBarba >= 1) {
      setState(() {
        number1priceAdicionalBarba -= 1;
        concatenarValoresAdicionalBarba();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalBarba();
  }

  void aumentarNumbero2priceAdicionalBarba() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalBarba == 9) {
      setState(() {
        number2priceAdicionalBarba = 0;
      });
    }
    setState(() {
      number2priceAdicionalBarba += 1;
      concatenarValoresAdicionalBarba();
    });
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoPadraoCorte();
  }

  void DiminuirNumbero2priceAdicionalBarba() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalBarba == 0) {
      return;
    }
    if (number2priceAdicionalBarba >= 1) {
      setState(() {
        number2priceAdicionalBarba -= 1;
        concatenarValoresAdicionalBarba();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalBarba();
  }

  Future<void> LoadPriceAdicionalBarba() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalBarbaCorte();
    print("pegamos a data do databse");

    setState(() {
      barbaPriceFinal = priceDB ?? 00;
    });
  }
  //percentual infos

  int percentualnumero1 = 0;
  int percentualnumero2 = 0;
  String Valorpercentualfinal = "";
  void concatenarPercentual() {
    setState(() {
      String concatenatedNumber = "${percentualnumero1}${percentualnumero2}";
      Valorpercentualfinal = concatenatedNumber;
    });
  }

  void aumentarnumero1percentual() {
    print("cliquei no aumentar preco digito 1");
    if (percentualnumero1 == 9) {
      setState(() {
        percentualnumero1 = 0;
      });
    }
    setState(() {
      percentualnumero1 += 1;
      concatenarPercentual();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPorcentagem();
  }

  void Diminuirnumero1percentual() {
    print("cliquei no aumentar preco digito 1");
    if (percentualnumero1 == 0) {
      return;
    }
    if (percentualnumero1 >= 1) {
      setState(() {
        percentualnumero1 -= 1;
        concatenarPercentual();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPorcentagem();
  }

  void aumentarnumero2percentual() {
    print("cliquei no aumentar preco digito 1");
    if (percentualnumero2 == 9) {
      setState(() {
        percentualnumero2 = 0;
      });
    }
    setState(() {
      percentualnumero2 += 1;
      concatenarPercentual();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPorcentagem();
  }

  void Diminuirnumero2percentual() {
    print("cliquei no aumentar preco digito 1");
    if (percentualnumero2 == 0) {
      return;
    }
    if (percentualnumero2 >= 1) {
      setState(() {
        percentualnumero2 -= 1;
        concatenarPercentual();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPorcentagem();
  }

  Future<void> LoadPercentual() async {
    int? priceDB = await ManagerScreenFunctions().getPorcentagemFuncionario();
    print("pegamos a data do databse");

    setState(() {
      loadPercentual = priceDB!;
    });
  }

  int number1priceAdicionalIndex2 = 0;
  int number2priceAdicionalIndex2 = 0;
  String ValorAdicionalIndex2 = "";
  void concatenarValoresAdicionalIndex2() {
    setState(() {
      String concatenatedNumber =
          "${number1priceAdicionalIndex2}${number2priceAdicionalIndex2}";
      ValorAdicionalIndex2 = concatenatedNumber;
    });
  }

  void aumentarNumbero1AdicionalIndex2() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex2 == 9) {
      setState(() {
        number1priceAdicionalIndex2 = 0;
      });
    }
    setState(() {
      number1priceAdicionalIndex2 += 1;
      concatenarValoresAdicionalIndex2();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex2();
  }

  void DiminuirNumbero1AdicionalIndex2() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex2 == 0) {
      return;
    }
    if (number1priceAdicionalIndex2 >= 1) {
      setState(() {
        number1priceAdicionalIndex2 -= 1;
        concatenarValoresAdicionalIndex2();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex2();
  }

  void aumentarNumbero2priceAdicionalIndex2() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex2 == 9) {
      setState(() {
        number2priceAdicionalIndex2 = 0;
      });
    }
    setState(() {
      number2priceAdicionalIndex2 += 1;
      concatenarValoresAdicionalIndex2();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex2();
  }

  void DiminuirNumbero2priceAdicionalIndex2() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex2 == 0) {
      return;
    }
    if (number2priceAdicionalIndex2 >= 1) {
      setState(() {
        number2priceAdicionalIndex2 -= 1;
        concatenarValoresAdicionalIndex2();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex2();
  }

  int? index2Value;
  Future<void> LoadPriceAdicionalIndex2() async {
     int? priceDB = await ManagerScreenFunctions().getAdicionalindex2();
     print("pegamos a data do databse");
    
    setState(() {
      index2Value = priceDB ?? 00;
    });
  }

  int number1priceAdicionalIndex3 = 0;
  int number2priceAdicionalIndex3 = 0;
  String ValorAdicionalIndex3 = "";
  void concatenarValoresAdicionalIndex3() {
    setState(() {
      String concatenatedNumber =
          "${number1priceAdicionalIndex3}${number2priceAdicionalIndex3}";
      ValorAdicionalIndex3 = concatenatedNumber;
    });
  }

  void aumentarNumbero1AdicionalIndex3() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex3 == 9) {
      setState(() {
        number1priceAdicionalIndex3 = 0;
      });
    }
    setState(() {
      number1priceAdicionalIndex3 += 1;
      concatenarValoresAdicionalIndex3();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex3();
  }

  void DiminuirNumbero1AdicionalIndex3() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex3 == 0) {
      return;
    }
    if (number1priceAdicionalIndex3 >= 1) {
      setState(() {
        number1priceAdicionalIndex3 -= 1;
        concatenarValoresAdicionalIndex3();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex3();
  }

  void aumentarNumbero2priceAdicionalIndex3() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex3 == 9) {
      setState(() {
        number2priceAdicionalIndex3 = 0;
      });
    }
    setState(() {
      number2priceAdicionalIndex3 += 1;
      concatenarValoresAdicionalIndex3();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex3();
  }

  void DiminuirNumbero2priceAdicionalIndex3() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex3 == 0) {
      return;
    }
    if (number2priceAdicionalIndex3 >= 1) {
      setState(() {
        number2priceAdicionalIndex3 -= 1;
        concatenarValoresAdicionalIndex3();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex3();
  }

  int? index3Value;
  Future<void> LoadPriceAdicionalIndex3() async {
     int? priceDB = await ManagerScreenFunctions().getAdicionalindex3();
     print("pegamos a data do databse");
    
    setState(() {
      index3Value = priceDB ?? 00;
    });
  }

  int number1priceAdicionalIndex4 = 0;
  int number2priceAdicionalIndex4 = 0;
  String ValorAdicionalIndex4 = "";
  void concatenarValoresAdicionalIndex4() {
    setState(() {
      String concatenatedNumber =
          "${number1priceAdicionalIndex4}${number2priceAdicionalIndex4}";
      ValorAdicionalIndex4 = concatenatedNumber;
    });
  }

  void aumentarNumbero1AdicionalIndex4() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex4 == 9) {
      setState(() {
        number1priceAdicionalIndex4 = 0;
      });
    }
    setState(() {
      number1priceAdicionalIndex4 += 1;
      concatenarValoresAdicionalIndex4();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex4();
  }

  void DiminuirNumbero1AdicionalIndex4() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex4 == 0) {
      return;
    }
    if (number1priceAdicionalIndex4 >= 1) {
      setState(() {
        number1priceAdicionalIndex4 -= 1;
        concatenarValoresAdicionalIndex4();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex4();
  }

  void aumentarNumbero2priceAdicionalIndex4() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex4 == 9) {
      setState(() {
        number2priceAdicionalIndex4 = 0;
      });
    }
    setState(() {
      number2priceAdicionalIndex4 += 1;
      concatenarValoresAdicionalIndex4();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex4();
  }

  void DiminuirNumbero2priceAdicionalIndex4() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex4 == 0) {
      return;
    }
    if (number2priceAdicionalIndex4 >= 1) {
      setState(() {
        number2priceAdicionalIndex4 -= 1;
        concatenarValoresAdicionalIndex4();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex4();
  }
  int? index4Value;
  Future<void> LoadPriceAdicionalIndex4() async {
     int? priceDB = await ManagerScreenFunctions().getAdicionalindex4();
     print("pegamos a data do databse");
    
    setState(() {
      index4Value = priceDB ?? 00;
    });
  }

  int number1priceAdicionalIndex5 = 0;
  int number2priceAdicionalIndex5 = 0;
  String ValorAdicionalIndex5 = "";
  void concatenarValoresAdicionalIndex5() {
    setState(() {
      String concatenatedNumber =
          "${number1priceAdicionalIndex5}${number2priceAdicionalIndex5}";
      ValorAdicionalIndex5 = concatenatedNumber;
    });
  }

  void aumentarNumbero1AdicionalIndex5() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex5 == 9) {
      setState(() {
        number1priceAdicionalIndex5 = 0;
      });
    }
    setState(() {
      number1priceAdicionalIndex5 += 1;
      concatenarValoresAdicionalIndex5();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex5();
  }

  void DiminuirNumbero1AdicionalIndex5() {
    print("cliquei no aumentar preco digito 1");
    if (number1priceAdicionalIndex5 == 0) {
      return;
    }
    if (number1priceAdicionalIndex5 >= 1) {
      setState(() {
        number1priceAdicionalIndex5 -= 1;
        concatenarValoresAdicionalIndex5();
      });
    }

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex5();
  }

  void aumentarNumbero2priceAdicionalIndex5() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex5 == 9) {
      setState(() {
        number2priceAdicionalIndex5 = 0;
      });
    }
    setState(() {
      number2priceAdicionalIndex5 += 1;
      concatenarValoresAdicionalIndex5();
    });

    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex5();
  }

  void DiminuirNumbero2priceAdicionalIndex5() {
    print("cliquei no aumentar preco digito 1");
    if (number2priceAdicionalIndex5 == 0) {
      return;
    }
    if (number2priceAdicionalIndex5 >= 1) {
      setState(() {
        number2priceAdicionalIndex5 -= 1;
        concatenarValoresAdicionalIndex5();
      });
    }
    print("valor final:${number2priceAdicionalBarba}");
    Navigator.of(context).pop(); // Fechar o BottomSheet atual
    modalParaAtualizarPrecoAdicionalProcedimentoIndex5();
  }

  int? index5Value;
  Future<void> LoadPriceAdicionalIndex5() async {
     int? priceDB = await ManagerScreenFunctions().getAdicionalindex5();
     print("pegamos a data do databse");
    
    setState(() {
      index5Value = priceDB ?? 00;
    });
  }
  //TODAS AS FUNCOES DE LOADS - FIM

  //TODAS AS FUNCOES DE LOADS - FIM

  //aqui os showialogs para mostrar e confirmar a escolha - INICIO
  //DIALOG DO PRECO - INICIO
  void showDialogAndSubmitPrecoCorte() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o preço?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorCorteFinal) ?? 0;
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setNewprice(newprice: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar preço",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showDialogAndSubmitPrecoAdicionalBarba() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o Valor Adicional da barba?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorAdicionalBarba) ?? 0;
                  Provider.of<ManagerScreenFunctions>(context, listen: false)
                      .setAdicionalPriceBarba(barbaPrice: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.ManagerScreenView);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showDialogAndSubmitPrecoAdicionalIndex2() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
                "Atualizar o Valor Adicional de ${procedimentosLista[2].name}?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorAdicionalIndex2) ?? 0;
                  await Provider.of<ManagerScreenFunctions>(context,
                          listen: false)
                      .setAdicionalindex2(index2: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showDialogAndSubmitPrecoAdicionalIndex3() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
                "Atualizar o Valor Adicional de ${procedimentosLista[3].name}?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorAdicionalIndex3) ?? 0;
                  await Provider.of<ManagerScreenFunctions>(context,
                          listen: false)
                      .setAdicionalindex3(index3: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showDialogAndSubmitPrecoAdicionalIndex4() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
                "Atualizar o Valor Adicional de ${procedimentosLista[4].name}?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorAdicionalIndex4) ?? 0;
                  await Provider.of<ManagerScreenFunctions>(context,
                          listen: false)
                      .setAdicionalindex4(index4: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void showDialogAndSubmitPrecoAdicionalIndex5() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
                "Atualizar o Valor Adicional de ${procedimentosLista[5].name}?"),
            content: const Text(
                "Este valor é exibido após o cliente agendar um horário"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(ValorAdicionalIndex5) ?? 0;
                  await Provider.of<ManagerScreenFunctions>(context,
                          listen: false)
                      .setAdicionalindex5(index5: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }

  //porcentagem
  void showDialogPercentualSet() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Atualizar o Percentual?"),
            content: const Text(
                "Este valor é usado para calcular a porcentagem de funcionários"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w300, color: Colors.grey),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  int intvalue = int.tryParse(Valorpercentualfinal) ?? 0;
                  await Provider.of<ManagerScreenFunctions>(context,
                          listen: false)
                      .setPorcentagemFuncionario(porcentagem: intvalue);
                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                },
                child: Text(
                  "Salvar Adicional",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ),
            ],
          );
        });
  }
  //aqui os showialogs para mostrar e confirmar a escolha - FIM

  //aqui os showmodal para usar o teclado - inicio
  void modalParaAtualizarPrecoPadraoCorte() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor desejado",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1PriceCorteNormal,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceCorteNormal}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1PriceCorteNormal,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2PriceCorteNormal,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceCorteNormal}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2PriceCorteNormal,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoCorte,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  //modal teclado da barba
  void modalParaAtualizarPrecoAdicionalBarba() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor desejado",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1AdicionalBarba,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceAdicionalBarba}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1AdicionalBarba,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2priceAdicionalBarba,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceAdicionalBarba}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2priceAdicionalBarba,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoAdicionalBarba,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  void modalParaAtualizarPrecoAdicionalProcedimentoIndex2() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor adicional de ${procedimentosLista[2].name}",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1AdicionalIndex2,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceAdicionalIndex2}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1AdicionalIndex2,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2priceAdicionalIndex2,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceAdicionalIndex2}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2priceAdicionalIndex2,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoAdicionalIndex2,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  void modalParaAtualizarPrecoAdicionalProcedimentoIndex3() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor adicional de ${procedimentosLista[3].name}",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1AdicionalIndex3,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceAdicionalIndex3}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1AdicionalIndex3,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2priceAdicionalIndex3,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceAdicionalIndex3}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2priceAdicionalIndex3,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoAdicionalIndex3,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  void modalParaAtualizarPrecoAdicionalProcedimentoIndex4() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor adicional de ${procedimentosLista[4].name}",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1AdicionalIndex4,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceAdicionalIndex4}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1AdicionalIndex4,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2priceAdicionalIndex4,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceAdicionalIndex4}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2priceAdicionalIndex4,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoAdicionalIndex4,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  void modalParaAtualizarPrecoAdicionalProcedimentoIndex5() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para o valor adicional de ${procedimentosLista[5].name}",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "R\$  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero1AdicionalIndex5,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number1priceAdicionalIndex5}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero1AdicionalIndex5,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarNumbero2priceAdicionalIndex5,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${number2priceAdicionalIndex5}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: DiminuirNumbero2priceAdicionalIndex5,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogAndSubmitPrecoAdicionalIndex5,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  void modalParaAtualizarPorcentagem() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ajuste para a porcentagem correta",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade200.withOpacity(0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "%  ",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //digito 1 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarnumero1percentual,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${percentualnumero1}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: Diminuirnumero1percentual,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 1 - fim
                        const SizedBox(
                          width: 10,
                        ),
                        //digito 2 - inicio
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: aumentarnumero2percentual,
                                child: const Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Text(
                                  "${percentualnumero2}",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: Diminuirnumero2percentual,
                                child: const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        //digito 2 - fim
                        //digito 3 - fim
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: showDialogPercentualSet,
                child: Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade600,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Salvar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  //aqui os showmodal para usar o teclado - fim

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
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
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.blue.shade600,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Seus preços",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.blue.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  "Atualize os preços",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Color.fromRGBO(32, 32, 32, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.work,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "Porcentagem de Profissionais",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "%${loadPercentual ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Ajuste conforme a porcentagem que outros profissionais recebem por procedimento.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: modalParaAtualizarPorcentagem,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | PROCEDIMENTO 1 - INICIO
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "Corte normal",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${atualPrice ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Atualize com o preço base cobrado pelo corte em sua barbearia",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: modalParaAtualizarPrecoPadraoCorte,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | PROCEDIMENTO 1 - FIM
                //CARD DOS PROCEDIMENTOS | PROCEDIMENTO 2 (barba)- INICIO
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "Adicional Barba",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${barbaPriceFinal}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Por favor, Coloque apenas os custos adicionais dos serviços extras, além do preço inicial do corte de cabelo.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: modalParaAtualizarPrecoAdicionalBarba,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | PROCEDIMENTO 2 (barba)- FIM
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 1 - INICIO (COMEXA NO INDEX 2)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "${procedimentosLista[2].name}",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${index2Value ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Por favor, Coloque apenas os custos adicionais dos serviços extras, além do preço inicial do corte de cabelo.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap:
                                modalParaAtualizarPrecoAdicionalProcedimentoIndex2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 1 - FIM (COMEXA NO INDEX 2)
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 2 - inicio (COMEXA NO INDEX 2)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "${procedimentosLista[3].name}",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${index3Value ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Por favor, Coloque apenas os custos adicionais dos serviços extras, além do preço inicial do corte de cabelo.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap:
                                modalParaAtualizarPrecoAdicionalProcedimentoIndex3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 2 - fim (COMEXA NO INDEX 2)
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 3 - inicio (COMEXA NO INDEX 2)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "${procedimentosLista[4].name}",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${index4Value ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Por favor, Coloque apenas os custos adicionais dos serviços extras, além do preço inicial do corte de cabelo.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap:
                                modalParaAtualizarPrecoAdicionalProcedimentoIndex4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 3 - fim (COMEXA NO INDEX 2)

                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 4 - INICIO (COMEXA NO INDEX 2)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Card(
                    elevation: 5,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        topRight: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                    ),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.35,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.grey.shade100.withOpacity(0.8),
                            Colors.grey.shade200.withOpacity(0.7),
                            Colors.grey.shade300.withOpacity(0.6),
                            Colors.blue.shade100.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.elliptical(15, 15),
                          topRight: Radius.elliptical(15, 15),
                          bottomLeft: Radius.elliptical(15, 15),
                          bottomRight: Radius.elliptical(15, 15),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.paid,
                            color: Colors.black,
                            size: 30,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.elliptical(15, 15),
                                        bottomRight: Radius.elliptical(15, 15),
                                      ),
                                    ),
                                    child: Text(
                                      "${procedimentosLista[5].name}",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "R\$${index5Value ?? 0}",
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Color.fromRGBO(32, 32, 32, 1),
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Por favor, Coloque apenas os custos adicionais dos serviços extras, além do preço inicial do corte de cabelo.",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap:
                                modalParaAtualizarPrecoAdicionalProcedimentoIndex5,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.black12,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Clique para Alterar valor",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.ads_click,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                //CARD DOS PROCEDIMENTOS | LISTA DE PROCEDIMENTOS - 4 - FIM (COMEXA NO INDEX 2)
                //fim dos procedimentos

                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Estabelecimento.primaryColor,
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Icon(
          Icons.arrow_left,
          color: Estabelecimento.contraPrimaryColor,
        ),
      ),
    );
  }
}
