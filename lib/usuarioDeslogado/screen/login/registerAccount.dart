
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/createAccount.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  final userNameControler = TextEditingController();
  Future<void> createAccountFNProvider()async {
    Provider.of<CreateAccount>(context, listen: false).CreateAccountProvider(
      email: emailControler.text,
      password: passwordControler.text,
      userName: userNameControler.text,
    );
  }

  bool showPass = true;
  void HidenPass() {
    setState(() {
      showPass = !showPass;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              child: Image.asset(
                Estabelecimento.bannerInitial,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                width: screenWidth,
                height: screenHeight * 0.75,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(25, 25),
                    topRight: Radius.elliptical(25, 25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Criar Perfil",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Estabelecimento.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Usamos estas informações para identificar você",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Estabelecimento.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //INICIO DO FORMULARIO DE CADASTRO
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //INICIO FORMULARIO DO E-MAIL
                            Text(
                              "E-mail",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Estabelecimento.secondaryColor
                                    .withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: TextFormField(
                                controller: emailControler,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //FIM FORMULARIO DO E-MAIL
                            const SizedBox(
                              height: 15,
                            ),
                            //INICIO FORMULARIO DO password
                            Text(
                              "Sua Senha",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Estabelecimento.secondaryColor
                                    .withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: passwordControler,
                                      obscureText: showPass,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: HidenPass,
                                    child: Icon(
                                    showPass?  Icons.visibility : Icons.visibility_off,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //FIM FORMULARIO DO password
                            const SizedBox(
                              height: 15,
                            ),
                            //INICIO FORMULARIO DO nome
                            Text(
                              "Seu nome",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Estabelecimento.secondaryColor
                                    .withOpacity(0.1),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: TextFormField(
                                controller: userNameControler,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            //FIM FORMULARIO DO nome
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      //FIM DO FORMULARIO DE CADASTRO
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: InkWell(
                          onTap: createAccountFNProvider,
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            height: 45,
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "Criar Conta",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Estabelecimento.contraPrimaryColor,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "< Voltar",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Estabelecimento.secondaryColor,
                                )),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
