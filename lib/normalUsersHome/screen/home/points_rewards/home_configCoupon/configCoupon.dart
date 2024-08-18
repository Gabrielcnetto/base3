import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class ConfigCouponScreen extends StatefulWidget {
  const ConfigCouponScreen({super.key});

  @override
  State<ConfigCouponScreen> createState() => _ConfigCouponScreenState();
}

class _ConfigCouponScreenState extends State<ConfigCouponScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pontuacaoFinal;
    loadcupomValue();
    PontosPorCortes;
    loadpossibilidadeCupom();
    setControlerAtualPontuacao();
  }

  bool isLoading = false;
  int? pontuacaoFinal;
  Future<void> loadcupomValue() async {
    setState(() {
      isLoading = true;
    });
    try {
      int? pontuacaoDatabase = await CupomProvider().getCupons();
      setState(() async {
        pontuacaoFinal = pontuacaoDatabase;
        setControlerAtualPontuacao();
        await loadpossibilidadeCupom();
        isLoading = false;
      });
    } catch (e) {
      print("ao atualizar geral:$e");
    }
  }

  //bool do database
  bool PontosPorCortes = false;
  Future<void> loadpossibilidadeCupom() async {
    setState(() {
      isLoading = true;
    });
    try {
      bool? valorBoolDatabase = await CupomProvider().getPossivelUsarCupom();
      setState(() {
        PontosPorCortes = valorBoolDatabase ?? false;
        isLoading = false;
      });
      print("o valor do database bool ficou:$PontosPorCortes");
    } catch (e) {
      print("ao atualizar geral do bool:$e");
    }
  }

  void setControlerAtualPontuacao() {
    setState(() {
      pointsControler.text = pontuacaoFinal != null ?"${pontuacaoFinal}" : "";
    });
  }

  final pointsControler = TextEditingController();

  Future<void> alterarPossibilidadeDeUso() async {
    bool? valorDefinido;
    setState(() {
      PontosPorCortes = !PontosPorCortes!;
      valorDefinido = PontosPorCortes;
    });
    try {
      await Provider.of<CupomProvider>(context, listen: false)
          .AtivarOuDesativarUsoDeCupom(Possivel: valorDefinido ?? false);
    } catch (e) {
      print("ao alterar a possibilidade deu isto:$e");
    }
  }

  Future<void> salvarPontuacao() async {
    int valorEnviar = int.parse(
      pointsControler.text,
    );
    try {
      if (valorEnviar >= 20) {
        await Provider.of<CupomProvider>(context, listen: false)
            .setValorResgateCuponsGerenteFunctions(
          points: valorEnviar,
        );
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Pontos para resgate atualizado",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                content: Text(
                  "Agora os clientes precisam alcançar uma meta para ativar a promoção.",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(
                        AppRoutesApp.HomeScreen01,
                      );
                    },
                    child: Text(
                      "Fechar",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      } else if (valorEnviar == 0) {
        return;
      } else {
        await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text(
                  "Coloque uma quantia maior de pontos",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
                content: Text(
                  "Coloque 20 pontos ou mais para resgate",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.black54,
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Fechar",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print("houve um erro para salvar a quantia de pontos");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading == false
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "Ativação de cupons",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                child: Text(
                                  "Opções disponíveis",
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      "Ative para usar",
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade500,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size: 15,
                                      color: Colors.grey.shade500,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Troque pontos por cortes.",
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: alterarPossibilidadeDeUso,
                                child: Icon(
                                  PontosPorCortes == true
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  size: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (PontosPorCortes == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.45,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 15),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pontos Necessários",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Quantos pontos um cliente precisará\npara conseguir usar os benefício?",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // meio do collun
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.stars,
                                                size: 60,
                                              ),
                                              Text(
                                                "Digite:",
                                                style: GoogleFonts.poppins(
                                                  textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                  width: 0.4,
                                                  color: Colors.grey.shade300,
                                                )),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.15,
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller: pointsControler,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly, // Aceita apenas dígitos
                                                ],
                                                keyboardType:
                                                    TextInputType.number,
                                                maxLength: 3,
                                                decoration: InputDecoration(
                                                  floatingLabelAlignment:
                                                      FloatingLabelAlignment
                                                          .center,
                                                  border: InputBorder.none,
                                                  label: Text(
                                                    "Clique para digitar",
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.openSans(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: salvarPontuacao,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.blue.shade600,
                                        ),
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                          horizontal: 8,
                                        ),
                                        child: Text(
                                          "Salvar",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
