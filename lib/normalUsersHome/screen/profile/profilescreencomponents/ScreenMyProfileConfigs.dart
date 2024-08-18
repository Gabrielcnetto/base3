import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/stripe_subscriptions.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/normalUsersHome/screen/profile/profilescreencomponents/TelaVisaoAssinatura.dart';
import 'package:easebase/normalUsersHome/screen/profile/profilescreencomponents/addCreditos.dart';
import 'package:easebase/normalUsersHome/screen/profile/profilescreencomponents/dados_conta_config.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../functions/profileScreenFunctions.dart';

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
    loadSaldo();
    loadAssinatura1();
    loadPremium();
  }

  void modalNewNome() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(20, 20),
              topRight: Radius.elliptical(20, 20),
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atualize o seu nome',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: nomeControler,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            label: Text(
                              'Clique para digitar',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: setandonewnome,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Salvar',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> setandonewnome() async {
    setState(() {});

    try {
      Provider.of<MyProfileScreenFunctions>(context, listen: false).newName(
        newName: nomeControler.text,
      );
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                'Nome atualizado',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              content: Text(
                'Agora seu novo nome de usuário aparecerá no app',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
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
                    'Fechar',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            );
          });
      Navigator.of(context).pushReplacementNamed(AppRoutesApp.HomeScreen01);
    } catch (e) {}
    setState(() {});
  }

  //
  void modalNewPhone() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.elliptical(20, 20),
              topRight: Radius.elliptical(20, 20),
            ),
          ),
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atualize o seu telefone',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: phoneNumberControler,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            label: Text(
                              'Clique para digitar',
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: setandoPhone,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            'Salvar',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> setandoPhone() async {
    setState(() {});
    try {
      Provider.of<MyProfileScreenFunctions>(context, listen: false).setPhone(
        phoneNumber: phoneNumberControler.text,
      );
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                'Contato atualizado',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              content: Text(
                'Agora seu número está atualizado no app',
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
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
                    'Fechar',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              ],
            );
          });
      Navigator.of(context).pushReplacementNamed(AppRoutesApp.HomeScreen01);
    } catch (e) {}
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

//get do premium - inicio
  bool? UsuarioPremium;
  Future<void> loadPremium() async {
    bool? boolDATABASE = await MyProfileScreenFunctions().getPremiumOrNot();

    setState(() {
      UsuarioPremium = boolDATABASE;
    });
  }

//get do premium - fim
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

