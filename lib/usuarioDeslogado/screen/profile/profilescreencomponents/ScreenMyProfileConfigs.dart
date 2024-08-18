import 'dart:io';

import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/normalUsersHome/screen/login/loginScreen.dart';
import 'package:easebase/normalUsersHome/screen/login/registerAccount.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../functions/profileScreenFunctions.dart';

class ScreenComponentsMyProfileDeslogado extends StatefulWidget {
  const ScreenComponentsMyProfileDeslogado({super.key});

  @override
  State<ScreenComponentsMyProfileDeslogado> createState() =>
      _ScreenComponentsMyProfileDeslogadoState();
}

class _ScreenComponentsMyProfileDeslogadoState
    extends State<ScreenComponentsMyProfileDeslogado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void showAlertLogin() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Você está deslogado",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            content: Text(
              "Primeiro acesso? Crie a sua conta. Já tem uma conta? Faça o login e tenha acesso completo ao App",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const RegisterAccountScreen(),
                    ),
                  );
                },
                child: Text(
                  "Criar Conta",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const LoginScreen01(),
                    ),
                  );
                },
                child: Text(
                  "Fazer login",
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

  //GET NUMERO - FINAL

  @override
  Widget build(BuildContext context) {
    final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Container(
      width: widhScren,
      height: heighScreen,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: widhScren,
              height: 300,
              color: Estabelecimento.primaryColor,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(50, 50),
                  topRight: Radius.elliptical(50, 50),
                ),
              ),
              width: widhScren,
              height: heighScreen * 0.76,
            ),
          ),
          Positioned(
            top: 120,
            right: 130,
            left: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.network(
                      Estabelecimento.defaultAvatar,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      child: const Icon(Icons.camera),
                      onTap: showAlertLogin,
                    ),
                    InkWell(
                      child: const Icon(Icons.photo_library),
                      onTap: showAlertLogin,
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 290,
            right: 40,
            left: 40,
            child: Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              height: heighScreen,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //inicio -> FORMULARIO COM O NOME
                    Text(
                      "Seu Nome",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800,
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: showAlertLogin,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Estabelecimento.primaryColor,
                                ),
                                const Text(
                                  "Salvar",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Fim -> FORMULARIO COM O NOME
                    const SizedBox(
                      height: 10,
                    ),
                    //inicio -> FORMULARIO COM O TELEFONE
                    Text(
                      "Número WhatsApp",
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade800,
                      )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          width: 0.5,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: showAlertLogin,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.save,
                                  size: 20,
                                  color: Estabelecimento.primaryColor,
                                ),
                                const Text(
                                  "Salvar",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Fim -> FORMULARIO COM O TELEFONE
                    const SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Provider.of<UserLoginApp>(context, listen: false)
                            .deslogar();
                        Navigator.of(context).pushReplacementNamed(
                            AppRoutesApp.InitialScreenApp);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Estabelecimento.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Acessar ou criar conta",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Estabelecimento.contraPrimaryColor,
                              )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.logout,
                              size: 22,
                              color: Estabelecimento.contraPrimaryColor,
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
        ],
      ),
    );
  }
}
