import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/circularProgressIndicLevel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeHeaderSemLista extends StatefulWidget {
  final double widhTela;
  final double heighTela;

  const HomeHeaderSemLista({
    super.key,
    required this.heighTela,
    required this.widhTela,
  });

  @override
  State<HomeHeaderSemLista> createState() => _HomeHeaderSemListaState();
}

class _HomeHeaderSemListaState extends State<HomeHeaderSemLista> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ajustePoints();
    valorPoints;
    userProfileIsOk;
    urlImagePhoto;
    VerifyImageUser();
    userName;
    urlImageFuncion();
    pontuacaoTotalCliente;
    loadpoints();
    loadPremium();
  }

int? pontuacaoTotalCliente;
  Future<void> loadpoints() async {
    print("entrei na load da pontuacao");
    int? pointsDB = await MyProfileScreenFunctions().getUserPontuation();

    setState(() {
      pontuacaoTotalCliente = pointsDB;
    });
  }
  String? urlImagePhoto;
  Future<void> urlImageFuncion() async {
    String? number = await MyProfileScreenFunctions().getUserImage();

    if (urlImagePhoto != null) {
      print("imagem do usuario nao definidida");
    } else {
      const Text('N/A');
    }

    setState(() {
      urlImagePhoto = number;
      loadUserName();
    });
  }

  bool? userProfileIsOk;
  void VerifyImageUser() {
    if (urlImagePhoto != null) {
      setState(() {
        userProfileIsOk = true;
      });
    } else {
      setState(() {
        userProfileIsOk = false;
      });
    }
  }

  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      splitName();
    });
  }

  String? finalName;
  Future<void> splitName() async {
    List<String> partes = userName!.split(" ");
    String userFirst = partes[0];

    setState(() {
      finalName = userFirst;
    });
  }

  double valorPoints = 0;
  Future<void> ajustePoints() async {
    int PointOfClient = Provider.of<CorteProvider>(context, listen: false)
        .userCortesTotal
        .length;
    setState(() {
      valorPoints = PointOfClient.toDouble();
      valorPoints = valorPoints % 12;
    });
  }

  double calcularProgresso() {
    // Calcula o progresso com base nos pontos acumulados
    return valorPoints / 12.0;
  }
 bool? UsuarioPremium;
  Future<void> loadPremium() async {
    bool? boolDATABASE = await MyProfileScreenFunctions().getPremiumOrNot();

    setState(() {
      UsuarioPremium = boolDATABASE;
    });
  }
  @override
  Widget build(BuildContext context) {
    final tamanhoTela = MediaQuery.of(context).size;

    double heighTelaFinal = tamanhoTela.height;
    final double setHeigh = heighTelaFinal > 800
        ? heighTelaFinal / 2.3
        : heighTelaFinal < 500
            ? heighTelaFinal / 2.1
            : heighTelaFinal / 1.9;
    return Container(
        constraints: BoxConstraints(
               minHeight: setHeigh / 1.9,
          maxHeight: setHeigh / 1.9,
          minWidth: widget.widhTela,
          maxWidth: widget.widhTela,
        ),
        child: Container(
         // padding: EdgeInsets.only(top: setHeigh * 0.09),
          child: Stack(
            children: [
              Container(
                constraints: BoxConstraints(
                   minHeight: setHeigh * 0.55,
                  maxHeight: setHeigh * 0.55,
                  minWidth: widget.widhTela,
                  maxWidth: widget.widhTela,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Estabelecimento.secondaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.elliptical(60, 60),
                      bottomRight: Radius.elliptical(60, 60),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 15,
                right: 15,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                       padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            textAlign: TextAlign.center,
                            Estabelecimento.nomeLocal,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Estabelecimento.secondaryColor,
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bem-vindo(a), ${finalName ?? "..."}",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Text(
                                
                                UsuarioPremium == true ? 'Sua assinatura está ativa!': "Você Possui ${pontuacaoTotalCliente ?? 0} Pontos",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            ],
                          ),
                          CircularProgressWithImage(
                            totalCortes:
                                pontuacaoTotalCliente ?? 0,
                            progress: calcularProgresso(),
                            imageSize: widget.widhTela / 5.5,
                            widghTela: widget.widhTela,
                            imageUrl: urlImagePhoto != null
                                ? urlImagePhoto!
                                : Estabelecimento.defaultAvatar,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
