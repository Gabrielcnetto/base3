import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/userLogin.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class DadosDaContaConfiguracoesUsuarios extends StatefulWidget {
  const DadosDaContaConfiguracoesUsuarios({super.key});

  @override
  State<DadosDaContaConfiguracoesUsuarios> createState() =>
      _DadosDaContaConfiguracoesUsuariosState();
}

class _DadosDaContaConfiguracoesUsuariosState
    extends State<DadosDaContaConfiguracoesUsuarios> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserEmaile();
  }

  String? userEmail;
  Future<void> loadUserEmaile() async {
    String? usuario = await MyProfileScreenFunctions().getUserEmail();
    setState(() {
      userEmail = usuario;
    });
  }

  final passwordControler = TextEditingController();
  void modalExclusaoConta() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              'Você realmente deseja excluir sua conta?',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
            ),
            content: Text(
              'Antes de excluir, verifique se você tem saldo em sua conta, se tiver, peça o estorno ou agende cortes para usá-los antes de excluir',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: const Text('Digite a sua senha antes'),
                          content: TextFormField(
                            controller: passwordControler,
                            decoration: const InputDecoration(
                              label: Text(
                                'Clique para digitar',
                              ),
                            ),
                          ),
                          actions: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextButton(
                                onPressed: () async {
                                  await deleteAccount();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutesApp.HomeScreen01);
                                },
                                child: Text(
                                  'Confirmar Exclusão',
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
                child: Text(
                  'Confirmar Exclusão',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> deleteAccount() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    if (user != null) {
      try {
        AuthCredential credential = EmailAuthProvider.credential(
          email: userEmail!,
          password: passwordControler.text,
        );

        // Realiza a reautenticação
        await user.reauthenticateWithCredential(credential);
        await user.delete();
      } on FirebaseAuthException catch (e) {
        print('Erro ao excluir a conta: ${e.message}');
      }
    } else {
      print('Nenhum usuário está autenticado.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                //header inicio
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                        ),
                      ),
                      Text(
                        'Configurações da conta',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container()
                    ],
                  ),
                ),
                //header fim
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dados de acesso',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Estes dados são a sua forma de acesso ao App da ${Estabelecimento.nomeLocal}. Seu e-mail não pode ser alterado, porque é a informação principal de acesso a sua conta.',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),

                      //blocos da informação
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'E-mail',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Color.fromARGB(255, 59, 59, 59),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Container(
                                child: Text(
                                  '${userEmail ?? 'carregando...'}',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //bloco da senha
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.only(top: 15, bottom: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sua senha',
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        Color.fromARGB(255, 59, 59, 59),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Text(
                                      '********',
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Provider.of<UserLoginApp>(
                                                  context,
                                                  listen: false)
                                              .resetPassword(
                                                  emailController:
                                                      userEmail ?? "");
                                          await showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                  'Enviamos ao seu E-mail',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  'Abra o e-mail usado ao criar a sua conta e faça a alteração',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
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
                                                      style:
                                                          GoogleFonts.poppins(
                                                        textStyle: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Alterar senha',
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_right,
                                        size: 18,
                                        color: Colors.blue.shade600,
                                      ),
                                    ],
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
                //fim do alterar a senha
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exclusão de conta',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Deseja que os seus dados sejam apagados do sistema da ${Estabelecimento.nomeLocal}? Sem problemas!',
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
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: modalExclusaoConta,
                              child: Text(
                                'Solicitar Exclusão',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade600,
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
                //Solicitacao de reembolso
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Solicitar reembolso de saldo',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Deseja receber o estorno do saldo adicionado na sua conta? Nos envie um e-mail e responderemos em até 10 minutos',
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
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (ctx) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 40, horizontal: 20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        width: double.infinity,
                                       
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 15,
                                                  ),
                                                ),
                                                Text(
                                                  'Solicite um estorno',
                                                  style: GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 15,),
                                            Container(
                                              child: Text(
                                                'Para solictar o reembolso, resolver problemas relacionados a sua conta você pode entrar em contato pelo E-mail: easecorte@gmail ou contato@easecorte.com. Pelo telefone +55 (51) 9 9328-0162 em qualquer horário.',
                                                style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey.shade400,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'Pedir estorno',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade600,
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
                //deslogar
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sair da sua conta',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          'Deslogar e usar o app sem necessariamente um usuário, saiba que você terá funções limitadas usando o app sem uma conta ativa.',
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
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 30),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () async {
                                await Provider.of<UserLoginApp>(context,
                                        listen: false)
                                    .deslogar();
                                Navigator.of(context).pushReplacementNamed(
                                    AppRoutesApp.InitialScreenApp);
                              },
                              child: Text(
                                'Deslogar',
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.blue.shade600,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
