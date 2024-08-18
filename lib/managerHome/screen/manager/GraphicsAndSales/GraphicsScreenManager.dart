import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/componentes/FaturamentoMesSelecionado.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/componentes/detailsList.dart';
import 'package:easebase/rotas/Approutes.dart';

class GraphicsManagerScreen extends StatefulWidget {
  final String mesSelecionado;
  const GraphicsManagerScreen({
    super.key,
    required this.mesSelecionado,
  });

  @override
  State<GraphicsManagerScreen> createState() => _GraphicsManagerScreenState();
}

class _GraphicsManagerScreenState extends State<GraphicsManagerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadTotalFaturamentoAtualMes();
  }

  bool loadingPrincipalFaturamento = false;
  int faturamentoExibido = 0;
  Future<void> loadTotalFaturamentoAtualMes() async {
    setState(() {
      loadingPrincipalFaturamento = true;
    });
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoBarbeariaSelectMenu(
            mesSelecionado: widget.mesSelecionado == "Clique"
                ? monthName.toLowerCase()
                : widget.mesSelecionado.toLowerCase());

    setState(() {
      faturamentoExibido = totalFaturamentoGet;
      loadingPrincipalFaturamento = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: loadingPrincipalFaturamento == false
            ? Padding(
                padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacementNamed(
                                  AppRoutesApp.HomeScreen01);
                            },
                            child: const Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Estatísticas Mensais",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.asset(
                                Estabelecimento.urlLogo,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      FaturamentoMesSelecionado(
                        mesInicial: widget.mesSelecionado,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const CardWithDetailsView(),
                    ],
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
      ),
    );
  }
}
