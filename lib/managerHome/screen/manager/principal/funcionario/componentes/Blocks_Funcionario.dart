import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class BlocksFuncionarioComponent extends StatefulWidget {
  const BlocksFuncionarioComponent({super.key});

  @override
  State<BlocksFuncionarioComponent> createState() =>
      _BlocksManagerComponentState();
}

class _BlocksManagerComponentState extends State<BlocksFuncionarioComponent> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false);
    loadTotalClientes();
    loadTotalCortesFuncionario();
    totalClientes;
    mesAtual;
    nomeUsuarioParaUsarNaLista;
    totalFaturamento;
    totalCortes;
    loadAtualMonth();
    loadUserNameProfissionalISTA();
    loadTotalFaturamentoFuncionario();
    LoadPercentual();
  }

  int? totalClientes;
  void loadTotalClientes() async {
    List<GeralUser> listClientes =
        await Provider.of<ManagerScreenFunctions>(context, listen: false)
            .clientesLista;

    setState(() {
      totalClientes = listClientes.length;
    });
  }
  //

  String? mesAtual;
  Future<void> loadAtualMonth() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);

    setState(() {
      mesAtual = monthName;
    });
  }

  String? nomeUsuarioParaUsarNaLista;
  Future<void> loadUserNameProfissionalISTA() async {
    String? nomeParaPuxar = await ManagerScreenFunctions()
        .getNomeFuncionarioParaListarFaturamento();

    if (nomeUsuarioParaUsarNaLista != null) {
    } else {
      const Text('N/A');
    }
    print("a lista que devemos puxar é a do: ${nomeParaPuxar}");
    setState(() {
      nomeUsuarioParaUsarNaLista = nomeParaPuxar;
      loadTotalFaturamentoFuncionario();
      loadTotalCortesFuncionario();
    });
  }

  //fazendo a soma do valor faturado pelo funcionario
  int? totalFaturamento;
  Future<void> loadTotalFaturamentoFuncionario() async {
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoFuncionarios(
            nomeFuncionario: nomeUsuarioParaUsarNaLista!);

    setState(() {
      totalFaturamento = totalFaturamentoGet;
      LoadPercentual();
      SetPorcentagem();
    });
  }

  int? loadPercentual;

  Future<void> LoadPercentual() async {
    int? priceDB = await ManagerScreenFunctions().getPorcentagemFuncionario();
    print("pegamos a data do databse");

    setState(() {
      loadPercentual = priceDB!;
      SetPorcentagem();
    });
  }

  double faturamentoFinal = 0;
  void SetPorcentagem() {
    print("o faturamento total é de: ${totalFaturamento}");
    print("o percentual total é de: ${loadPercentual}");
    setState(() {
      faturamentoFinal = totalFaturamento! * (loadPercentual! / 100.0);
    });
  }

  int totalCortes = 0;
  Future<void> loadTotalCortesFuncionario() async {
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .TotalcortesProfissionalMes(
            nomeFuncionario: nomeUsuarioParaUsarNaLista!);

    setState(() {
      totalCortes = totalFaturamentoGet;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        //  color: Colors.red,
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: Icon(
                            Icons.people,
                            color: Colors.grey.shade700,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${totalClientes}",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Clientes cadastrados",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.cut,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  totalCortes > 1
                                      ? "${totalCortes} cortes"
                                      : "${totalCortes} corte",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Agendados em ${mesAtual ?? "Carregando..."}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                  ),
                                  child: Icon(
                                    Icons.paid,
                                    color: Colors.grey.shade700,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "R\$${faturamentoFinal.toStringAsFixed(2).replaceAll('.', ',') ?? 0}",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Faturamento esperado",
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
                     Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(AppRoutesApp.ProfileScreenManagerWithScafol);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "Editar Perfil",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
