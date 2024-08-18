import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/cupomClass.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:provider/provider.dart';

class CuponsViewItem extends StatefulWidget {
  const CuponsViewItem({super.key});

  @override
  State<CuponsViewItem> createState() => _CuponsViewItemState();
}

class _CuponsViewItemState extends State<CuponsViewItem> {
  Future<void> TurnOffCoupon({required cupomClass cupom}) async {
   setState(() {
       Provider.of<CupomProvider>(context, listen: false)
        .turnOfforActiveFcuntionsCoupon(
      cupomItens: cupom,
    );
   });
    
  }

  Future<void> deleteCupon({required cupomClass cupom}) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Seu cupom foi excluído",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            content: Text(
              "O Cupom: ${cupom.name} foi Excluído, esta ação não pode ser desfeita",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await Provider.of<CupomProvider>(context, listen: false)
                      .deleteCoupon(cupom: cupom);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Fechar",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
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
    return StreamBuilder(
      stream: Provider.of<CupomProvider>(context, listen: true).cupomStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator.adaptive();
        } else if (snapshot.hasData) {
          List<cupomClass> cupons = snapshot.data!;

          print("cupom carregado corretmente");
          return Column(
            children: cupons.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Dismissible(
                  onDismissed: (DismissDirection direction) async {
                    await deleteCupon(cupom: item);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Cupom Excluido',
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  direction: DismissDirection.endToStart,
                  key: Key("${item.id}"),
                  background: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Text(
                          "Excluir Cupom?",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 0.7,
                        color: Colors.grey.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(1),
                              width: MediaQuery.of(context).size.width * 0.13,
                              height: MediaQuery.of(context).size.height * 0.07,
                              color: item.isActive == true
                                  ? Colors.yellow
                                  : Colors.grey.shade300,
                              child: Icon(
                                Icons.percent,
                                size: 30,
                                color: item.isActive == true
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${item.name}",
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Horário: ${item.horario} - ",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      Icons.timer,
                                      size: 15,
                                      color: Colors.grey.shade500,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: Text(
                                    "Easepoints Multiplicado x${item.multiplicador}",
                                    style: GoogleFonts.openSans(
                                      textStyle: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${item.codigo}",
                                        style: GoogleFonts.openSans(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      const Icon(
                                        Icons.confirmation_number,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.radio_button_checked,
                                  size: 15,
                                  color: item.isActive
                                      ? Colors.green.shade700
                                      : Colors.grey.shade400,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  item.isActive ? "Ativo" : "Off",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: item.isActive
                                          ? Colors.green.shade700
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                setState(()  {
                                  item.isActive =
                                      !item.isActive; // Alterna o estado local
                                });
                                TurnOffCoupon(cupom: item);
                              },
                              child: Container(
                                child: Icon(
                                  item.isActive
                                      ? Icons.toggle_on
                                      : Icons.toggle_off,
                                  size: 45,
                                  color: item.isActive == true
                                      ? Colors.black
                                      : Colors.grey.shade500,
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
          );
        } else if (snapshot.data!.isEmpty || snapshot.hasError) {
          
          
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.sell,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Sem cupons Criados",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
