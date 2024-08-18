import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/cliente_detalhes.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/cupons_list_and_add.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/geralHistorico.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/media_horarios_preenchidos.dart';

class CardWithDetailsView extends StatelessWidget {
  const CardWithDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 45),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            //card 1 - inicio
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const ClienteDetalhes(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.badge,
                      ),
                      Text(
                        "Detalhe de clientes",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Últimos agendamentos",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            //card 1 - fim
            //card 3 - inicio
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const MediaHorariosPreenchidos(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.timer,
                      ),
                      Text(
                        "Média de Preenchimentos de horários",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Buracos na agenda",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            //card 2 - fim
            //card 2 - inicio
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const CuponsCreateandListView(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.sell,
                      ),
                      Text(
                        "Gerenciador de Cupons",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Crie promoções",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            //card 3 - fim
          //card 4 - inicio
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    DialogRoute(
                      context: context,
                      builder: (ctx) => const HistoricoCompletoClientes(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.65,
                  height: MediaQuery.of(context).size.height * 0.28,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.manage_search,
                      ),
                      Text(
                        "Histórico completo",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Todos os clientes, 1 lista",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Estabelecimento.primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Estabelecimento.contraPrimaryColor,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          //card 4 - fim
          ],
        ),
      ),
    );
  }
}
