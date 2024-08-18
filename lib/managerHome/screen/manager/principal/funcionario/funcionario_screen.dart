import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/principal/funcionario/componentes/Blocks_Funcionario.dart';
import 'package:easebase/managerHome/screen/manager/principal/funcionario/componentes/CortesHojeLista.dart';
import 'package:easebase/managerHome/screen/manager/principal/funcionario/componentes/verticalOptions.dart';
import 'package:easebase/normalUsersHome/screen/home/homeScreen01.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FuncionarioScreenHomeScreenNew extends StatefulWidget {
  const FuncionarioScreenHomeScreenNew({super.key});

  @override
  State<FuncionarioScreenHomeScreenNew> createState() =>
      _FuncionarioScreenHomeScreenNewState();
}

class _FuncionarioScreenHomeScreenNewState
    extends State<FuncionarioScreenHomeScreenNew> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName;
    loadUserName();
    urlImagePhoto;
    urlImageFuncion();
    loadUserIsFuncionario();
    fotoPadraoUserError;
  }

  bool? isFuncionario;

  Future<void> loadUserIsFuncionario() async {
    bool? bolIsManager =
        await MyProfileScreenFunctions().getUserIsFuncionario();

    if (isFuncionario != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      isFuncionario = bolIsManager!;
    });
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
    });
  }

  String? urlImagePhoto;
  Future<void> urlImageFuncion() async {
    String? urlPhoto = await MyProfileScreenFunctions().getUserImage();

    if (urlImagePhoto != null) {
      print("imagem do usuario nao definidida");
    } else {
      const Text('N/A');
    }

    setState(() {
      urlImagePhoto = urlPhoto;
    });
  }

  final String fotoPadraoUserError =
      "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92";
  @override
  Widget build(BuildContext context) {
    return isFuncionario == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                child: urlImagePhoto == null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Image.network(
                                          "${fotoPadraoUserError}",
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(45),
                                        child: Image.network(
                                          urlImagePhoto!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profissional - Funcionário",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${userName ?? "Carregando..."}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Dashboard",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      const BlocksFuncionarioComponent(),
                      //  const FuncionarioVerticalOptions(),
                      const CortesHojeListaFuncionario(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : const Scaffold(
            body: Center(
              child: Text(
                "Dados Restritos",
              ),
            ),
          );
  }
}
