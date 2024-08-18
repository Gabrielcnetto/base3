import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class AtualizacaoDePrecoDoManager extends StatefulWidget {
  final CorteClass corteWidget;
  const AtualizacaoDePrecoDoManager({
    super.key,
    required this.corteWidget,
  });

  @override
  State<AtualizacaoDePrecoDoManager> createState() =>
      _AtualizacaoDePrecoDoManagerState();
}

class _AtualizacaoDePrecoDoManagerState
    extends State<AtualizacaoDePrecoDoManager> {
  final novoValor = TextEditingController();

  Future<void> setNewPrice() async {
    try {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Confirmar Alteração?",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
              content: Text(
                "Este valor sera alterado para o novo, mas você pode editar quantas vezes precisar",
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await Provider.of<ManagerScreenFunctions>(context,
                            listen: false)
                        .updateValorCorte(
                      corte: widget.corteWidget,
                      novoValor: novoValor.text,
                    );
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                  },
                  child: Text(
                    "Confirmar alteração",
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
      print("Tudo ok com sua atualização");
    } catch (e) {
      print("houve um erro ao atualizar o preço:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(25, 25),
          topRight: Radius.elliptical(25, 25),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Atualização de valor",
            style: GoogleFonts.openSans(
              textStyle: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text(
              "Troque o valor para caso tenha alguma venda externa, procedimento extra ou desconto para manter o sistema sempre atualzado.",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(15, 15),
                        bottomLeft: Radius.elliptical(15, 15),
                      ),
                      color: Colors.blue.shade600,
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: const Icon(
                      Icons.monetization_on_outlined,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.elliptical(15, 15),
                        bottomRight: Radius.elliptical(15, 15),
                      ),
                      color: Colors.grey.shade100,
                    ),
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextFormField(
                        controller: novoValor,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text(
                            'Clique para digitar',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: InkWell(
              onTap: setNewPrice,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Atualizar Agora",
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
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
