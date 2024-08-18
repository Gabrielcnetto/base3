import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/circularProgressIndicLevel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class HomeHeaderSemListaDeslogado extends StatefulWidget {
  final double widhTela;
  final double heighTela;

  const HomeHeaderSemListaDeslogado({
    super.key,
    required this.heighTela,
    required this.widhTela,
  });

  @override
  State<HomeHeaderSemListaDeslogado> createState() =>
      _HomeHeaderSemListaDeslogadoState();
}

class _HomeHeaderSemListaDeslogadoState
    extends State<HomeHeaderSemListaDeslogado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valorPoints;
    userProfileIsOk;
    urlImagePhoto;
    VerifyImageUser();

    urlImageFuncion();
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
      ;
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

  double valorPoints = 0;

  double calcularProgresso() {
    // Calcula o progresso com base nos pontos acumulados
    return valorPoints / 12.0;
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
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    AppRoutesApp.InitialScreenApp);
                              },
                              child: Text(
                                "Crie sua conta",
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushReplacementNamed(
                                    AppRoutesApp.InitialScreenApp);
                              },
                              child: Text(
                                "Obtenha acesso completo",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        CircularProgressWithImage(
                          totalCortes:
                              Provider.of<CorteProvider>(context, listen: false)
                                  .userCortesTotal
                                  .length,
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
