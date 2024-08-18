import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/normalUsersHome/screen/home/homeScreen01.dart';

class ComponentDataRewards extends StatefulWidget {
  const ComponentDataRewards({super.key});

  @override
  State<ComponentDataRewards> createState() => _ComponentDataRewardsState();
}

class _ComponentDataRewardsState extends State<ComponentDataRewards> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pontuacaoMeta;
    loadcupomValue();
  }

  int? pontuacaoMeta;
  Future<void> loadcupomValue() async {
    try {
      int? pontuacaoDatabase = await CupomProvider().getCupons();
      setState(() async {
        pontuacaoMeta = pontuacaoDatabase;
        await loadpoints();
        CalculoQuantosFaltam();
        calcularPorcentagemFalta();
      });
    } catch (e) {
      print("ao atualizar geral:$e");
    }
  }

  int? pontuacaoTotalCliente;
  Future<void> loadpoints() async {
    print("entrei na load da pontuacao");
    int? pointsDB = await MyProfileScreenFunctions().getUserPontuation();

    setState(() {
      pontuacaoTotalCliente = pointsDB;
    });
  }

  //funcoes para os calculos para liberar o uso - inicio
  int quantosFaltam = 0;
  void CalculoQuantosFaltam() {
    int meusPontos = pontuacaoTotalCliente ?? 0;
    int pontosParaAtivar = pontuacaoMeta ?? 0;
    setState(() {
      quantosFaltam = pontosParaAtivar -= meusPontos;
    });
  }

  bool liberadoParaResgate = false;
  double calcularPorcentagemFalta() {
    if (pontuacaoMeta == null ||
        pontuacaoTotalCliente == null ||
        pontuacaoMeta == 0) {
      return 0.0;
    }

    double percent = (pontuacaoTotalCliente! / pontuacaoMeta!) * 100;
    if (percent >= 99) {
      setState(() {
        liberadoParaResgate = true;
      });
    }
    print("#555 valorzin final:$percent");

    return percent.clamp(0.0, 100.0) / 100.0;
  }

  //funcoes para os calculos para liberar o uso - fim
  void showModalRegras() {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
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
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  child: Text(
                    "Regras da Troca de pontos",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Text(
                    "Você poderá trocar seus pontos por um corte grátis quando alcançar a quantidade necessária definida pela ${Estabelecimento.nomeLocal}. Ao usá-los, seus pontos serão reduzidos e você começará a acumular novamente após o próximo agendamento. Agende com mais frequência para atingir a meta mais rapidamente.",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resgate seus pontos',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      'Seus benefícios por acumular',
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.17,
                          height: MediaQuery.of(context).size.height * 0.083,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.3,
                              color: Colors.grey.shade400,
                            ),
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            "${pontuacaoTotalCliente ?? 0}",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset(
                              "imagesOfApp/coroa.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                // color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            child: Stack(
                              children: [
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade300,
                                  value: 1.0,
                                ),
                                LinearProgressIndicator(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.green.shade600,
                                  value: calcularPorcentagemFalta(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Image.asset(
                            "imagesOfApp/trophy.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        liberadoParaResgate == true
                            ? "Você já pode resgatar o prêmio!"
                            : "Colete ${quantosFaltam ?? 0} pontos para resgatar o prêmio",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 0.3,
              color: Colors.grey.shade200,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.elliptical(25, 25),
              bottomRight: Radius.elliptical(25, 25),
              topLeft: Radius.elliptical(25, 25),
              topRight: Radius.elliptical(25, 25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.orange.shade400,
                      Colors.orangeAccent.shade700,
                    ], // Cores do gradiente
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ).createShader(bounds);
                },
                child: Text(
                  "${pontuacaoMeta ?? 0}",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.w800,
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Text(
                      "Corte Gratuito",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "Alcance esta quantia de pontos",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        "E Troque eles por um corte 100% grátis!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: showModalRegras,
                child: Text(
                  "Veja as regras...",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (liberadoParaResgate == true) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext ctx) {
                      return const HomeScreen01(
                        selectedIndex: 1,
                        cupomIsAcitve: true,
                      );
                    }),
                        (Route<dynamic> route) =>
                            false // Remove todas as rotas anteriores
                        );
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: liberadoParaResgate == true
                        ? LinearGradient(
                            colors: [
                              Colors.orange.shade400,
                              Colors.orangeAccent.shade700,
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Colors.grey.shade400,
                              Colors.grey.shade700,
                            ],
                          ),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (liberadoParaResgate == false)
                        Icon(
                          Icons.lock,
                          size: 15,
                          color: Colors.grey.shade800,
                        ),
                      if (liberadoParaResgate == false)
                        const SizedBox(
                          width: 5,
                        ),
                      Text(
                        liberadoParaResgate == true
                            ? "Trocar os Pontos"
                            : 'Libera ao alcançar',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
