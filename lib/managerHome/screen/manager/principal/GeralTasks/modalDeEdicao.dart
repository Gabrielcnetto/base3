import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/atualizacaodePrecoManager.dart';
import 'package:easebase/managerHome/screen/manager/principal/GeralTasks/components/changeHourAndData.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class ModalDeEdicao extends StatefulWidget {
  const ModalDeEdicao({super.key});

  @override
  State<ModalDeEdicao> createState() => _ModalDeEdicaoState();
}

class _ModalDeEdicaoState extends State<ModalDeEdicao> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false).getFolga;
  }

  @override
  Widget build(BuildContext context) {
    final infoRoutes = ModalRoute.of(context)?.settings.arguments as CorteClass;

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

    Future<void> setAndMyCortesIsActive() async {
      print("entrei na funcao");
      final String codeForUse = infoRoutes.ramdomCode.toString();

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

    void perguntarSefinalizar() {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Finalizar corte"),
              content: const Text(
                  "Finalizar o corte quer dizer que o cliente compareceu e o serviço já foi feito. (Use para limpar a sua agenda diária e deixar apenas os pendentes)"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setAndMyCortesIsActive();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Quero Finalizar",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    void showPreLembrete() async {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text("Notificar cliente?"),
              content: const Text(
                  "O Cliente receberá uma mensagem para lembrar do horário, com opção para desmarcar"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await Provider.of<ManyChatConfirmation>(context,
                            listen: false)
                        .sendLembreteParaAtrasados(
                            phoneNumber: infoRoutes.numeroContato);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Notificar Agora",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    }

    Future<void> desmarcarCorte(
        {required BuildContext context,
        required CorteClass corteparausar}) async {
      print("entramos no showdialog");
      return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Gostaria de cancelar este agendamento?'),
              content: const Text(
                  "Após confirmar este horário sera liberado em sua agenda."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Fecha o diálogo
                    // Adicione a lógica para a primeira opção aqui
                  },
                  child: Text(
                    'Manter',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    Provider.of<CorteProvider>(context, listen: false)
                        .desmarcarCorte(corteparausar);
                    Provider.of<CorteProvider>(context, listen: false)
                        .desmarcarAgendaManager(corteparausar);

                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return AlertDialog(
                            title: Text(
                              "Cancelamos este horário",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black),
                              ),
                            ),
                            content: Text(
                              "O Horário foi cancelado, e liberado na sua agenda",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacementNamed(
                                      AppRoutesApp.HomeScreen01);
                                },
                                child: Text(
                                  "Fechar",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    'Desmarcar',
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    //nome do cliente - inico
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Nome do Cliente",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${infoRoutes.clientName}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Nome do cliente - fim
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Valor",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                infoRoutes.feitoporassinatura
                                    ? 'R\$00,00'
                                    : "R\$${infoRoutes.totalValue.toStringAsFixed(2).replaceAll('.', ',')}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (ctx) {
                                      return AtualizacaoDePrecoDoManager(
                                        corteWidget: infoRoutes,
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade500,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    //CONTAINER DA DURACAO - INICIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Duração",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${infoRoutes.barba == true ? "60min" : "30min"}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //CONTAINER DA DURACAO - FIM
                    //CONTAINER DO PROFISSIONAL - INCIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profissional",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "${infoRoutes.profissionalSelect}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //CONTAINER DO PROFISSIONAL - FIM
                    //CONTAINER DO DATA/HORA - INICIO
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext ctx) {
                          return ChangeHourAndData(
                            corteWidget: infoRoutes,
                          );
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 1,
                              color: Colors.grey.shade200,
                            ),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Data/Hora",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  //"${DateFormat('dd/MM/yyyy').format(infoRoutes.diaCorte)} - ${infoRoutes.horarioCorte}",
                                  "${infoRoutes.DiaDoCorte} de ${infoRoutes.NomeMes} - ${infoRoutes.horarioCorte}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    //CONTAINER DO DATA/HORA - FIM
                    //container dos detalhes - inicio
//CONTAINER DO DATA/HORA - INICIO
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Detalhes",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          if (infoRoutes.feitoporassinatura == true)
                            Text(
                              "Assinante",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (infoRoutes.pagoComCreditos == true)
                            Text(
                              "Pago pelo App",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          if (infoRoutes.pagoComCupom == true)
                            Text(
                              "Grátis - Pago com cupom",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    //container dos detalhes - fim
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.15,
                color: Colors.grey.shade100.withOpacity(0.7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        desmarcarCorte(
                            context: context, corteparausar: infoRoutes);
                      },
                      child: Container(
                        child: Column(
                          children: [
                            const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.blue,
                            ),
                            Text(
                              "Cancelar",
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
                      ),
                    ),
                    infoRoutes.numeroContato.isEmpty
                        ? Container()
                        : Container(
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: showPreLembrete,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    child: Image.asset(
                                      "imagesOfApp/whatsaaplogo.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  "Enviar Lembrete",
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
                          ),
                    InkWell(
                      onTap: () async {
                        perguntarSefinalizar();
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_box,
                              size: 30,
                              color: Estabelecimento.primaryColor,
                            ),
                            Text(
                              "Finalizar",
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.grey.shade200),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.09,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Comanda nº ${infoRoutes.ramdomCode}",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.08,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
