import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/stripe_subscriptions.dart';
import 'package:easebase/normalUsersHome/screen/home/homeScreen01.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class AddCreditosNaConta extends StatefulWidget {
  const AddCreditosNaConta({super.key});

  @override
  State<AddCreditosNaConta> createState() => _AddCreditosNaContaState();
}

class _AddCreditosNaContaState extends State<AddCreditosNaConta> {
  //FUNCOES DE PAGAMENTO NA STRIPE - INICIO
  Map<String, dynamic>? paymentIntent;
  void makePayment() async {
    List<ApplePayCartSummaryItem> lista = [
      const ApplePayCartSummaryItem.immediate(
        label: 'item1',
        amount: '99',
        isPending: false,
      ),
    ];

    try {
      paymentIntent = await createPaymentIntent();
      print('print777: ${paymentIntent}');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: "${Estabelecimento.nomeLocal}",
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
          customerId: paymentIntent!['customer'],
          // Extra options
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'BR',
            buttonType: PlatformButtonType.buy,
            cartItems: lista,
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'BR',
            currencyCode: 'BRL',
            buttonType: PlatformButtonType.buy,
            testEnv: true,
          ),
          style: ThemeMode.light,
        ),
      );
      await displayPaymentSheet();
    } catch (e) {
      print("houve um erro no display: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: Text("Houve um erro no pagamento: $e"),
            actions: [
              TextButton(
                child: const Text("Fechar"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      try {
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .updateCreditosPerfil(
          saldoAdicionar: double.parse(
            valueFinalFound.text,
          ),
        );
        double taxa = double.parse(valueFinalFound.text) * 0.012;
        double valorFinal = double.parse(valueFinalFound.text) - taxa;
        await Provider.of<StripeSubscriptions>(context, listen: false)
            .enviandoValordeDepositosnoApp(
          valorAssinatura: valorFinal,
        );
      } catch (e) {}

      //divisao
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          Future.delayed(const Duration(milliseconds: 4000), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext ctx) {
                  return const HomeScreen01(
                    selectedIndex: 0,
                    cupomIsAcitve: false,
                  );
                },
              ),
              (Route<dynamic> route) =>
                  false, // Remove todas as rotas anteriores
            );
          });
          Future.delayed(const Duration(milliseconds: 4000), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext ctx) {
                  return const HomeScreen01(
                    selectedIndex: 0,
                    cupomIsAcitve: false,
                  );
                },
              ),
              (Route<dynamic> route) =>
                  false, // Remove todas as rotas anteriores
            );
          });
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.75,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'imagesOfApp/Confirmpay.gif',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    child: Text(
                      'UHUUU! Pagamento Confirmado',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
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
      print("ok, done");
    } catch (e) {
      print("houve um erro no display: $e");
    }
  }

  createPaymentIntent() async {
    int amountInCents = int.parse(valueFinalFound.text) * 100;
    String myToken =
        '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';
    try {
      Map<String, dynamic> body = {
        "amount": amountInCents
            .toString(), //colocar *centavos para um valor de R$ 99,00, você deve enviar 9900 centavos.
        "currency": "BRL",
      };
      var CreateResponse = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            "Authorization": "Bearer $myToken",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      return jsonDecode(CreateResponse.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //FUNCOES DE PAGAMENTO NA STRIPE - INICIO

  final valueFinalFound = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      'Adicione saldo na conta',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Container()
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Quanto você deseja adicionar de crédito para usar na \n${Estabelecimento.nomeLocal}?',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 3,
                        color: Colors.black,
                      ),
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: TextFormField(
                      maxLength: 4,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly, // Permite apenas dígitos
                      ],
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        label: Text(
                          'R\$ ',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      controller: valueFinalFound,
                    ),
                  ),
                ),
                //valores pré selecionados - inicio
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              valueFinalFound.text = '35';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'R\$ 35,00',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              valueFinalFound.text = '50';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'R\$ 50,00',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              valueFinalFound.text = '75';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'R\$ 75,00',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //valores pré selecionados - fim
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InkWell(
                    onTap: () {
                      if (valueFinalFound.text.isNotEmpty) {
                        makePayment();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Realizar pagamento',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
