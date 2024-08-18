import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/profissionalCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../circularProgressIndicLevel.dart';

class HomePageHeader extends StatefulWidget {
  final double widhTela;
  final double heighTela;

  const HomePageHeader({
    super.key,
    required this.heighTela,
    required this.widhTela,
  });

  @override
  State<HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    valorPoints;
    ajustePoints();
    userProfileIsOk;
    urlImagePhoto;
    VerifyImageUser();
    pontuacaoTotalCliente;
    loadpoints();
    userName;
    urlImageFuncion();
    loadPremium();
    Provider.of<CorteProvider>(context, listen: false).userCortesTotal;
    Provider.of<CorteProvider>(context, listen: false).loadHistoryCortes;
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
      loadpoints();
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

  CorteClass? _listaCortesUsuario;

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

  Future<void> onDismissedFunction() async {}
  @override
  Widget build(BuildContext context) {
    CorteClass _listaCortesUsuario =
        Provider.of<CorteProvider>(context, listen: false).userCortesTotal[0];

    List<CorteClass> listaGeral =
        Provider.of<CorteProvider>(context, listen: false).userCortesTotal;
    final tamanhoTela = MediaQuery.of(context).size;
    print(_listaCortesUsuario == null ? "o item é null" : "nao é null");
    double heighTelaFinal = tamanhoTela.height;

    final double setHeigh = heighTelaFinal > 800
        ? heighTelaFinal / 2.3
        : heighTelaFinal < 500
            ? heighTelaFinal / 2.1
            : heighTelaFinal / 1.9;

    //PEGANDO O CODIGO ATIVO

    return Container(
      constraints: BoxConstraints(
        minHeight: setHeigh,
        maxHeight: setHeigh,
        minWidth: widget.widhTela,
        maxWidth: widget.widhTela,
      ),
      child: Container(
        //padding: EdgeInsets.only(top: setHeigh * 0.09),
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: setHeigh * 0.85,
                maxHeight: setHeigh * 0.85,
                minWidth: widget.widhTela,
                maxWidth: widget.widhTela,
              ),
              child: Container(
                //  padding: EdgeInsets.only(top: 40),
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
                          totalCortes: pontuacaoTotalCliente ?? 0,
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
            Positioned(
              bottom: 0,
              left: 20,
              child: ProfissionalCode(
                corte: CorteClass(
                  feitoporassinatura: _listaCortesUsuario.feitoporassinatura ?? false,
                  pagoComCreditos: _listaCortesUsuario.pagoComCreditos ?? false,
                  pagoComCupom: _listaCortesUsuario.pagoComCupom ?? false,
                  easepoints: _listaCortesUsuario.easepoints ?? 0,
                  apenasBarba: _listaCortesUsuario.apenasBarba,
                  detalheDoProcedimento:
                      _listaCortesUsuario.detalheDoProcedimento,
                  horariosExtra: _listaCortesUsuario.horariosExtra,
                  totalValue: _listaCortesUsuario.totalValue,
                  isActive: _listaCortesUsuario.isActive,
                  DiaDoCorte: _listaCortesUsuario.DiaDoCorte,
                  NomeMes: _listaCortesUsuario.NomeMes,
                  dateCreateAgendamento:
                      _listaCortesUsuario.dateCreateAgendamento,
                  clientName: "${_listaCortesUsuario.clientName}",
                  id: "${_listaCortesUsuario.id}",
                  numeroContato: "${_listaCortesUsuario.numeroContato}",
                  profissionalSelect:
                      "${_listaCortesUsuario.profissionalSelect}",
                  diaCorte: _listaCortesUsuario.diaCorte,
                  horarioCorte: "${_listaCortesUsuario.horarioCorte}",
                  barba: _listaCortesUsuario.barba,
                  ramdomCode: _listaCortesUsuario.ramdomCode,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
