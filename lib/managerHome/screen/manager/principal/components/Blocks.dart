import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/managerHome/screen/manager/principal/visao_clientesPlano/clientesComAssinaturas.dart';
import 'package:easebase/managerHome/screen/profile/profileScreen.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BlocksManagerComponent extends StatefulWidget {
  const BlocksManagerComponent({super.key});

  @override
  State<BlocksManagerComponent> createState() => _BlocksManagerComponentState();
}

class _BlocksManagerComponentState extends State<BlocksManagerComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadClientes();
    loadTotalClientes();
    totalCortesNomES;
    loadTotalcortesmes();
    totalClientes;
    mesAtual;
    loadAtualMonth();
    loadTotalFaturamento();
    loadTotalCortes();
  }

  int? totalClientes;
  void loadTotalClientes() async {
    List<GeralUser> listClientes =
        await Provider.of<ManagerScreenFunctions>(context, listen: false)
            .clientesLista;

    setState(() {
      totalClientes = listClientes.length;
    });
    print("o tamanho é ${totalClientes}");
  }
  //

  int? totalCortesNomES;
  void loadTotalcortesmes() async {
    List<CorteClass> listCortesfinal =
        await Provider.of<ManagerScreenFunctions>(context, listen: false)
            .listaCortes;

    setState(() {
      totalCortesNomES = listCortesfinal.length;
      loadAssinatura1();
      loadSaques();
    });
  }
  //total para saque

  double valorAssinatura1 = 0;
  Future<void> loadAssinatura1() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .gettTotalemAssinaturasParaSaque();
    setState(() {
      valorAssinatura1 = PointOfClient!.toDouble();
      calculoReducaoFaturamentoPorAssinaturas();
    });
  }

  double totalSaquedisponivel = 0;
  Future<void> loadSaques() async {
    double? PointOfClient =
        await Provider.of<MyProfileScreenFunctions>(context, listen: false)
            .valorpossiveldesaque();
    setState(() {
      totalSaquedisponivel = PointOfClient!.toDouble();
    });
  }

  double faturamentofinalSemAssinaturas = 0;
  void calculoReducaoFaturamentoPorAssinaturas() {
    setState(() {
      faturamentofinalSemAssinaturas = (totalFaturamento - valorAssinatura1);
    });
  }

  String? mesAtual;
  Future<void> loadAtualMonth() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);

    setState(() {
      mesAtual = monthName;
    });
  }

  //faturamento total
  int totalFaturamento = 0;
  Future<void> loadTotalFaturamento() async {
    int totalFaturamentoGet =
        await ManagerScreenFunctions().loadFaturamentoBarbearia();

    setState(() {
      totalFaturamento = totalFaturamentoGet;
      calculoReducaoFaturamentoPorAssinaturas();
    });
  }

  //total cortes
  int totalCortes = 0;
  Future<void> loadTotalCortes() async {
    int totalCortesGet = await ManagerScreenFunctions().TotalcortesMes();

    setState(() {
      totalCortes = totalCortesGet;
    });
  }
void sendMessageWhatsApp() async {
                                              if (await canLaunch(
                                                  "https://wa.me/${5551993280162}")) {
                                                await launch(
                                                    "https://wa.me/${5551993280162}");
                                              } else {
                                                throw 'Não foi possível abrir o link';
                                              }
                                            }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        //  color: Colors.red,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${totalClientes}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Clientes cadastrados",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.cut,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  totalCortes > 1
                                      ? "${totalCortes} cortes"
                                      : "${totalCortes} corte",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Agendados em ${mesAtual ?? "Carregando..."}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.paid,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "R\$${totalFaturamento.toStringAsFixed(2).replaceAll('.', ',') ?? 00}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Faturamento esperado",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
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
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          DialogRoute(
                            context: context,
                            builder: (ctx) =>
                                const ClientesComAssinaturaGeralScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: Icon(
                                Icons.credit_card,
                                color: Colors.grey.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                "R\$${valorAssinatura1.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total em mensalidades",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 15,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (ctx) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            size: 20,
                                            color: Colors.grey.shade400,
                                          ),
                                          Text(
                                            'Voltar',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Transações & Informações importantes',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Taxa de depósitos:',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Cada depósito feito por cliente na carteira e também na cobraça da assinatura, é cobrada uma taxa de 1,2% a cada pagamento. Este valor é reduzido conforme mais pagamentos forem sendo adicionados por clientes.',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Como receber os valores',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'A Easecorte vai gerir todos os pagamentos e assinaturas de forma automática, e o depósito dos saques + assinaturas de seus clientes serão depositados na conta do gerente da ${Estabelecimento.nomeLocal} sempre até o dia 5 de cada mês',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    //
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Suporte e adiantamentos',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            'Estorno de valores(para clientes), problemas de depósitos ou adiantamento de saques são possíveis sem cobranças adicionais. Basta solicitar pelo contato oficial da Easecorte por WhatsApp',
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            sendMessageWhatsApp();
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade600,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 10,
                                              horizontal: 10,
                                            ),
                                            child: Text(
                                              'Entre em contato',
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
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
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.center,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(45),
                              ),
                              child: Icon(
                                Icons.currency_exchange,
                                color: Colors.grey.shade700,
                                size: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "R\$${totalSaquedisponivel.toStringAsFixed(2).replaceAll('.', ',')}",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 24,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Saque de Saldo",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_right,
                                  size: 15,
                                  color: Colors.grey.shade400,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(AppRoutesApp.GraphicsManagerScreen);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 26, 82, 118),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Veja o resumo do estabelecimento",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //view screen graphic - DIVISAO
                Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              AppRoutesApp.ProfileScreenManagerWithScafol);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Editar Perfil",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
