import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/managerHome/screen/home/homeOnlyWidgets.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/ScheduleWithTwolists.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/scheduleWithTwoLists_geralView.dart';
import 'package:easebase/managerHome/screen/manager/principal/ManagerScreen.dart';
import 'package:easebase/managerHome/screen/manager/principal/encaixe/encaixeScreen.dart';
import 'package:easebase/managerHome/screen/manager/principal/funcionario/funcionario_screen.dart';
import 'package:easebase/normalUsersHome/screen/add/addScreen.dart';
import 'package:easebase/normalUsersHome/screen/calendar/calendarScreen.dart';
import 'package:easebase/normalUsersHome/screen/home/homeOnlyWidgets.dart';
import 'package:easebase/normalUsersHome/screen/home/points_rewards/home_configCoupon/configCoupon.dart';
import 'package:easebase/normalUsersHome/screen/profile/profileScreen.dart';
import 'package:easebase/normalUsersHome/screen/History/History.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen01 extends StatefulWidget {
  final int selectedIndex;
  final bool cupomIsAcitve;
  const HomeScreen01({
    super.key,
    required this.selectedIndex,
    required this.cupomIsAcitve,
  });

  @override
  State<HomeScreen01> createState() => _HomeScreen01State();
}

class _HomeScreen01State extends State<HomeScreen01>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  late AnimationController _animationController;

  bool isManager = false;
  bool isFuncionario = false;
  int screen = 0;
  List<Map<String, Object>>? _screensSelect;

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    _screensSelect;
    loadInitialData();
    loadUserIsFuncionario();
    loadUserIsManager();
    Provider.of<ManagerScreenFunctions>(context, listen: false).loadClientes();
  }

  Future<void> loadInitialData() async {
    await loadUserIsManager();
    await loadUserIsFuncionario();
    setState(() {
      _screensSelect = [
        {
          'tela': isManager == true
              ? HomeOnlyWidgetsForManagers(
                  isfuncionarioGet: isFuncionario,
                  ismanagerGet: isManager,
                )
              : const HomeOnlyWidgets(),
        },
        {
          'tela': (isManager || isFuncionario) == true
              ? const EncaixeScreenProfissionalOptionHomeProf()
              : AddScreen(cupomActive: widget.cupomIsAcitve),
        },
        {
          'tela': (isManager || isFuncionario) == true
              ? const ScheduleWithTwoLists() //ScheduleWithTwoLists()
              : const HistoryScreen(),
        },
        {
          'tela': isManager == true
              ? const ManagerScreenViewHomeNewView()
              : isFuncionario == true
                  ? const FuncionarioScreenHomeScreenNew()
                  : const ProfileScreen(),
        },
      ];
      screen = widget.selectedIndex;
    });
  }

  void attScren(int index) {
    setState(() {
      screen = index;
    });
  }

  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsManager();

    if (isManager != null) {
      setState(() {
        isManager = bolIsManager!;
      });
    } else {
      print("erro ao logar ismanager");
    }
  }

  Future<void> loadUserIsFuncionario() async {
    bool? funcionario = await MyProfileScreenFunctions().getUserIsFuncionario();
    if (isFuncionario != null) {
      setState(() {
        isFuncionario = funcionario!;
      });
    } else {
      print("erro ao carregar funcionario");
    }
  }

  bool exibindoItens = false;
  DateTime? dataSelectedInModal;
  Future<void> ShowModalData() async {
    showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 14),
      ),
      selectableDayPredicate: (DateTime day) {
        // Desativa domingos
        return day.weekday != DateTime.sunday;
      },
    ).then((selectUserDate) {
      try {
        if (selectUserDate != null) {
          setState(() {
            dataSelectedInModal = selectUserDate;
          });
          return showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: const Text('Configurando Folga'),
                  content: Text(
                    "O Dia ${DateFormat("dd/MM/yyyy").format(dataSelectedInModal!)} Será Desativado, para reativa-lo entre em contato com o suporte. O Restante continua Ativo normalmente",
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fecha o modal
                      },
                      child: Text(
                        'Cancelar ação',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        Provider.of<ManagerScreenFunctions>(context,
                                listen: false)
                            .setDayOff(dataSelectedInModal!);
                        Navigator.of(context).pop(); // Fecha o modal
                      },
                      child: Text(
                        'OK',
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                );
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

  final num1 = TextEditingController();
  final num2 = TextEditingController();
  final num3 = TextEditingController();
  final num4 = TextEditingController();
  final num5 = TextEditingController();
  //focus
  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();
  FocusNode _focusNode3 = FocusNode();
  FocusNode _focusNode4 = FocusNode();
  FocusNode _focusNode5 = FocusNode();
  // inits e dispose - inicio

  @override
  void dispose() {
    num1.dispose();
    num2.dispose();
    num3.dispose();
    num4.dispose();
    num5.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();
    super.dispose();
  }

  Future<void> setAndMyCortesIsActive() async {
    final String codeForUse =
        await num1.text + num2.text + num3.text + num4.text + num5.text;

    final database = FirebaseFirestore.instance;
    //=> Puxando os id´s do usuário
    QuerySnapshot querySnapshot = await database.collection("usuarios").get();
    //=> Dividindo os dados do firebase em snapshots
    List<DocumentSnapshot> docs = querySnapshot.docs;
    if (docs.isEmpty) {
    } else {
      for (var userDoc in docs) {
        try {
          //=> Acessando o item de todos os usuário(histórico)
          //a partir dos id´s coletados, entra em cada 1 e atualiza os atributos na pasta interna
          QuerySnapshot open = await database
              .collection("meusCortes")
              .doc(userDoc.id)
              .collection("lista")
              .get();

          //=> Dividindo os dados do firebase em snapshots(histórico)
          List<DocumentSnapshot> openDocs = open.docs;
          if (openDocs.isEmpty) {
          } else {
            for (var itemDoc in openDocs) {
              Map<String, dynamic> data =
                  itemDoc.data() as Map<String, dynamic>;
              if (data != null) {
                // Convertendo o ramdomNumber para String antes da comparação
                if (data['ramdomNumber'].toString() == codeForUse) {
                  // Atualizando o documento no Firestore
                  await database
                      .collection("meusCortes")
                      .doc(userDoc.id)
                      .collection("lista")
                      .doc(itemDoc.id)
                      .update({'isActive': false});
                  Future.delayed(Duration.zero, () {
                    _showErrorDialog(context);
                  });

                  break;
                } else if (data['ramdomNumber'].toString() != codeForUse) {}
              } else {}
            }
          }
        } catch (e) {
          print("Erro ao atualizar o documento Fora do allcuts: $e");
        }
      }
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Código Validado"),
          content: const Text("Presença do Cliente Confirmada"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Fechar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> setAndMyCortesIsActiveAllCuts() async {
    final DateTime dataAtual = DateTime.now();
    final int diaAtual = dataAtual.day;
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    print("allCuts/${monthName}/${diaAtual}");
    final String codeForUse =
        await num1.text + num2.text + num3.text + num4.text + num5.text;

    final database = FirebaseFirestore.instance;
    try {
      print("entrei no try");
      QuerySnapshot querySnapshot = await database
          .collection("allCuts")
          .doc(monthName)
          .collection("$diaAtual")
          .get();
      if (querySnapshot.docs.isEmpty) {
        print("nao há nada na lista");
      } else {
        List<DocumentSnapshot> documents = querySnapshot.docs;
        for (DocumentSnapshot document in documents) {
          print("entrei no for");
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          if (data != null && data['ramdomNumber'].toString() == codeForUse) {
            // Encontrou o documento correspondente, atualize o atributo 'isActive' para false
            await document.reference.update({'isActive': false});
            // Faça qualquer outra operação necessária aqui
            print('Documento atualizado com sucesso');
            break; // Se você só precisa atualizar um documento, pode sair do loop aqui
          }
        }
      }
    } catch (e) {
      print("Erro ao acessar/atualizar documentos: $e");
    }
  }

  void showVerificationModalManager() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Código Único",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "Digite o código do corte do seu cliente, disponível na tela do app do seu Cliente",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      //DIGITO 1 - INICIO
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
                        child: Container(
                          alignment: Alignment.center,
                          width: 62,
                          height: 72,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNode1,
                            controller: num1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //DIGITO 1 - FIM
                      //DIGITO 2 - INICIO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          alignment: Alignment.center,
                          width: 62,
                          height: 72,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            focusNode: _focusNode2,
                            controller: num2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //DIGITO 2 - FIM

                      //DIGITO 3 - INICIO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          alignment: Alignment.center,
                          width: 62,
                          height: 72,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: num3,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //DIGITO 3 - FIM
                      //DIGITO 4 - INICIO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          alignment: Alignment.center,
                          width: 62,
                          height: 72,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            controller: num4,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //DIGITO 4 - FIM

                      //DIGITO 5 - INICIO
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          alignment: Alignment.center,
                          width: 62,
                          height: 72,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Estabelecimento.primaryColor.withOpacity(0.3),
                          ),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            controller: num5,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 17,
                            ),
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      //DIGITO 5 - FIM
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () async {
                    setAndMyCortesIsActive();
                    await setAndMyCortesIsActiveAllCuts();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 1.3,
                    height: 50,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Estabelecimento.primaryColor,
                    ),
                    child: Text(
                      "Registrar ",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Estabelecimento.contraPrimaryColor,
                        ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CurvedNavigationBar(
          height: 50,
          animationDuration: const Duration(milliseconds: 80),
          onTap: attScren,
          index: screen,
          backgroundColor: Estabelecimento.primaryColor,
          items: [
            const Icon(
              Icons.home,
              size: 32,
            ),
            //    Icon(
            //      Icons.calendar_month,
            //   ),
            const Icon(
              Icons.add,
              size: 32,
            ),
            Icon(
              isFuncionario || isManager ? Icons.today : Icons.timeline,
              size: 32,
            ),
            const Icon(
              Icons.account_circle,
              size: 32,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: _screensSelect != null && _screensSelect![screen]['tela'] != null
          ? _screensSelect![screen]['tela'] as Widget
          : Container(),
      floatingActionButton: (isFuncionario || isManager) == true
          ? FloatingActionBubble(
              items: <Bubble>[
                Bubble(
                  icon: Icons.qr_code,
                  iconColor: Estabelecimento.primaryColor,
                  title: "Verificar Código",
                  titleStyle: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  bubbleColor: Colors.white,
                  onPress: showVerificationModalManager,
                ),
                if (isFuncionario == false && isManager == true)
                  Bubble(
                    icon: Icons.attach_money,
                    iconColor: Estabelecimento.primaryColor,
                    title: "Preços e porcentagens",
                    titleStyle: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    bubbleColor: Colors.white,
                    onPress: () {
                      Navigator.of(context)
                          .pushNamed(AppRoutesApp.PricesAndPercentages);
                    },
                  ),
                if (isFuncionario == false && isManager == true)
                  Bubble(
                    icon: Icons.celebration,
                    iconColor: Estabelecimento.primaryColor,
                    title: "Adicionar Day Off",
                    titleStyle: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    bubbleColor: Colors.white,
                    onPress: ShowModalData,
                  ),
                if (isFuncionario == false && isManager == true)
                  Bubble(
                    icon: Icons.confirmation_number,
                    iconColor: Estabelecimento.primaryColor,
                    title: "Configurar Cupom",
                    titleStyle: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    bubbleColor: Colors.white,
                    onPress: () {
                      Navigator.of(context).push(DialogRoute(
                          context: context,
                          builder: (ctx) {
                            return const ConfigCouponScreen();
                          }));
                    },
                  ),
              ],
              iconColor: Estabelecimento.contraPrimaryColor,
              backGroundColor: Estabelecimento.primaryColor,
              onPress: () {
                setState(() {
                  exibindoItens = !exibindoItens;
                });
                _animationController.isCompleted
                    ? _animationController.reverse()
                    : _animationController.forward();
              },
              iconData:
                  exibindoItens ? Icons.arrow_drop_down : Icons.arrow_drop_up,
              animation: _animation!,
            )
          : null,
    );
  }
}
