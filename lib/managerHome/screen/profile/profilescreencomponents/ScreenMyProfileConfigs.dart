import 'dart:io';

import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';



class ScreenComponentsMyProfile extends StatefulWidget {
  const ScreenComponentsMyProfile({super.key});

  @override
  State<ScreenComponentsMyProfile> createState() =>
      _ScreenComponentsMyProfileState();
}

class _ScreenComponentsMyProfileState extends State<ScreenComponentsMyProfile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<MyProfileScreenFunctions>(context, listen: false).getUserName();
    Provider.of<MyProfileScreenFunctions>(context, listen: false).getPhone();
    phoneNumber;
    userName;
    urlImagePhoto;
    loadUserPhone();
    loadUserName();
    urlImageFuncion();
    setState(() {
      
    });
  }

  Future<void> setandonewnome() async {
    setState(() {});
    Provider.of<MyProfileScreenFunctions>(context, listen: false).newName(
      newName: nomeControler.text,
    );
    setState(() {});
  }

  Future<void> setandoPhone() async {
    setState(() {});
    Provider.of<MyProfileScreenFunctions>(context, listen: false).setPhone(
      phoneNumber: phoneNumberControler.text,
    );
    setState(() {});
  }

  //GET USERNAME - INICIO
  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      setInControler();
    });
  }

  void setInControler() {
    nomeControler.text = userName!;
  }

  //GET USERNAME - FINAL
  //GET NUMERO - INCIO
  String? phoneNumber;
  Future<void> loadUserPhone() async {
    String? number = await MyProfileScreenFunctions().getPhone();

    if (phoneNumber != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      phoneNumber = number;
      setPhone();
    });
  }

  void setPhone() {
    phoneNumberControler.text = phoneNumber!;
  }

  //GET NUMERO - FINAL
  final nomeControler = TextEditingController();
  final phoneNumberControler = TextEditingController();

  //funcao geral de enviar ao db a foto nova
  void showModalPhtoNew() {
    setState(() {
      
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Image.asset(
                    "imagesOfApp/shine.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Sua foto de perfil foi Atualizada!",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Uhuu! Vamos ver como ficou sua nova foto?\nEla pode levar até 5 segundos para atualizar!",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 80, left: 20, right: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Estabelecimento.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Voltar ao perfil",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Estabelecimento.contraPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Future<void> setNewimageOnDB() async {
    setState(() {
      
    });
    final String photo = await image!.path;
    try {
      if (photo != null) {
        showModalPhtoNew();
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .setImageProfile(
          urlImage: File(photo),
        );
      }
    } catch (e) {
      print("erro: $e");
    }
  }

  //GET IMAGEM DO PERFIL - INICIO(CAMERA)
  XFile? image;

  Future<void> getProfileImageCamera() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    await setNewimageOnDB();
  }

  //GET IMAGEM DO PERFIL - FINAL(CAMERA)
  Future<void> getProfileImageBiblio() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    await setNewimageOnDB();
  }
  //final biblioteca

  //get da imagem de perfil
  String? urlImagePhoto;
  Future<void> urlImageFuncion() async {
    String? number = await MyProfileScreenFunctions().getUserImage();

    if (urlImagePhoto != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      urlImagePhoto = number;
      setPhone();
    });
  }

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
                  child: urlImagePhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: Image.network(
                            "${urlImagePhoto}",
                            fit: BoxFit.cover,
                          ),
                        )
                      : ClipRRect(
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
                      onTap: getProfileImageCamera,
                    ),
                    InkWell(
                      child: const Icon(Icons.photo_library),
                      onTap: getProfileImageBiblio,
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
                              controller: nomeControler,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: setandonewnome,
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
                              controller: phoneNumberControler,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: setandoPhone,
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
                            AppRoutesApp.VerificationLoginScreen01);
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
                              "Deslogar",
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
