import 'dart:async';
import 'dart:math';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/classes/procedimentos_extras.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/functions/horariosComuns.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/usuarioDeslogado/screen/add/confirmscreen/ConfirmScreenCorte.dart';
import 'package:provider/provider.dart';

class AddScreenUserDeslogado extends StatefulWidget {
  const AddScreenUserDeslogado({super.key});

  @override
  State<AddScreenUserDeslogado> createState() => _AddScreenUserDeslogadoState();
}

class _AddScreenUserDeslogadoState extends State<AddScreenUserDeslogado> {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userName;
    loadUserName();
    LoadPriceAdicionalBarba();
    phoneNumber;
    loadUserPhone();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getFolga;
    DataFolgaDatabase;
    LoadFolgaDatetime;
    LoadPrice();
    LoadPriceAdicionalIndex2();
    LoadPriceAdicionalIndex3();
    LoadPriceAdicionalIndex4();
    LoadPriceAdicionalIndex5();
  }

  int? index5Value;
  Future<void> LoadPriceAdicionalIndex5() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalindex5();
    print("pegamos a data do databse");

    setState(() {
      index5Value = priceDB ?? 00;
      setandoTodosOsValores();
    });
  }

  int? index4Value;
  Future<void> LoadPriceAdicionalIndex4() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalindex4();
    print("pegamos a data do databse");

    setState(() {
      index4Value = priceDB ?? 00;
      setandoTodosOsValores();
    });
  }

  int? index3Value;
  Future<void> LoadPriceAdicionalIndex3() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalindex3();
    print("pegamos a data do databse");

    setState(() {
      index3Value = priceDB ?? 00;
      setandoTodosOsValores();
    });
  }

  int? index2Value;
  Future<void> LoadPriceAdicionalIndex2() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalindex2();
    print("pegamos a data do databse");

    setState(() {
      index2Value = priceDB ?? 00;
      setandoTodosOsValores();
    });
  }

  bool barba = false;

  void barbaTrue() {
    if (barba == false) {
      setState(() {
        barba = true;
        valorFinalCobrado = (atualPrice! + barbaPriceFinal!);
        detalheDoProcedimento = "Corte Normal + Barba";
      });
    }
    print("#8 valor final ficou: ${valorFinalCobrado}");
    print("#8 valor final frase: ${detalheDoProcedimento}");
  }

  void barbaFalse() {
    setState(() {
      valorFinalCobrado = atualPrice!;
      detalheDoProcedimento = "Corte Normal";
    });
    if (barba == true) {
      setState(() {
        barba = false;
        valorFinalCobrado = atualPrice!;
      });
    }
    print("#8 valor final ficou: ${valorFinalCobrado}");
    print("#8 valor final frase: ${detalheDoProcedimento}");
  }

  final List<Profissionais> _profList = profList;
  bool isBarbeiro1 = false;
  bool isBarbeiro2 = false;
  bool isBarbeiro3 = false;
  void setBarber1() {
    if (isBarbeiro1 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro1 = true;
        isBarbeiro2 = false;
        isBarbeiro3 = false;
        dataSelectedInModal = null;
      });
    }
  }

  void setBarber2() {
    if (isBarbeiro2 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro2 = true;
        isBarbeiro1 = false;
        isBarbeiro3 = false;
        dataSelectedInModal = null;
      });
    }
  }

  void setBarber3() {
    if (isBarbeiro3 == true) {
      null;
    } else {
      setState(() {
        isBarbeiro3 = true;
        isBarbeiro2 = false;
        isBarbeiro1 = false;
        dataSelectedInModal = null;
      });
    }
  }

  DateTime? dataSelectedInModal;
  DateTime? DataFolgaDatabase;
  Future<void> LoadFolgaDatetime() async {
    DateTime? dataDoDatabaseVolta = await ManagerScreenFunctions().getFolga();
    print("pegamos a data do databse");
    if (DataFolgaDatabase != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      DataFolgaDatabase = dataDoDatabaseVolta;
    });
  }

  Future<void> ShowModalData() async {
    setState(() {
      dataSelectedInModal = null;
    });
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 14),
      ),
      selectableDayPredicate: (DateTime day) {
        // Desativa domingos
        if (day.weekday == DateTime.sunday) {
          return false;
        }
        // Bloqueia a data contida em dataOffselectOfManger
        if (DataFolgaDatabase != null &&
            day.year == DataFolgaDatabase!.year &&
            day.month == DataFolgaDatabase!.month &&
            day.day == DataFolgaDatabase!.day) {
          return false;
        }
        return true;
      },
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dataSelectedInModal = selectUserDate;
            loadListCortes();
          });
        }
      } catch (e) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Erro'),
              content: Text("${e}"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o modal
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  int selectedIndex = -1;
  Map<int, Color> itemColors = {};
  Map<int, Color> _textColor = {};

  //controlers
  final nomeControler = TextEditingController();
  final numberControler = TextEditingController();

  String? userName;
  Future<void> loadUserName() async {
    String? usuario = await MyProfileScreenFunctions().getUserName();

    if (userName != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      userName = usuario;
      setDataControlers();
      LoadFolgaDatetime();
    });
  }

  //
  String? phoneNumber;
  Future<void> loadUserPhone() async {
    String? number = await MyProfileScreenFunctions().getPhone();

    if (phoneNumber != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      phoneNumber = number;
      setPhone();
    });
  }

  void setPhone() {
    numberControler.text = phoneNumber!;
  }

  void setDataControlers() {
    setState(() {
      nomeControler.text = userName!;
    });
  }

  int atualPrice = 0;

  Future<void> LoadPrice() async {
    int? priceDB = await ManagerScreenFunctions().getPriceCorte();
    print("pegamos a data do databse");

    setState(() {
      atualPrice = priceDB!;
      valorFinalCobrado = priceDB!;
      LoadPriceAdicionalBarba();
    });
  }

  int? barbaPriceFinal;
  int valorFinalCobrado = 0;
  Future<void> LoadPriceAdicionalBarba() async {
    int? priceDB = await ManagerScreenFunctions().getAdicionalBarbaCorte();
    print("pegamos a data do databse");

    setState(() {
      apenasBarbaValue = priceDB!;
      barbaPriceFinal = priceDB!;
    });
  }

  void lembreteSemConta() async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Você ainda não tem uma conta?",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            content: Text(
              "Sem uma conta você não ganhará pontos nem entrará no ranking da ${Estabelecimento.nomeLocal}",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Continuar sem conta",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutesApp.RegisterAccountScreen,
                    (route) => false,
                  );

                  return;
                },
                child: Text(
                  "Criar Conta",
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  String profissionalSelecionado = '';
  String? hourSetForUser;
  List<Horarios> _horariosPreenchidosParaEvitarDupNoCreate =
      []; // a lista que tem todos os horariso preenchidos
  Future<void> CreateAgendamento() async {
    //Horarios da semana comum
    List<Horarios> _horariosSemana =
        listaHorariosEncaixe; // essa aqui usamos para enviar 2 horarios a mais com barba true

    await initializeDateFormatting('pt_BR');

    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(dataSelectedInModal!);
    var rng = new Random();
    int number = rng.nextInt(90000) + 10000;
    int diaDoCorte = dataSelectedInModal!.day;

    // Encontrar o índice do horário selecionado na lista _horariosSemana
    int selectedIndex = _horariosSemana
        .indexWhere((horario) => horario.horario == hourSetForUser);

    // Verificar se a variável barba é verdadeira
    bool tembarba = await barba;
    List<String> horariosExtras = [];
    if (tembarba == true) {
      print("tem a barba estou aqui");
      if (selectedIndex != -1 && selectedIndex + 2 < _horariosSemana.length) {
        print("pós barba true");
        for (int i = 1; i <= 2; i++) {
          print("dentro do for");
          String horarioExtra = _horariosSemana[selectedIndex + i].horario;
          // Verificar se o horário extra está presente na lista de horários preenchidos
          bool horarioJaPreenchido = _horariosPreenchidosParaEvitarDupNoCreate
              .any((horario) => horario.horario == horarioExtra);
          print("podemos marcar? ${horarioJaPreenchido}");
          if (horarioJaPreenchido == true) {
            // Mostrar um dialog para o usuário selecionar outro horário
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'Horário Indisponível',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Estabelecimento.primaryColor,
                      ),
                    ),
                  ),
                  content: Text(
                    'Este horário está reservado para corte e barba por outro cliente, então só podemos agendar para corte de cabelo. Por favor, escolha outro horário.',
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Estabelecimento.primaryColor,
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop(); // Fechar o dialog
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Estabelecimento.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Escolher outro',
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );

            // Abortar a adição ao provider
            return;
          }

          horariosExtras.add(horarioExtra);
        }
      }
    }

    Navigator.of(context).push(DialogRoute(
      context: context,
      builder: (ctx) => const ConfirmScreenCorteDeslogado(),
    ));
    Provider.of<CorteProvider>(context, listen: false)
        .AgendamentoCortePrincipalFunctions(
      valorMultiplicador: 0,
      barbaHoraExtra: barba,
      pricevalue: valorFinalCobrado,
      nomeBarbeiro: profissionalSelecionado,
      corte: CorteClass(
        feitoporassinatura: false,
        pagoComCreditos: false,
        pagoComCupom: false,
        easepoints: 0,
        apenasBarba: apenasBarba,
        detalheDoProcedimento: detalheDoProcedimento ?? "Corte Normal",
        horariosExtra: horariosExtras,
        totalValue: valorFinalCobrado,
        isActive: true,
        DiaDoCorte: diaDoCorte,
        NomeMes: monthName,
        dateCreateAgendamento: DateTime.now(),
        ramdomCode: number,
        clientName: nomeControler.text,
        id: Random().nextDouble().toString(),
        numeroContato: numberControler.text,
        barba: barba,
        diaCorte: dataSelectedInModal!,
        horarioCorte: hourSetForUser!,
        profissionalSelect: profissionalSelecionado,
      ),
      selectDateForUser: dataSelectedInModal!,
    );
    if (phoneNumber != null && numberControler.text != "") {
      print("#77 entrei na funcao do manychat");
      int year = dataSelectedInModal!.year;
      int month = dataSelectedInModal!.month;
      int day = dataSelectedInModal!.day;

      DateFormat horaFormat = DateFormat('HH:mm');
      DateTime hora = horaFormat.parse(hourSetForUser!);

      //
      DateTime dateFirts = DateTime(year, month, day, hora.hour, hora.minute);
      //
      try {
        print("#77 entrei no primeiro try");
        await Provider.of<ManyChatConfirmation>(context, listen: false)
            .setClientsManyChat(
          dateSchedule: dateFirts,
          userPhoneNumber: numberControler.text,
          username: nomeControler.text,
          externalId: Random().nextDouble().toInt(),
        );
        print("#77 primeira funcao feita");
        // Incluir minuto da hora extraída
        DateTime finalDatetime =
            DateTime(year, month, day, hora.hour, hora.minute);
        print("#77 comecando segunda funaco");
        await Provider.of<ManyChatConfirmation>(context, listen: false)
            .ScheduleMessage(
                phoneNumber: numberControler.text, finalDate: finalDatetime);
        print("#77 finalizei segunda funcao");
      } catch (e) {}
    }
    try {
      await Provider.of<HorariosComuns>(context, listen: false).postHours(
        horarioEscolhido: hourSetForUser ?? "",
      );
      print("#77 entrei na funcao do manychat");
      print("evento enviado");
    } catch (e) {
      print("erro ao enviar evento: $e");
    }
  }

  final _formKey = GlobalKey<FormState>();
  //Fazendo o filtro para exibir quais horarios estao disponíveis
  List<Horarios> _horariosLivresSabados = sabadoHorarios;
  List<Horarios> _horariosLivres = hourLists;
  List<Horarios> horarioFinal = [];
  bool prontoParaExibir = true;
  //Aqui pegamos o dia selecionado, e usamos para buscar os dados no banco de dados
  //a funcao abaixo é responsavel por pegar o dia, entrar no provider e pesquisar os horarios daquele dia selecionado
  Future<void> loadListCortes() async {
    setState(() {
      prontoParaExibir = false;
    });
    horarioFinal.clear();
    List<Horarios> listaTemporaria = [];
    int? diaSemanaSelecionado = dataSelectedInModal?.weekday;

    if (diaSemanaSelecionado == 6) {
      // Se for sábado, copia os horários disponíveis para sábado
      listaTemporaria.addAll(_horariosLivresSabados);
    } else {
      // Se não for sábado, copia os horários disponíveis padrão
      listaTemporaria.addAll(_horariosLivres);
    }

    DateTime? mesSelecionado = dataSelectedInModal;

    if (mesSelecionado != null) {
      try {
        await Provider.of<CorteProvider>(context, listen: false)
            .loadCortesDataBaseFuncionts(
                mesSelecionado: mesSelecionado,
                DiaSelecionado: mesSelecionado.day,
                Barbeiroselecionado: isBarbeiro1
                    ? "${profList[0].nomeProf}"
                    : isBarbeiro2
                        ? "${profList[1].nomeProf}"
                        : "Não Definido");
        List<Horarios> listaCort =
            await Provider.of<CorteProvider>(context, listen: false)
                .horariosListLoad;

        for (var horario in listaCort) {
          print("horarios do provider: ${horario.horario}");

          listaTemporaria.removeWhere((atributosFixo) {
            return atributosFixo.horario == horario.horario;
          });
          _horariosPreenchidosParaEvitarDupNoCreate.add(Horarios(
              horario: horario.horario, id: horario.id, quantidadeHorarios: 1));
        }
        setState(() {
          horarioFinal = List.from(listaTemporaria);
        });
        setState(() {
          prontoParaExibir = true;
        });

        print("este e o tamanho da lista final: ${horarioFinal.length}");
      } catch (e) {
        print("nao consegu realizar, erro: ${e}");
      }
    } else {
      print("problemas na hora ou dia");
    }
  }

  void showModalConfirmAgend() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1,
              padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 22,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Resumo do agendamento",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Revise os dados",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Estabelecimento.secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(217, 217, 217, 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //nome
                          Text(
                            "Nome do Cliente",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            nomeControler.text,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),

                          //contato
                          Text(
                            "Contato",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            numberControler.text,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //data
                          const SizedBox(
                            height: 15,
                          ),
                          //contato
                          Text(
                            "Data",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            DateFormat("dd/MM/yyy")
                                .format(dataSelectedInModal!),
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          //Horario
                          Text(
                            "Horário",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),
                          Text(
                            hourSetForUser!,
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //profissional
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Profissional",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(144, 144, 144, 1),
                              ),
                            ),
                          ),

                          Text(
                            isBarbeiro1 == true
                                ? "${profList[0].nomeProf}"
                                : isBarbeiro2 == true
                                    ? "${profList[1].nomeProf}"
                                    : "Não Definido",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () {
                      CreateAgendamento();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Estabelecimento.primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Agendar",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                color: Estabelecimento.contraPrimaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Estabelecimento.contraPrimaryColor,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //tudo relacionado a servicos adicionais
  bool verServicosAdicionais = false;
  void ativarServicosAdicionais() {
    setState(() {
      verServicosAdicionais = !verServicosAdicionais;
    });
  }

  //valores adicionais - inicio
  void setandoTodosOsValores() {
    setState(() {
      apenasBarbaValue = barbaPriceFinal;
      limpezaDePele = index2Value;
      locaoDePele = index3Value;
      adicionalBarboTerapia = index4Value;
      adicionalBarbaExpress = index5Value;
    });
  }

  //valorFinalCobrado < este valor deve ser enviado fixo na funcao de enviar ao db (agora valida com barba pois tem apenas 2 proced.)
  int? apenasBarbaValue = 0; //somente barba selecionada - pendente
  int? limpezaDePele = 0; //extra
  int? locaoDePele = 0; //extra
  int? adicionalBarboTerapia =
      0; // valor do corte(db) + barboterapia - pendente
  int? adicionalBarbaExpress =
      0; // valor do corte(db) + barboexpress - pendente
// padrao ja carregado do database
  //valores adicionais - fim

  String? detalheDoProcedimento;
  void FraseCreatedetalheDoProcedimento() {
    String fraseMontadaFinal = "";
    setState(() {
      detalheDoProcedimento = "";
    });
    try {
      //apenas o corte esta selecionado
      if (barba == true && procedimento0 == true) {
        setState(() {
          fraseMontadaFinal = "Corte e Barba normal";
        });
      }
      if (procedimento0 == true &&
          procedimento1 == false &&
          procedimento2 == false &&
          procedimento3 == false &&
          procedimento4 == false &&
          procedimento5 == false) {
        setState(() {
          fraseMontadaFinal = "Apenas corte";
        });
      }
      //apenas barba selecionada
      if (apenasBarba == true) {
        setState(() {
          fraseMontadaFinal = "Apenas barba";
        });
      }
      //cabelo e limpeza de pele
      if (procedimento0 == true && procedimento2 == true) {
        setState(() {
          fraseMontadaFinal = "Corte + Limpeza Pele";
        });
      }
      //cabelo e loção de pele
      if (procedimento0 == true && procedimento3 == true) {
        setState(() {
          fraseMontadaFinal = "Corte + Loção";
        });
      }
      //cabelo e barboterapia
      if (procedimento4 == true) {
        setState(() {
          fraseMontadaFinal = "Corte e Barboterapia";
        });
      }
      //cabelo e barboexpress
      if (procedimento5 == true) {
        print("adicionalBarbaExpress: ${adicionalBarbaExpress}");
        setState(() {
          fraseMontadaFinal = "Corte e Barbaexpress";
        });
      }

      setState(() {
        detalheDoProcedimento = fraseMontadaFinal;
      });
      print("#8 a frase final ficou: ${detalheDoProcedimento}");
    } catch (e) {
      print("erro ao montar a frase: $e");
    }
  }

  void verificandoEsetandoValorTotal() async {
    int valorAserCobradoTotalFinal = 0;

    setState(() {
      valorFinalCobrado = 0;
    });
    try {
      //apenas o corte esta selecionado
      if (barba == true && procedimento0 == true) {
        setState(() {
          valorAserCobradoTotalFinal = (atualPrice + barbaPriceFinal!);
        });
      }
      if (procedimento0 == true &&
          procedimento1 == false &&
          procedimento2 == false &&
          procedimento3 == false &&
          procedimento4 == false &&
          procedimento5 == false) {
        setState(() {
          valorAserCobradoTotalFinal = atualPrice ?? 0;
        });
      }
      //apenas barba selecionada
      if (apenasBarba == true) {
        setState(() {
          valorAserCobradoTotalFinal = apenasBarbaValue ?? 0;
        });
      }
      //cabelo e limpeza de pele
      if (procedimento0 == true && procedimento2 == true) {
        setState(() {
          valorAserCobradoTotalFinal = (atualPrice + (limpezaDePele ?? 00));
        });
      }
      //cabelo e loção de pele
      if (procedimento0 == true && procedimento3 == true) {
        setState(() {
          valorAserCobradoTotalFinal = (atualPrice + (locaoDePele ?? 00));
        });
      }
      //cabelo e barboterapia
      if (procedimento4 == true) {
        setState(() {
          valorAserCobradoTotalFinal = (atualPrice + adicionalBarboTerapia!);
        });
      }
      //cabelo e barboterapia
      if (procedimento5 == true) {
        print("adicionalBarbaExpress: ${adicionalBarbaExpress}");
        setState(() {
          valorAserCobradoTotalFinal = (atualPrice + adicionalBarbaExpress!);
        });
      }

      setState(() {
        valorFinalCobrado = valorAserCobradoTotalFinal;
        FraseCreatedetalheDoProcedimento();
      });
      print("#8o valor final cobrado será de: ${valorFinalCobrado}");
    } catch (e) {
      print("ao adicionar o valor a ser cobrado, deu isto: $e");
    }
  }

  bool apenasBarba =
      false; // apenas a barba (usado para verificações, mas tambem pode ser usado em outras funcoes)
  bool procedimento0 = true; //corte padrao
  bool procedimento1 = false; //apenas a barba
  bool procedimento2 = false; //limpeza de pele
  bool procedimento3 = false; // loção de pele
  bool procedimento4 = false; // corte +barboterapia
  bool procedimento5 = false; //corte +barbaexpress
  List<Procedimentos_Extras> _procedimentos = procedimentosLista;

  @override
  Widget build(BuildContext context) {
    final widhScren = MediaQuery.of(context).size.width;
    final heighScreen = MediaQuery.of(context).size.height;
    return Container(
      width: widhScren,
      height: heighScreen,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: widhScren,
              height: 180,
              child: Image.asset(
                Estabelecimento.bannerInitial,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(50, 50),
                    topRight: Radius.elliptical(50, 50),
                  ),
                ),
                width: widhScren,
                height: heighScreen / 1.35,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Agendamento de Horários",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Preencha os dados abaixo para efetuar o seu agendamento",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Estabelecimento.secondaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 10, right: 10),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //CONTAINER DO NOME inicio
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Estabelecimento.secondaryColor
                                            .withOpacity(0.4)),
                                    child: const Text("1"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Nome do Cliente",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o seu nome';
                                    }
                                    return null;
                                  },
                                  controller: nomeControler,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              //CONTAINER DO NOME fim
                              //CONTAINER DO NUMERO
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Estabelecimento.secondaryColor
                                            .withOpacity(0.4)),
                                    child: const Text("2"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Telefone de contato",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite o seu telefone';
                                    }
                                    return null;
                                  },
                                  controller: numberControler,
                                  decoration: const InputDecoration(
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              //CONTAINER DO NUMERO
                              //PROCEDIMENTOS EXTRAS - INICIO
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Estabelecimento.primaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "serviços adicionais",
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            InkWell(
                                              onTap: ativarServicosAdicionais,
                                              child: Text(
                                                "Clique aqui",
                                                style: GoogleFonts.openSans(
                                                  textStyle: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                              onTap: ativarServicosAdicionais,
                                              child: Container(
                                                alignment: Alignment.center,
                                                padding:
                                                    const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  verServicosAdicionais == false
                                                      ? Icons.arrow_drop_down
                                                      : Icons.arrow_drop_up,
                                                  color: Estabelecimento
                                                      .primaryColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    //Container dos procedimentos(1) - inicio
                                    if (verServicosAdicionais == true)
                                      Column(
                                        children: _procedimentos
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          var item = entry.value;
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${item.name} - ",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.paid,
                                                              color:
                                                                  Colors.green,
                                                              size: 15,
                                                            ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        0]
                                                                    .name)
                                                              Text(
                                                                "R\$${atualPrice}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        1]
                                                                    .name)
                                                              Text(
                                                                "R\$${barbaPriceFinal}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        2]
                                                                    .name)
                                                              Text(
                                                                "R\$${index2Value}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        3]
                                                                    .name)
                                                              Text(
                                                                "R\$${index3Value}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        4]
                                                                    .name)
                                                              Text(
                                                                "R\$${index4Value}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                            if (item.name ==
                                                                _procedimentos[
                                                                        5]
                                                                    .name)
                                                              Text(
                                                                "R\$${index5Value}",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  textStyle:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .white54,
                                                                  ),
                                                                ),
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      // Atualiza o estado dos procedimentos
                                                      setState(() {
                                                        // Define todos como false primeiro
                                                        procedimento0 = false;
                                                        procedimento1 = false;
                                                        procedimento2 = false;
                                                        procedimento3 = false;
                                                        procedimento4 = false;
                                                        procedimento5 = false;

                                                        // Define o procedimento atual como true
                                                        switch (index) {
                                                          case 0:
                                                            procedimento0 =
                                                                true;
                                                            barba = false;
                                                            setState(() {
                                                              apenasBarba =
                                                                  false;
                                                              verificandoEsetandoValorTotal();
                                                            });
                                                            break;
                                                          case 1:
                                                            procedimento1 =
                                                                true;
                                                            barba = false;
                                                            setState(() {
                                                              apenasBarba =
                                                                  true;
                                                              verificandoEsetandoValorTotal();
                                                            });
                                                            break;
                                                          case 2:
                                                            procedimento2 =
                                                                true;
                                                            barba = false;
                                                            procedimento0 =
                                                                true;
                                                            setState(() {
                                                              apenasBarba =
                                                                  false;
                                                              verificandoEsetandoValorTotal();
                                                            });

                                                            break;
                                                          case 3:
                                                            procedimento3 =
                                                                true;
                                                            barba = false;
                                                            procedimento0 =
                                                                true;
                                                            setState(() {
                                                              apenasBarba =
                                                                  false;
                                                              verificandoEsetandoValorTotal();
                                                            });
                                                            break;
                                                          case 4:
                                                            procedimento4 =
                                                                true;
                                                            barba = true;
                                                            setState(() {
                                                              apenasBarba =
                                                                  false;
                                                              verificandoEsetandoValorTotal();
                                                            });
                                                            break;
                                                          case 5:
                                                            procedimento5 =
                                                                true;
                                                            barba = true;
                                                            setState(() {
                                                              apenasBarba =
                                                                  false;
                                                              verificandoEsetandoValorTotal();
                                                            });
                                                            break;
                                                          default:
                                                            break;
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      index == 0
                                                          ? procedimento0
                                                              ? Icons.toggle_on
                                                              : Icons.toggle_off
                                                          : index == 1
                                                              ? procedimento1
                                                                  ? Icons
                                                                      .toggle_on
                                                                  : Icons
                                                                      .toggle_off
                                                              : index == 2
                                                                  ? procedimento2
                                                                      ? Icons
                                                                          .toggle_on
                                                                      : Icons
                                                                          .toggle_off
                                                                  : index == 3
                                                                      ? procedimento3
                                                                          ? Icons
                                                                              .toggle_on
                                                                          : Icons
                                                                              .toggle_off
                                                                      : index ==
                                                                              4
                                                                          ? procedimento4
                                                                              ? Icons.toggle_on
                                                                              : Icons.toggle_off
                                                                          : procedimento5
                                                                              ? Icons.toggle_on
                                                                              : Icons.toggle_off,
                                                      color: Colors.white,
                                                      size: 45,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      )

                                    //Container dos procedimentos(1) - fim
                                  ],
                                ),
                              ),
                              //PROCEDIMENTOS EXTRAS - FIM
                              const SizedBox(
                                height: 25,
                              ),
                              //ativar cupom(bloqueado) - inicio

                              //container do cupom - inicio
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Tem um cupom?",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        color: Colors.grey.shade300,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (ctx) {
                                              return AlertDialog(
                                                title: Text(
                                                  "Crie um perfil",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                content: Text(
                                                  "Para validar cupons você precisa de um perfil, mas é rapido para criar! Basta clicar no botão abaixo:",
                                                  style: GoogleFonts.openSans(
                                                    textStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade400,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 12,
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
                                                      "Voltar",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        textStyle: TextStyle(
                                                          color: Colors
                                                              .grey.shade400,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pushReplacementNamed(
                                                        AppRoutesApp
                                                            .RegisterAccountScreen,
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 2,
                                                        horizontal: 5,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .blue.shade600,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Criar conta ou Entrar",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          textStyle:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 5),
                                          child: Text(
                                            "Ativar Agora",
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //container do cupom - fim
                              //ativar cupom(bloqueado) - fim
                              const SizedBox(
                                height: 25,
                              ),
                              //CONTAINER DO PROFISSIONAL - INICIO
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Estabelecimento.secondaryColor
                                            .withOpacity(0.4)),
                                    child: const Text("3"),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Profissional de preferência",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              profissionalSelecionado =
                                                  _profList[0].nomeProf;
                                            });
                                            lembreteSemConta();
                                            setBarber1();
                                          }
                                        },
                                        child: Container(
                                          width: widhScren * 0.25,
                                          height: heighScreen * 0.28,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    _profList[0].assetImage,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                              if (isBarbeiro1)
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                    width: widhScren * 0.25,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        _profList[0].nomeProf,
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              profissionalSelecionado =
                                                  _profList[1].nomeProf;
                                            });
                                            lembreteSemConta();
                                            setBarber2();
                                          }
                                        },
                                        child: Container(
                                          width: widhScren * 0.25,
                                          height: heighScreen * 0.28,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    _profList[1].assetImage,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                              if (isBarbeiro2)
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                    width: widhScren * 0.25,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        _profList[1].nomeProf,
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  //profissional 3
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              profissionalSelecionado =
                                                  _profList[2].nomeProf;
                                            });
                                            lembreteSemConta();
                                            setBarber3();
                                          }
                                        },
                                        child: Container(
                                          width: widhScren * 0.25,
                                          height: heighScreen * 0.28,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                bottom: 0,
                                                left: 0,
                                                right: 0,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.asset(
                                                    _profList[2].assetImage,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                              if (isBarbeiro3)
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Container(
                                                    child: const Icon(
                                                      Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 35,
                                                    ),
                                                    width: widhScren * 0.25,
                                                    height: 130,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        _profList[2].nomeProf,
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              //CONTAINER DO PROFISSIONAL - FIM
                              //CONTAINER DA DATA - INICIO
                              const SizedBox(
                                height: 25,
                              ),
                              //CONTAINER DO PROFISSIONAL - INICIO
                              if (isBarbeiro1 || isBarbeiro2 != false)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Estabelecimento.secondaryColor
                                              .withOpacity(0.4)),
                                      child: const Text("4"),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Selecione uma data",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(
                                height: 5,
                              ),
                              if (isBarbeiro1 || isBarbeiro2 != false)
                                InkWell(
                                  onTap: () {
                                    ShowModalData();
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Estabelecimento.secondaryColor
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          dataSelectedInModal != null
                                              ? "${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)}"
                                              : "Escolha uma data",
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          size: 15,
                                          color: Colors.grey.shade500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 25,
                              ),
                              //CONTAINER DA DATA - FIM
                              //CONTAINER DA HORA - INICIO
                              if (dataSelectedInModal != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Estabelecimento.secondaryColor
                                              .withOpacity(0.4)),
                                      child: const Text("5"),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Selecione um horário",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (dataSelectedInModal != null)
                                prontoParaExibir == true
                                    ? Container(
                                        width: double.infinity,
                                        //  height: heighScreen * 0.64,
                                        child: GridView.builder(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: horarioFinal.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 2.3,
                                            childAspectRatio: 2.3,
                                          ),
                                          itemBuilder:
                                              (BuildContext ctx, int index) {
                                            Color color = selectedIndex == index
                                                ? Colors.amber
                                                : Estabelecimento.primaryColor;
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex =
                                                      selectedIndex == index
                                                          ? -1
                                                          : index;

                                                  hourSetForUser =
                                                      horarioFinal[index]
                                                          .horario;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 3),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.elliptical(
                                                              20, 20),
                                                      bottomRight:
                                                          Radius.elliptical(
                                                              20, 20),
                                                      topLeft:
                                                          Radius.elliptical(
                                                              20, 20),
                                                      topRight:
                                                          Radius.elliptical(
                                                              20, 20),
                                                    ),
                                                    color: color,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    "${horarioFinal[index].horario}",
                                                    style: GoogleFonts.openSans(
                                                        textStyle:
                                                            const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                    )),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : const Center(
                                        child: CircularProgressIndicator
                                            .adaptive(),
                                      ),
                              //CONTAINER DA HORA - FIM
                              //botao do agendar - inicio

                              if (hourSetForUser != null)
                                InkWell(
                                  onTap: showModalConfirmAgend,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Estabelecimento.primaryColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Próximo",
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                              color: Estabelecimento
                                                  .contraPrimaryColor,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            )),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: Estabelecimento
                                                .contraPrimaryColor,
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                height: 25,
                              ),
                              //botao do agendar - fim
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
