import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/ManyChatConfirmation.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Corte7DiasItem extends StatefulWidget {
  final List<CorteClass> corte;
  const Corte7DiasItem({super.key, required this.corte});

  @override
  State<Corte7DiasItem> createState() => _Corte7DiasItemState();
}

class _Corte7DiasItemState extends State<Corte7DiasItem> {
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  Future<void> desmarcarCorte(
      BuildContext context, CorteClass corteparausar) async {
    print("entramos no showdialog");
    return showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Gostaria de cancelar o seu agendamento?'),
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

                  Navigator.of(context)
                      .pushReplacementNamed(AppRoutesApp.ConfirmCancelCorte);
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

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 60,),
        child: Column(
          children: widget.corte.map((Corte) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                key: Key(Corte.id),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25)),
                width: MediaQuery.of(context).size.width * 1,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.8,
                              color: Colors.grey.shade100,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Text(
                            "${Corte.profissionalSelect}",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          "${Estabelecimento.nomeLocal}",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "Cliente:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${Corte.clientName}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "barba:",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade300,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${Corte.barba == true ? "Inclusa" : "Não Inclusa"}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 17),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule,
                              size: 25,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${Corte.horarioCorte}h",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                desmarcarCorte(context, Corte);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                child: const Icon(
                                  Icons.event_busy,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Corte.numeroContato.isEmpty
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (ctx) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "Notificar cliente?"),
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
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    await Provider.of<
                                                                ManyChatConfirmation>(
                                                            context,
                                                            listen: false)
                                                        .sendLembreteParaAtrasados(
                                                            phoneNumber: Corte
                                                                .numeroContato);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                    "Notificar Agora",
                                                    style: GoogleFonts.poppins(
                                                      textStyle:
                                                          const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade600,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Enviar Lembrete",
                                            style: GoogleFonts.openSans(
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.08,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            child: Image.asset(
                                                "imagesOfApp/whatsaaplogo.png"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
