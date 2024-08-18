import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/functions/stripe_subscriptions.dart';
import 'package:provider/provider.dart';

class TelaVisaoAssinaturaPagamento extends StatefulWidget {
  final double valorAssinatura;
  const TelaVisaoAssinaturaPagamento({
    super.key,
    required this.valorAssinatura,
  });

  @override
  State<TelaVisaoAssinaturaPagamento> createState() =>
      _TelaVisaoAssinaturaPagamentoState();
}

class _TelaVisaoAssinaturaPagamentoState
    extends State<TelaVisaoAssinaturaPagamento> {
  CardFieldInputDetails? _cardDetails;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserName();
    loadUserPhone();
    loadUserEmaile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  //GET DO NOME PARA ENVIAR JUNTO
  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      // splitName();
    });
  }

  //get do contato
  TextEditingController phoneControler = TextEditingController();
  String? phoneNumber;
  Future<void> loadUserPhone() async {
    String? number = await MyProfileScreenFunctions().getPhone();

    if (phoneNumber != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      phoneNumber = number;
      phoneControler.text = number!;
    });
  }

  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  String? userEmail;

  Future<void> loadUserEmaile() async {
    String? usuario = await MyProfileScreenFunctions().getUserEmail();
    setState(() {
      userEmail = usuario;
    });
  }

  Future<void> subscriberUser() async {
    //if (!_formKey.currentState!.validate()) {
    //  return;
    // }
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Aguarde, estamos confirmando...',
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
                )
              ],
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.7,
          ),
        );
      },
    );
    try {
      if (_cardDetails == null || !_cardDetails!.complete) {
        print('Card details not complete');
        return;
      }
      final billingDetails = BillingDetails(
        address: const Address(
          city: 'parobé',
          country: 'BR',
          line1: 'maria de l',
          line2: '',
          postalCode: '95630000',
          state: 'RS',
        ),
        email: '${userEmail ?? 'easecorte@gmail.com'}', // Email do cliente
        name: '${userName ?? "cliente ${Estabelecimento.nomeLocal}"}',
        phone: '${phoneNumber ?? 'Cliente ${Estabelecimento.nomeLocal}'}',
      );
      final payMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: billingDetails,
          ),
        ),
      );
      String email =
          '${userEmail ?? 'easecorte@gmail.com'}'; // Email do cliente
      int amount =
          (widget.valorAssinatura * 100).toInt() ; //widget.valorAssinatura.toInt();
      print("#amoun22: o valor de amount é igual: ${amount}");
      await Provider.of<StripeSubscriptions>(context, listen: false)
          .createAndSubscribeCustomer(email, amount, payMethod);
      print('#uhs: Subscription successful');

      await Provider.of<StripeSubscriptions>(context, listen: false)
          .enviarAssinaturaAtivaAoBancodeDados();
      try {
        Provider.of<MyProfileScreenFunctions>(context, listen: false).setPhone(
          phoneNumber: phoneNumber ?? '',
        );

        //enviando ao gerenciador
        double taxa = widget.valorAssinatura * 0.012;
        double valorfinal = widget.valorAssinatura - taxa;
        await Provider.of<StripeSubscriptions>(context, listen: false)
            .enviandoValorMensalDeAssinaturaSParaGerenciador(
          valorAssinatura: valorfinal,
        );
      } catch (e) {}

      Navigator.of(context).pop();
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Sua Assinatura foi confirmada!',
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
                  )
                ],
              ),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
            ),
          );
        },
      );

