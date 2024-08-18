import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class RestaurarAsenha extends StatefulWidget {
  const RestaurarAsenha({super.key});

  @override
  State<RestaurarAsenha> createState() => _RestaurarAsenhaState();
}

class _RestaurarAsenhaState extends State<RestaurarAsenha> {
  final emailControler = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool afterSend = false;
  Future<void> sendEmail() async {
    try {
      await Provider.of<UserLoginApp>(context, listen: false)
          .resetPassword(emailController: emailControler.text);
      setState(() {
        afterSend = true;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Erro ao enviar e-mail",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            content: Text(
              "Verifique se este e-mail está correto, se o erro permanecer crie uma nova conta, ou aguarde alguns minutos",
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Fechar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutesApp.LoginScreen01);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 20,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      'Recuperar Senha',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                afterSend == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Precisamos do seu E-Mail",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Container(
                                child: Text(
                                  "Enviaremos as informações para recuperar por lá. Digite o E-Mail usado para se cadastrar",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 45,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 1,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Form(
                                        key: _formKey,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty ||
                                                !value.contains('@')) {
                                              return 'Por favor, Verifique o e-mail';
                                            }
                                            return null;
                                          },
                                          controller: emailControler,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            label: Text(
                                              "Clique para digitar",
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.mail_lock_outlined)
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  sendEmail();
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Trocar senha",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    const Icon(
                                      Icons.ads_click,
                                      size: 18,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutesApp.LoginScreen01);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.send_time_extension_outlined,
                                  size: 30,
                                  color: Colors.blue.shade600,
                                ),
                                Text(
                                  "Instruções enviadas ao seu e-mail",
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
