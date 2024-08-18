import 'package:flutter/material.dart';
import 'package:easebase/normalUsersHome/screen/login/restaurar_Senha.dart';
import 'package:easebase/usuarioDeslogado/screen/home/homeScreen01.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/rotas/Approutes.dart';

class LoginScreen01 extends StatefulWidget {
  const LoginScreen01({super.key});

  @override
  State<LoginScreen01> createState() => _LoginScreen01State();
}

class _LoginScreen01State extends State<LoginScreen01> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<void> userAuth(BuildContext context) async {
    try {
      await Provider.of<UserLoginApp>(context, listen: false).fazerLogin(
        emailController.text,
        passwordController.text,
      );

      // Após o login bem-sucedido, navegue para a próxima tela
      Navigator.of(context).pushReplacementNamed(
        AppRoutesApp.VerificationLoginScreen01,
      );
    } catch (e) {
      print("#10 erro no login:${e}");
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Credenciais incorretas",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      fontSize: 16),
                ),
              ),
              content: Text(
                "Insira as credenciais usadas ao criar a sua conta para efetuar o login e entrar em sua conta",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Voltar",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });

      // Aqui você pode exibir uma mensagem de erro para o usuário, se necessário
    }
  }

  bool showPassword = false;

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  width: screenWidth / 5.4,
                  height: screenHeight / 5.4,
                  child: Image.asset(Estabelecimento.urlLogo),
                ),
                const SizedBox(height: 20),
                Text(
                  "Login",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      color: Estabelecimento.primaryColor,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Seu E-mail',
                          hintText: 'Digite seu e-mail',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor:
                              Estabelecimento.secondaryColor.withOpacity(0.2),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite seu e-mail';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          labelText: 'Sua Senha',
                          hintText: 'Digite sua senha',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor:
                              Estabelecimento.secondaryColor.withOpacity(0.2),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: togglePasswordVisibility,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, digite sua senha';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                DialogRoute(
                                    context: context,
                                    builder: (ctx) {
                                      return const RestaurarAsenha();
                                    }));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Esqueceu a senha?',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Estabelecimento.secondaryColor,
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.34,
                                height: 1,
                                color: Estabelecimento.secondaryColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            userAuth(context);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          width: screenWidth,
                          child: Text(
                            "Entrar",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: Estabelecimento.contraPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Estabelecimento.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Primeiro Acesso? ",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Estabelecimento.secondaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutesApp.RegisterAccountScreen,
                              );
                            },
                            child: Text(
                              "Crie a sua Conta",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Estabelecimento.primaryColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            DialogRoute(
                              context: context,
                              builder: (ctx) =>
                                  const HomeScreen01Deslogado(selectedIndex: 0),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Continuar sem conta",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                fontSize: 13,
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
        ),
      ),
    );
  }
}
