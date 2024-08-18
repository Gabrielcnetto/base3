import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/Blocks.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/agendaDia/CortesHojeLista.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/verticalOptions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:easebase/normalUsersHome/screen/home/homeScreen01.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ManagerScreenViewHomeNewView extends StatefulWidget {
  const ManagerScreenViewHomeNewView({super.key});

  @override
  State<ManagerScreenViewHomeNewView> createState() =>
      _ManagerScreenViewHomeNewViewState();
}

class _ManagerScreenViewHomeNewViewState
    extends State<ManagerScreenViewHomeNewView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false)
        .gerarUltimos4Meses();
    userName;
    loadUserName();
    urlImagePhoto;
    fotoPadraoUserError;
    urlImageFuncion();
    loadUserIsManager();
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

  bool? isManager;

  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsManager();

    if (isManager != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      isManager = bolIsManager!;
    });
  }

  final String fotoPadraoUserError =
      "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Profissional - Principal",
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
                const BlocksManagerComponent(),
                //     const ManagerVerticalOptions(),
                const CortesHojeLista(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