//get saldo

  //GET NUMERO - FINAL
  final nomeControler = TextEditingController();
  final phoneNumberControler = TextEditingController();

  //funcao geral de enviar ao db a foto nova
  void showModalPhtoNew() {
    setState(() {});
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
    setState(() {});
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

  XFile? image;

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

  double saldoTotal = 0;
  Future<void> loadSaldo() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .getUserSaldo();
    setState(() {
      saldoTotal = PointOfClient!.toDouble();
    });
  }

  bool verSaldo = false;
  double valorAssinatura1 = 0;
  Future<void> loadAssinatura1() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .getValorAssinatura1();
    setState(() {
      valorAssinatura1 = PointOfClient!.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      width: widhScren,
      height: heighScreen,
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //HEADER - incio
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Olá, ${userName ?? 'Carregando...'}! ',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.front_hand,
                              color: Color.fromARGB(255, 246, 206, 5),
                            )
                          ],
                        ),
                        Text(
                          'Configure seu perfil aqui',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (UsuarioPremium == true)
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color.fromARGB(255, 190, 190, 0),
                                size: 18,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                child: Text(
                                  'assinatura ativa',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10,
                                        fontStyle: FontStyle.italic),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: widhScren * 0.12,
                          height: heighScreen * 0.07,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              '${urlImagePhoto ?? Estabelecimento.defaultAvatar}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              //header fim
              //BLOCO DO SALDO - INICIO
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              verSaldo == true
                                  ? Text(
                                      'R\$ ${saldoTotal.toStringAsFixed(2).replaceAll('.', ',')}',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 50,
                                      height: 15,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                'Saldo para pagamentos',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                verSaldo = !verSaldo;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                verSaldo == false
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: InkWell(
                          onTap: () {
                            if (!kIsWeb) {
                              Navigator.of(context).push(DialogRoute(
                                  context: context,
                                  builder: (ctx) {
                                    return const AddCreditosNaConta();
                                  }));
                            } else {
                              showDialog(
                                context: context,
                                builder: (ctx) {
                                  return AlertDialog(
                                    title:
                                        const Text('Disponível somente no app'),
                                    content: const Text(
                                        'Para adicionar créditos, utilize o aplicativo da ${Estabelecimento.nomeLocal}'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                            ;
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: UsuarioPremium == true
                                  ? Colors.orangeAccent
                                  : Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.account_balance_wallet,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Adicione Créditos',
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Pague 100% online',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //BLOCO DO SALDO - FIM
              //BLOCO DAS CONFIGURAÇOES - INICIO
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                      bottom: BorderSide(
                        width: 1,
                        color: Colors.grey.shade200,
                      ),
                    ),
                  ),
                  width: widhScren,
                  child: Column(
                    children: [
                      //EDITAR O NOME DO PERFIL - INCIO
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: modalNewNome,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Estabelecimento.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      ' Editar nome',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //EDITAR O NOME DO PERFIL - FIM
                      //editar a foto - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: getProfileImageBiblio,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Estabelecimento.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      ' Editar foto de perfil',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //editar a foto - fim
                      //salvar telefone - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: modalNewPhone,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Estabelecimento.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      ' Salvar telefone(recomendado)',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //salvar telefone - fim
                      //BLOCO DAS CONFIGURACOES - FIM
                      //configuracoes gerais - inicio
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(DialogRoute(
                                context: context,
                                builder: (ctx) {
                                  return const DadosDaContaConfiguracoesUsuarios();
                                }));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Estabelecimento.primaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: const Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      ' Dados da conta',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 18,
                                  color: Colors.grey.shade300,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      //configuracoes gerais - fim
                    ],
                  ),
                ),
              ),
              //BLOCO DAS ASSINATURAS
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Escolha Seu Plano',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Ignore as filas, Corte quando quiser e pague no crédito apenas 1x ao mês.',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Plano Mensal',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Tenha um horário fixo e sempre disponível na ${Estabelecimento.nomeLocal}, ou agende quando quiser sem precisar pagar mais que a assinatura.',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.white60,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        //blocos do beneficio
                                        Container(
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 5,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Barba inclusa',
                                                style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Icon(
                                                  Icons.done_all,
                                                  color: Colors.blue.shade600,
                                                  size: 18,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Corte quando desejar',
                                                  style: GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Icon(
                                                    Icons.done_all,
                                                    color: Colors.blue.shade600,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 5,
                                              horizontal: 5,
                                            ),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Pague apenas 1x ao mês',
                                                  style: GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5),
                                                  child: Icon(
                                                    Icons.done_all,
                                                    color: Colors.blue.shade600,
                                                    size: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //blocos do beneficio
                                      ],
                                    ),
                                  ),
                                  //fim dos beneficios
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'R\$${valorAssinatura1.toStringAsFixed(2).replaceAll('.', ',')}/mês',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 22,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                shadows: [
                                                  Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 2.0,
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () {
                                            if (!kIsWeb) {
                                              Navigator.of(context).push(
                                                DialogRoute(
                                                  context: context,
                                                  builder: (ctx) {
                                                    return TelaVisaoAssinaturaPagamento(
                                                      valorAssinatura:
                                                          valorAssinatura1,
                                                    );
                                                  },
                                                ),
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Disponível no app',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    content: Text(
                                                      'Para assinar um plano, use o aplicativo da ${Estabelecimento.nomeLocal} na play ou apple store.',
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black54,
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text(
                                                          'Fechar',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  );
                                                },
                                              );
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: UsuarioPremium == true
                                                  ? Colors.black
                                                  : const Color.fromARGB(
                                                      255, 65, 191, 72),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Text(
                                              UsuarioPremium == true
                                                  ? 'PLANO ATIVADO'
                                                  : 'Assinar Agora',
                                              style: GoogleFonts.openSans(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  color: Colors.white,
                                                  fontSize: 14,
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
      ),
    );
  }
}
