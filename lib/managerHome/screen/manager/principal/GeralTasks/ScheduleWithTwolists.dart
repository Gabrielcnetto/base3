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
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/ScheduleWithTwolistsVisaoUnica.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/modalDeEdicao.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/scheduleWithTwoLists_geralView.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ScheduleWithTwoLists extends StatefulWidget {
  const ScheduleWithTwoLists({Key? key}) : super(key: key);

  @override
  State<ScheduleWithTwoLists> createState() => _ScheduleWithTwoListsState();
}

class _ScheduleWithTwoListsState extends State<ScheduleWithTwoLists> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Calendário",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Agenda completa",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: setNewView,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Mudar visualização",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                secondaryView == false
                    ? const ScheduleWithTwoListsVisaoUnica()
                    : const ScheduleWithTwoListsVer2Profissionais(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
