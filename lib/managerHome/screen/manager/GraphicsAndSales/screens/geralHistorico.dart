import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/rankingProviderHome.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/itensHistoricoGeral.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/modalDeEdicaoHistoricoGeral.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class HistoricoCompletoClientes extends StatefulWidget {
  const HistoricoCompletoClientes({super.key});

  @override
  State<HistoricoCompletoClientes> createState() =>
      _HistoricoCompletoClientesState();
}

class _HistoricoCompletoClientesState extends State<HistoricoCompletoClientes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<RankingProvider>(context, listen: false)
        .loadingListUsersHistoricoCompleto();
    loadListUsers();
  }

  List<CorteClass> listadeCortes = [];
  bool prontoParaExibir = false;
  Future<void> loadListUsers() async {
    try {
      List<CorteClass> userList =
          await Provider.of<RankingProvider>(context, listen: false)
              .historicoCompletoAllcuts;
      print("#787: dentro do set ${userList.length}");

      setState(() {
        listadeCortes = userList;
        prontoParaExibir = true;
      });
    } catch (e) {
      print("ao setar a lista deu este erro:$e");
    }
  }

  int diaAtualDayInt = DateTime.now().day;
  DateTime diaAtual = DateTime.now();
  int mesAtual = DateTime.now().month;

  _launchURL(String url) async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey.shade700,
                        size: 20,
                      ),
                    ),
                    Text(
                      "Histórico completo mensal",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontSize: 17,
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: Colors.grey.shade700,
                      size: 20,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 35),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Detalhes",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: Colors.grey.shade800,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Mais recente primeiro",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: Provider.of<RankingProvider>(context, listen: true)
                      .CorteslistaManager,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    if (snapshot.hasData) {
                      final List<CorteClass>? cortes = snapshot.data;

                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: cortes?.length ?? 0,
                            itemBuilder: (context, index) {
                              final item = cortes![index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(8),
                                splashColor: Colors.grey.shade100,
                                onTap: () {
                                  Navigator.of(context).push(DialogRoute(context: context, builder: (ctx){
                                    return ModalDeEdicaoHistoricoGeral(infoRoutes: item,);
                                  }));
                                },
                                child: ItemHistoricoGeral(
                                  corteClassItem: item,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Erro ao carregar, ou sem dados',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                    return const Text('teste');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