// Fecha o modal automaticamente após 3 segundos
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print('#uhs:houve um erro ao criar um subscriber: ${e}');
      Navigator.pop(context); // Fecha o modal inicial

      // Exibe um Snackbar com a mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Houve um erro ao processar sua assinatura. Tente novamente.',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          duration: const Duration(seconds: 3), // Duração do Snackbar
          backgroundColor: Colors.red, // Cor de fundo do Snackbar
        ),
      );
    }
  }

  List<String> _DiaSemana = [
    'SEG',
    'TER',
    'QUA',
    'QUI',
    'SEX',
    'SAB',
  ];
  int selectedIndex = -1;
  String? diaSelecionado;

  String? hourSetForUser;
  List<Horarios> horarioFinal = [];
  void setList() {
    if (diaSelecionado == 'SEG' ||
        diaSelecionado == 'TER' ||
        diaSelecionado == 'QUA' ||
        diaSelecionado == 'QUI' ||
        diaSelecionado == 'SEX') {
      setState(() {
        horarioFinal = hourLists;
      });
    } else {
      setState(() {
        horarioFinal = sabadoHorarios;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Assinatura',
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 26,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Text(
                          'Preço Exclusivo, sempre que desejar acesse o app, escolha um dia e um horário disponível e agende sem precisar pagar nada a mais pelo corte. Corte com qualquer um dos profissionais disponíveis na ${Estabelecimento.nomeLocal}',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                    ),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'R\$ ',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '${widget.valorAssinatura.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '/mês',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 30,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        //
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade800,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Cabelo & barba',
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.check_circle,
                                        color: Colors.green.shade800,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Quando quiser',
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              //
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade800,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'No Crédito',
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green.shade800,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          'Preço Exclusivo',
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, right: 15, bottom: 30),
                  child: Container(
                    padding: const EdgeInsets.only(top: 15),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Como funciona?',
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      'Sempre que quiser, acesse o app e agende um horário, pague apenas a mensalidade e nenhuma difereça a mais pelo procedimento',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Pagamentos:',
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      'O Pagamento é automático no seu cartão de crédito, sem a necessidade de pagar pessoalmente.',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Cancelamento:',
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.55,
                                    child: Text(
                                      'Cancele quando quiser, falando com um dos profissionais',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Expanded(
                                child: Container(
                                  child: Image.asset(
                                    'imagesOfApp/semhistoricodecortes.jpeg',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          width: double.infinity,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detalhes do cartão',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: CardFormField(
                                    countryCode: 'BR',
                                    style: CardFormStyle(
                                      backgroundColor: Colors.black,
                                    ),
                                    enablePostalCode: false,
                                    onCardChanged: (card) {
                                      setState(() {
                                        _cardDetails = card;
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Seu telefone',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Por favor, digite o seu telefone';
                                            }
                                            return null;
                                          },
                                          controller: phoneControler,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly // Restringe a entrada a números
                                          ],
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            label: Text(
                                              "Clique para digitar",
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (_formKey.currentState!.validate()) {
                                          subscriberUser();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        child: Text(
                                          'Confirmar assinatura',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (ctx) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 30,
                                                        horizontal: 30),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  width: double.infinity,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      vertical: 30,
                                                      horizontal: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Icon(
                                                              Icons
                                                                  .arrow_back_ios,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Voltar',
                                                            style: GoogleFonts
                                                                .openSans(
                                                              textStyle:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        child: Text(
                                                          'Assinar um plano na ${Estabelecimento.nomeLocal} pelo valor R\$${widget.valorAssinatura.toStringAsFixed(2).replaceAll('.', ',')} permite cortar o cabelo ou quando desejar usando o agendamento pelo aplicativo e escolhendo dia e hora desejada quantas vezes precisar durante o mês contratado. a ${Estabelecimento.nomeLocal} não é obrigada a fazer procedimentos externos(sem agendameto prévio por mensagem ou agendamento feito pelo app. Para cancelamento, entre em contato com o responsável pela barbearia, e problemas com faturamento entre em contato com o WhatsApp: (51) 9 9328-0162. É Proíbido incluir outras pessoas nos agendamentos, além da pessoal na qual fez a contratação do plano',
                                                          style: GoogleFonts
                                                              .openSans(
                                                            textStyle:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 13,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Text(
                                          'Veja as regras',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 12,
                                              color: Colors.black54,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
