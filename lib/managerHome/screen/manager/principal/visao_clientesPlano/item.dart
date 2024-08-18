import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/stripe_subscriptions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemPremiumUser extends StatefulWidget {
  final GeralUser userInfs;
  const ItemPremiumUser({
    super.key,
    required this.userInfs,
  });

  @override
  State<ItemPremiumUser> createState() => _ItemPremiumUserState();
}

class _ItemPremiumUserState extends State<ItemPremiumUser> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAssinatura1();
  }

  double valorAssinatura1 = 0;
  Future<void> loadAssinatura1() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .getValorAssinatura1();
    setState(() {
      valorAssinatura1 = PointOfClient!.toDouble();
    });
  }

  void sendMessageWhatsApp() async {
    if (await canLaunch("https://wa.me/${widget.userInfs.PhoneNumber}")) {
      await launch("https://wa.me/${widget.userInfs.PhoneNumber}");
    } else {
      throw 'Não foi possível abrir o link';
    }
  }

  Future<void> funcaodecancelar() async {
    try {
      await Provider.of<StripeSubscriptions>(context, listen: false)
          .cancelSubscription(
        subscriptionId: widget.userInfs.assinaturaId,
        userId: widget.userInfs.userIdDatabase,
        precoAssinatura: valorAssinatura1,
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text(
              'Erro ao cancelar',
            ),
            content: const Text(
              'Entre em contato com a @easecorte, com o nome do cliente que faremos manualmente o cancelamento. Pedimmos desculpas pelo transtorno e resolveremos em breve!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutesApp.HomeScreen01,
                    (route) => false,
                  );
                },
                child: const Text('fechar'),
              ),
            ],
          );
        },
      );
    }
  }

  void cancelarPlanoDeCliente() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            "Cancelar Assinatura?",
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          content: Text(
            "Você realmente quer cancelar a assinatura deste cliente?",
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
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
                'Fechar',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await funcaodecancelar();
                await showDialog(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text(
                        'Assinatura Cancelada!',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      content: Text(
                        'A Assinatura mensal deste cliente foi cancelada!',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutesApp.HomeScreen01,
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Fechar',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                'Cancelar assinatura',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          widget.userInfs.urlImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userInfs.name,
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.black,
                            )),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width * 0.55,
                            child: Text(
                              'Cobraça mensal automática',
                              style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black54,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.verified,
                    size: 20,
                    color: Colors.green.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      if (widget.userInfs.PhoneNumber != null) {
                        sendMessageWhatsApp();
                      } else {
                        showDialog(
                            context: context,
                            builder: (ctx) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Sem número',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  'Este cliente não tem telefone salvo no sistema',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
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
                                      'Fechar',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
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
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'WhatsApp',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.mark_chat_unread,
                            color: Colors.green.shade600,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: cancelarPlanoDeCliente,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 5,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Cancelar Plano',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 3,
                          ),
                          const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
