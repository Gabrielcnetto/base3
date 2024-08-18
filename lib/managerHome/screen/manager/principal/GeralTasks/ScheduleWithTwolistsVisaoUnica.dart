import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/agenda_7dias/semItems.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/modalDeEdicao.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/scheduleWithTwoLists_geralView.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ScheduleWithTwoListsVisaoUnica extends StatefulWidget {
  const ScheduleWithTwoListsVisaoUnica({Key? key}) : super(key: key);

  @override
  State<ScheduleWithTwoListsVisaoUnica> createState() =>
      _ScheduleWithTwoListsVisaoUnicaState();
}

class _ScheduleWithTwoListsVisaoUnicaState
    extends State<ScheduleWithTwoListsVisaoUnica> {
  List<int> lastSevenDays = [];
  List<String> lastSevenMonths = [];
  List<String> lastSevenWeekdays = [];

  void setDaysAndMonths() {
    initializeDateFormatting('pt_BR');
    DateTime now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      int dayOfMonth = int.parse(DateFormat('d').format(date));
      String monthName = DateFormat('MMMM', 'pt_BR').format(date);
      String weekdayName = DateFormat('EEEE', 'pt_BR').format(date);
      lastSevenDays.add(dayOfMonth);
      lastSevenMonths.add(monthName);
      lastSevenWeekdays.add(weekdayName);
    }
  }

  int? diaSelecionadoSegundo;
  String? mesSelecionadoSegundo;
  String profSelecionado = "${profList[0].nomeProf}";

  Future<void> attViewSchedule({
    required int dia,
    required String mes,
    required String proffName,
  }) async {
    print("dia selecionado: $dia e o mês é: $mes");
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadAfterSetDay(
      selectDay: dia,
      selectMonth: mes,
      proffName: profSelecionado,
    );
  }

  @override
  void initState() {
    super.initState();

    setDaysAndMonths();
    attViewSchedule(
      dia: lastSevenDays[0],
      mes: lastSevenMonths[0],
      proffName: profSelecionado,
    );
  }

  List<CorteClass> _cortesFiltrados = [];
  List<Horarios> _listaHorarios = listaHorariosEncaixev2;
  List<Horarios> _removedHours = listaHorariosEncaixev2;
  List<Profissionais> _profList = profList;
  void _fetchAndFilterData() async {
    final cortesStream = Provider.of<ManagerScreenFunctions>(
      context,
      listen: false,
    ).CorteslistaManager;

    cortesStream.listen((cortes) {
      if (cortes != null && cortes.isNotEmpty) {
        setState(() {
          _removeItemsOnce();
        });
      }
    });
  }

  void _removeItemsOnce() {
    for (int index = 0; index < listaHorariosEncaixev2.length; index++) {
      bool isInCortesFiltrados = _cortesFiltrados.any((corte) =>
          listaHorariosEncaixev2[index].horario == corte.horarioCorte);

      if (isInCortesFiltrados) {
        CorteClass corte = _cortesFiltrados.firstWhere((corte) =>
            listaHorariosEncaixev2[index].horario == corte.horarioCorte);

        if (corte.barba == true) {
          List<Horarios> removedItems = [];
          int removeCount = 4;
          int endIndex = index + removeCount;

          if (endIndex >= _removedHours.length) {
            endIndex = _removedHours.length - 1;
          }

          removedItems = _removedHours.sublist(index + 1, endIndex + 1);
          _removedHours.removeRange(index + 1, endIndex + 1);
          _removedHours.addAll(removedItems);
        }
      }
    }
  }

  int selectedIndex = 0;
  int profissionalSelecionadoIndex = 0;
  int encontrarIndiceHorario(String horarioCorte) {
    // Encontra o índice do horário na lista listaHorariosEncaixev2
    for (int i = 0; i < listaHorariosEncaixev2.length; i++) {
      if (listaHorariosEncaixev2[i].horario == horarioCorte) {
        return i; // Retorna o índice encontrado
      }
    }
    return -1; // Retorna -1 se não encontrar
  }

  void setNewView() {
    try {
      setState(() {
        secondaryView = !secondaryView;
      });
      if (secondaryView == false) {
        attViewSchedule(
          dia: lastSevenDays[0],
          mes: lastSevenMonths[0],
          proffName: profSelecionado,
        );
      } else if (secondaryView == false) {}
    } catch (e) {}
  }

  bool secondaryView = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.92,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      lastSevenDays.length,
                      (index) {
                        int day = lastSevenDays[index];
                        String month = lastSevenMonths[index];
                        String weekday = lastSevenWeekdays[index];
                        String firstLetterOfMonth = month.substring(0, 1);
                        String tresPrimeirasLetras = weekday.substring(0, 3);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              tresPrimeirasLetras,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 5),
                            InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  diaSelecionadoSegundo = day;
                                  mesSelecionadoSegundo = month;
                                });
                                attViewSchedule(
                                  dia: day,
                                  mes: month,
                                  proffName: profSelecionado,
                                );
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                alignment: Alignment.center,
                                width:
                                    MediaQuery.of(context).size.width * 0.115,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.elliptical(90, 90),
                                    bottomRight: Radius.elliptical(90, 90),
                                    topLeft: Radius.elliptical(90, 90),
                                    topRight: Radius.elliptical(90, 90),
                                  ),
                                  color: selectedIndex == index
                                      ? Colors.blue
                                      : Estabelecimento.primaryColor,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$day",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : Estabelecimento
                                                .contraPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _profList.map((profissional) {
                        int profIndex = _profList.indexOf(profissional);

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                profSelecionado = profissional.nomeProf;
                                profissionalSelecionadoIndex = profIndex;

                                if (mesSelecionadoSegundo != null) {
                                  attViewSchedule(
                                    dia: diaSelecionadoSegundo!,
                                    mes: mesSelecionadoSegundo!,
                                    proffName: profSelecionado,
                                  );
                                } else {
                                  attViewSchedule(
                                    dia: lastSevenDays[0],
                                    mes: lastSevenMonths[0],
                                    proffName: profSelecionado,
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 5,
                                horizontal: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        profissional.assetImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 2,
                                      horizontal: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: profissionalSelecionadoIndex ==
                                              profIndex
                                          ? Colors.blue
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "${profissional.nomeProf}",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: profissionalSelecionadoIndex ==
                                                  profIndex
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  child: StreamBuilder<List<CorteClass>>(
                    stream: Provider.of<ManagerScreenFunctions>(
                      context,
                      listen: true,
                    ).CorteslistaManager,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError || snapshot.data!.isEmpty) {
                        return const SemItens();
                      } else if (snapshot.hasData) {
                        final List<CorteClass>? cortes = snapshot.data;
                        final List<CorteClass> cortesFiltrados = cortes!
                            .where((corte) => corte.clientName != "extra")
                            .toList();
                        // Assuming cortesFiltrados is a List<CorteClass>

                        List<String> allHorariosExtra = [];

                        for (CorteClass corte in cortesFiltrados) {
                          allHorariosExtra.addAll(corte.horariosExtra);
                        }
                        //funcao de get para a assinatura
                        bool determineAssinatura(String horario) {
                          // Exemplo fictício: Definir que pagoComCreditos é true se o horário contém algum critério específico
                          // Ajuste a lógica conforme necessário
                          return cortesFiltrados.any((corte) =>
                              corte.horariosExtra.contains(horario) &&
                              corte.feitoporassinatura);
                        }

                        // Função para determinar o valor de pagoComCreditos
                        bool determinePagoComCreditos(String horario) {
                          // Exemplo fictício: Definir que pagoComCreditos é true se o horário contém algum critério específico
                          // Ajuste a lógica conforme necessário
                          return cortesFiltrados.any((corte) =>
                              corte.horariosExtra.contains(horario) &&
                              corte.pagoComCreditos);
                        }

                        bool determineUsoCupom(String horario) {
                          // Exemplo fictício: Definir que pagoComCreditos é true se o horário contém algum critério específico
                          // Ajuste a lógica conforme necessário
                          return cortesFiltrados.any((corte) =>
                              corte.horariosExtra.contains(horario) &&
                              corte.pagoComCupom);
                        }

                        for (String horario in allHorariosExtra) {
                          bool validacaoAssinatura =
                              determineAssinatura(horario);
                          bool pagoComCreditosValue =
                              determinePagoComCreditos(horario);
                          bool pagoComOsCupons = determineUsoCupom(horario);
                          CorteClass novaCorte = CorteClass(
                            feitoporassinatura: validacaoAssinatura,
                            pagoComCreditos: pagoComCreditosValue,
                            pagoComCupom: pagoComOsCupons,
                            easepoints: 0,
                            apenasBarba: false,
                            detalheDoProcedimento: "",
                            horariosExtra: [], // Aqui você pode definir conforme necessário
                            totalValue: 0, // Defina os valores apropriados
                            isActive: false,
                            DiaDoCorte: 0,
                            NomeMes: "null",
                            dateCreateAgendamento: DateTime.now(),
                            clientName: "Barba",
                            id: "",
                            numeroContato: "null",
                            profissionalSelect: "null",
                            diaCorte: DateTime.now(),
                            horarioCorte:
                                horario, // Aqui define o horarioCorte com cada valor de allHorariosExtra
                            barba: false,
                            ramdomCode: 0,
                          );

                          cortesFiltrados.add(novaCorte);
                        }

                        allHorariosExtra = allHorariosExtra.toSet().toList();
                        print(
                            "#3 tamanho da lista: ${allHorariosExtra.length}");
                        return Column(
                          children: _listaHorarios.map((horario) {
                            // Filtra os cortes correspondentes ao horário atual
                            List<CorteClass> cortesParaHorario = cortesFiltrados
                                .where((corte) =>
                                    corte.horarioCorte == horario.horario)
                                .toList();

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  child: TimelineTile(
                                    alignment: TimelineAlign.manual,
                                    lineXY: 0,
                                    axis: TimelineAxis.vertical,
                                    indicatorStyle: IndicatorStyle(
                                      color: Colors.grey.shade300,
                                      height: 5,
                                    ),
                                    beforeLineStyle: LineStyle(
                                      color: Colors.grey.shade300,
                                      thickness: 2,
                                    ),
                                    endChild: Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 100,
                                                child: Text(
                                                  horario.horario,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                              width:
                                                  10), // Espaçamento entre horário e conteúdo

                                          // Verifica se há cortes para o horário atual
                                          cortesParaHorario.isNotEmpty
                                              ? Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: cortesParaHorario
                                                        .map((corte) {
                                                      return corte.clientName ==
                                                              "Barba"
                                                          ? Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.2,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: corte.pagoComCupom ==
                                                                            true ||
                                                                        corte
                                                                            .pagoComCreditos ||
                                                                        corte
                                                                            .feitoporassinatura
                                                                    ? Colors
                                                                        .orange
                                                                        .shade600
                                                                    : Colors
                                                                        .blue,
                                                              ),
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                              child:
                                                                  const Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                child: Text(
                                                                  "",
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        AppRoutesApp
                                                                            .ModalDeEdicao,
                                                                        arguments:
                                                                            corte);
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            20),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: corte.pagoComCupom ||
                                                                        corte
                                                                            .pagoComCreditos ||
                                                                        corte
                                                                            .feitoporassinatura
                                                                    ? MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.22
                                                                    : MediaQuery
                                                                            .of(
                                                                          context,
                                                                        ).size.height *
                                                                        0.2,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius: corte
                                                                              .barba ==
                                                                          true
                                                                      ? const BorderRadius
                                                                          .only(
                                                                          topLeft:
                                                                              Radius.circular(10),
                                                                          topRight:
                                                                              Radius.circular(10),
                                                                        )
                                                                      : BorderRadius
                                                                          .circular(
                                                                          10,
                                                                        ),
                                                                  color: corte.pagoComCupom ||
                                                                          corte
                                                                              .pagoComCreditos ||
                                                                          corte.feitoporassinatura ==
                                                                              true
                                                                      ? Colors
                                                                          .orange
                                                                          .shade600
                                                                      : Colors
                                                                          .blue,
                                                                ),
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.7,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "ínicio: ${corte.horarioCorte}",
                                                                            style:
                                                                                GoogleFonts.openSans(
                                                                              textStyle: const TextStyle(
                                                                                fontSize: 13,
                                                                                color: Colors.white70,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          if (corte.pagoComCupom ||
                                                                              corte.pagoComCreditos ||
                                                                              corte.feitoporassinatura)
                                                                            Container(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(8),
                                                                                color: Colors.white,
                                                                                border: Border.all(
                                                                                  width: 0.5,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              child: Text(
                                                                                corte.pagoComCreditos == true
                                                                                    ? 'Pago pelo App'
                                                                                    : corte.feitoporassinatura == true
                                                                                        ? 'Assinante'
                                                                                        : corte.pagoComCupom == true
                                                                                            ? "Grátis, Troca de cupom"
                                                                                            : '',
                                                                                style: GoogleFonts.openSans(
                                                                                  textStyle: const TextStyle(fontSize: 13, color: Colors.black, fontStyle: FontStyle.italic),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            corte.detalheDoProcedimento,
                                                                            style:
                                                                                GoogleFonts.openSans(
                                                                              textStyle: const TextStyle(
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            corte.clientName,
                                                                            style:
                                                                                GoogleFonts.openSans(
                                                                              textStyle: TextStyle(
                                                                                fontWeight: FontWeight.w700,
                                                                                fontSize: 16,
                                                                                color: Estabelecimento.primaryColor,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).pushNamed(AppRoutesApp.ModalDeEdicao, arguments: corte);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              padding: const EdgeInsets.all(5),
                                                                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                                                              child: const Icon(
                                                                                Icons.open_in_new,
                                                                                size: 18,
                                                                                color: Colors.black,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                    }).toList(),
                                                  ),
                                                )
                                              : Expanded(
                                                  // Se não houver cortes, exibe "Horário Disponível"
                                                  child: Container(
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade200,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        "Horário Disponível",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 14,
                                                          color: Colors.black54,
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
                              ],
                            );
                          }).toList(),
                        );
                      }
                      return Container(); // Pode retornar um Container vazio ou outro widget de acordo com o seu caso.
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
