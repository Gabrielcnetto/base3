import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/profissionais.dart';
import 'package:easebase/functions/managerScreenFunctions.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/GraphicsScreenManager.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:provider/provider.dart';

class FaturamentoMesSelecionado extends StatefulWidget {
  final String mesInicial;
  const FaturamentoMesSelecionado({
    super.key,
    required this.mesInicial,
  });

  @override
  State<FaturamentoMesSelecionado> createState() =>
      _FaturamentoMesSelecionadoState();
}

class _FaturamentoMesSelecionadoState extends State<FaturamentoMesSelecionado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<ManagerScreenFunctions>(context, listen: false)
        .gerarUltimos4Meses();
    setlist();
    loadTotalFaturamentoAtualMes();
    selecionarMes();
    loadTotalCortes();
    loadTotalCortesProf2();
    loadTotalCortesProf3();
    loadMetaValue();
  }

  //dados de clientes profissional 1 - inicio
  int totalCortesMesSelecionado = 0;
  Future<void> loadTotalCortes() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional1MesSelecionado(
            profissiona1lName: profList[0].nomeProf,
            mesSelecionado: widget.mesInicial == "Clique"
                ? monthName.toLowerCase()
                : widget.mesInicial.toLowerCase());

    setState(() {
      totalCortesMesSelecionado = totalCortesGet;
      loadTotalCortesMesAnterior();
    });
  }

  int totalCortesMesAnterior = 0;
  Future<void> loadTotalCortesMesAnterior() async {
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional1MesSelecionado(
      profissiona1lName: profList[0].nomeProf,
      mesSelecionado: mesAnteriorAoSelecionado!.toLowerCase() ?? "",
    );

    setState(() {
      totalCortesMesAnterior = totalCortesGet;
    });
  }

  double calcularDiferencaPercentualProfissional1Cortes() {
    // Verifica se os valores são nulos ou zero
    int faturamentoExibidoValor = totalCortesMesSelecionado ?? 0;
    int faturamentoAnteriorAoEscolhidoValor = totalCortesMesAnterior ?? 0;

    // Calcula a diferença entre os valores
    int diferenca =
        faturamentoExibidoValor - faturamentoAnteriorAoEscolhidoValor;

    // Verifica se o denominador é zero para evitar divisão por zero
    if (faturamentoAnteriorAoEscolhidoValor == 0) {
      return 0; // Retorna 0 se houver divisão por zero
    }

    // Calcula a diferença percentual
    double diferencaPercentual =
        (diferenca / faturamentoAnteriorAoEscolhidoValor) * 100;

    // Retorna o resultado
    return diferencaPercentual;
  }

  //dados de clientes profissional 1 - fim
  //dados de clientes profissional 2 - inicio
  int totalCortesMesSelecionadoProf2 = 0;
  Future<void> loadTotalCortesProf2() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional2MesSelecionado(
            profissiona1lName: profList[1].nomeProf,
            mesSelecionado: widget.mesInicial == "Clique"
                ? monthName.toLowerCase()
                : widget.mesInicial.toLowerCase());

    setState(() {
      totalCortesMesSelecionadoProf2 = totalCortesGet;
      loadTotalCortesMesAnterior();
      loadTotalCortesProf2MesAnterior();
    });
  }

  int totalCortesMesAnteriorProf2 = 0;
  Future<void> loadTotalCortesProf2MesAnterior() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional2MesSelecionado(
            profissiona1lName: profList[1].nomeProf,
            mesSelecionado: mesAnteriorAoSelecionado!.toLowerCase() ?? "");

    setState(() {
      totalCortesMesAnteriorProf2 = totalCortesGet;
    });
  }

  double calcularDiferencaPercentualProfissional2Cortes() {
    // Verifica se os valores são nulos ou zero
    int faturamentoExibidoValor = totalCortesMesSelecionadoProf2 ?? 0;
    int faturamentoAnteriorAoEscolhidoValor = totalCortesMesAnteriorProf2 ?? 0;

    // Calcula a diferença entre os valores
    int diferenca =
        faturamentoExibidoValor - faturamentoAnteriorAoEscolhidoValor;

    // Verifica se o denominador é zero para evitar divisão por zero
    if (faturamentoAnteriorAoEscolhidoValor == 0) {
      return 0; // Retorna 0 se houver divisão por zero
    }

    // Calcula a diferença percentual
    double diferencaPercentual =
        (diferenca / faturamentoAnteriorAoEscolhidoValor) * 100;

    // Retorna o resultado
    return diferencaPercentual;
  }
  //dados de clientes profissional 2 - fim

  //dados e loads do profissional 3 - inicio
  int totalCortesMesSelecionadoProf3 = 0;
  Future<void> loadTotalCortesProf3() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional3MesSelecionado(
            profissiona1lName: profList[2].nomeProf,
            mesSelecionado: widget.mesInicial == "Clique"
                ? monthName.toLowerCase()
                : widget.mesInicial.toLowerCase());

    setState(() {
      totalCortesMesSelecionadoProf3 = totalCortesGet;
      loadTotalCortesProf3MesAnterior();
      calcularDiferencaPercentualProfissional3Cortes();
    });
  }

  //anterior
  int totalCortesMesAnteriorProf3 = 0;
  Future<void> loadTotalCortesProf3MesAnterior() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalCortesGet = await ManagerScreenFunctions()
        .loadCortesMesesProfissional3MesSelecionado(
            profissiona1lName: profList[2].nomeProf,
            mesSelecionado: mesAnteriorAoSelecionado!.toLowerCase() ?? "");

    setState(() {
      totalCortesMesAnteriorProf3 = totalCortesGet;
    });
  }

  double calcularDiferencaPercentualProfissional3Cortes() {
    // Verifica se os valores são nulos ou zero
    int faturamentoExibidoValor = totalCortesMesSelecionadoProf3 ?? 0;
    int faturamentoAnteriorAoEscolhidoValor = totalCortesMesAnteriorProf3 ?? 0;

    // Calcula a diferença entre os valores
    int diferenca =
        faturamentoExibidoValor - faturamentoAnteriorAoEscolhidoValor;

    // Verifica se o denominador é zero para evitar divisão por zero
    if (faturamentoAnteriorAoEscolhidoValor == 0) {
      return 0; // Retorna 0 se houver divisão por zero
    }

    // Calcula a diferença percentual
    double diferencaPercentual =
        (diferenca / faturamentoAnteriorAoEscolhidoValor) * 100;

    // Retorna o resultado
    return diferencaPercentual;
  }
  //dados e loads do profissioanl 3 - fim
  //faturamento - load mes escolhido - inicio

  //- # mes escolhido =>
  int faturamentoExibido = 0;
  Future<void> loadTotalFaturamentoAtualMes() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoBarbeariaSelectMenu(
            mesSelecionado: widget.mesInicial == "Clique"
                ? monthName.toLowerCase()
                : widget.mesInicial.toLowerCase());

    setState(() {
      faturamentoExibido = totalFaturamentoGet;
      CalcPercent();
      loadFaturamentoMesAnterior();
      selecionarMes();
      calcularDiferencaPercentual();
    });
  }
  //- # mes escolhido =<

  //- # mes anterior do escolhido para comparativo =>
  String? mesAnteriorAoSelecionado;
  int? faturamentoAnteriorAoEscolhido;
  Future<void> loadFaturamentoMesAnterior() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    int totalFaturamentoGet = await ManagerScreenFunctions()
        .loadFaturamentoBarbeariaSelectMenuMesAnterior(
            mesSelecionado: mesAnteriorAoSelecionado!.toLowerCase() ?? "");

    setState(() {
      faturamentoAnteriorAoEscolhido = totalFaturamentoGet;
    });
    print(
        "#17 o faturamento anterior foi de R\$${faturamentoAnteriorAoEscolhido}");
  }
  //- # mes anterior do escolhido para comparativo =<
  //faturamento - load mes escolhido - fim

  //load dos ultimos 4 meses - inici

  List<String> ultimos4Meses = [];
  void setlist() {
    setState(() {
      ultimos4Meses =
          Provider.of<ManagerScreenFunctions>(context, listen: false)
              .ultimos4Meses;
    });
  }

  void selecionarMes() async {
    // Obter o índice do mês selecionado
    int indiceSelecionado = 0;
    if (widget.mesInicial == "Clique") {
      indiceSelecionado = await ultimos4Meses.indexOf(
        Provider.of<ManagerScreenFunctions>(context, listen: false)
            .ultimos4Meses[0],
      );
    } else {
      indiceSelecionado = await ultimos4Meses.indexOf(
        widget.mesInicial,
      );
    }

    // Calcular o índice do mês anterior
    int indiceAnterior = (indiceSelecionado + 1);

    // Definir o mês anterior
    setState(() {
      mesAnteriorAoSelecionado = ultimos4Meses[indiceAnterior];
    });
    print("#17 mes setado:${mesAnteriorAoSelecionado}");
  }

  //load dos ultimos 4 meses - fim
  bool showMoreMonths = false;

  //funcoes para converter em % as dive=ferencias
  double calcularDiferencaPercentual() {
    // Verifica se os valores são nulos ou zero
    int faturamentoExibidoValor = faturamentoExibido ?? 0;
    int faturamentoAnteriorAoEscolhidoValor =
        faturamentoAnteriorAoEscolhido ?? 0;

    // Calcula a diferença entre os valores
    int diferenca =
        faturamentoExibidoValor - faturamentoAnteriorAoEscolhidoValor;

    // Verifica se o denominador é zero para evitar divisão por zero
    if (faturamentoAnteriorAoEscolhidoValor == 0) {
      return 0; // Retorna 0 se houver divisão por zero
    }

    // Calcula a diferença percentual
    double diferencaPercentual =
        (diferenca / faturamentoAnteriorAoEscolhidoValor) * 100;

    // Retorna o resultado
    return diferencaPercentual;
  }

  //configurações de meta - INÍCIO
  void confirmNewValue() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Sua meta foi atualizada",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            content: Text(
              "Parabéns por estabelecer uma meta, agora é hora de alcançá-la!",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutesApp.HomeScreen01,
                  );
                },
                child: Text(
                  "Voltar ao trabalho",
                  style: TextStyle(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void dialogNewMeta() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(
              "Atualizar meta?",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade600,
                  fontSize: 16,
                ),
              ),
            ),
            content: Text(
              "você pode alterar a qualquer momento o valor.",
              style: GoogleFonts.openSans(
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
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
                  style: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  functionSetNewMeta();
                  Navigator.of(context).pop();
                  confirmNewValue();
                },
                child: Text(
                  "Confirmar e Salvar",
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  double percentualVisual = 0;
  double PercentualMeta = 0;
  void CalcPercent() {
    if (metaDatabase == 0) {
      setState(() {
        PercentualMeta = 0.0;
        percentualVisual = (PercentualMeta ?? 0) * 100;
      });
    } else {
      setState(() {
        PercentualMeta = faturamentoExibido / metaDatabase!;
        percentualVisual = (PercentualMeta ?? 0) * 100;
      });
    }
  }

  int? metaDatabase = 0;
  Future<void> loadMetaValue() async {
    int? metaDatabaseAtual = await ManagerScreenFunctions().getMetaBarberShop();

    setState(() {
      metaDatabase = metaDatabaseAtual;
      //   CalcPercent();
    });
    print("a meta do db esta por: ${metaDatabase}");
  }

  final metaControler = TextEditingController();
  Future<void> functionSetNewMeta() async {
    Provider.of<ManagerScreenFunctions>(context, listen: false).postMetaGeral(
      metaValue: int.parse(metaControler.text),
    );
  }

  void ShowModalMeta() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          height: MediaQuery.of(context).size.height * 0.7,
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Coloque a meta desejada",
                      style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Formato em mil, Exemplo: (1000) - Sem vírgulas ou sinais",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.grey.shade200.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "R\$  ",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(6),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            controller: metaControler,
                            decoration: const InputDecoration(
                              label: Text("VALOR(R\$1000)"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: dialogNewMeta,
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "Salvar alteração",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
  //configurações de meta - FIM
  //ver tudo

  @override
  Widget build(BuildContext context) {
    String mesSelecionado =
        widget.mesInicial == "Clique" ? ultimos4Meses[0] : widget.mesInicial;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      width: double.infinity,
      height: showMoreMonths == false
          ? MediaQuery.of(context).size.height * 0.80
          : MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    //   crossAxisAlignment: showMoreMonths == true ? CrossAxisAlignment.start : CrossAxisAlignment.c,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Faturamento Bruto",
                            style: GoogleFonts.openSans(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Text(
                              "Soma de todos os procedimentos sem considerar assinaturas",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Estabelecimento.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          if (showMoreMonths == false)
                            Text(
                              mesSelecionado,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Estabelecimento.contraPrimaryColor,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          if (showMoreMonths == true)
                            Container(
                              //padding: EdgeInsets.all(1),
                              width: MediaQuery.of(context).size.width * 0.16,
                              height: MediaQuery.of(context).size.height * 0.09,
                              child: ListView.builder(
                                itemCount: 3,
                                itemBuilder: (ctx, index) {
                                  return InkWell(
                                    onTap: () {
                                      print(
                                          "selecionei: ${ultimos4Meses[index]}");
                                      setState(() {
                                        mesSelecionado = ultimos4Meses[index];
                                        loadTotalFaturamentoAtualMes();
                                        Navigator.of(context).push(
                                          DialogRoute(
                                            context: context,
                                            builder: (ctx) {
                                              return GraphicsManagerScreen(
                                                mesSelecionado:
                                                    ultimos4Meses[index],
                                              );
                                            },
                                          ),
                                        );
                                      });
                                    },
                                    child: Text(
                                      ultimos4Meses[index],
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                        ],
                      ),
                      const SizedBox(
                        width: 3,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showMoreMonths = !showMoreMonths;
                          });
                        },
                        child: Icon(
                          Icons.arrow_drop_down,
                          color: Estabelecimento.contraPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.22,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: Text(
                        "R\$${faturamentoExibido.toStringAsFixed(2).replaceAll('.', ',') ?? 0}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          "${percentualVisual.toStringAsFixed(2) ?? 0}% da meta batida",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Estabelecimento.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          height: 30,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                right: 0,
                                child: LinearProgressIndicator(
                                  value: 1,
                                  color: Colors.grey.shade500,
                                  minHeight: 6,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              if (PercentualMeta > 0)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  child: LinearProgressIndicator(
                                    value: PercentualMeta,
                                    color: Colors.green,
                                    minHeight: 6,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.32,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // primeiro container - inicio
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Mês anterior",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "Faturamento vs Último mês",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                          //informacoes do crescimento - inicio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "R\$${faturamentoAnteriorAoEscolhido ?? 0}", // AQUI FATURAMENTO MES ANTERIOR
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        color: calcularDiferencaPercentual() <
                                                0.00
                                            ? Colors.redAccent.withOpacity(0.2)
                                            : Colors.green.withOpacity(0.3),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: calcularDiferencaPercentual() < 0.00
                                        ? const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.red,
                                            size: 20,
                                          )
                                        : const Icon(
                                            Icons.arrow_drop_up,
                                            size: 20,
                                            color: Colors.green,
                                          ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  calcularDiferencaPercentual() < 0.00
                                      ? Text(
                                          "${calcularDiferencaPercentual().toStringAsFixed(2) ?? 0}%",
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Text(
                                          "${calcularDiferencaPercentual().toStringAsFixed(2) ?? 0}%",
                                          style: GoogleFonts.openSans(
                                            textStyle: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            ],
                          ),
                          //informacoes do crescimento - fim
                          //
                        ],
                      ),
                    ),
                    // primeiro container - fim
                    // segundo container - inicio
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profList[0].nomeProf}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "Clientes mês Selecionado",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                          //informacoes do crescimento - inicio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${totalCortesMesSelecionado ?? 0} Cortes", // AQUI FATURAMENTO MES ANTERIOR
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        color:
                                            calcularDiferencaPercentualProfissional1Cortes() >=
                                                    0
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.redAccent
                                                    .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      calcularDiferencaPercentualProfissional1Cortes() >=
                                              0
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      size: 20,
                                      color:
                                          calcularDiferencaPercentualProfissional1Cortes() >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${calcularDiferencaPercentualProfissional1Cortes().toStringAsFixed(2) ?? 0}%",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            calcularDiferencaPercentualProfissional1Cortes() >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //informacoes do crescimento - fim

                          //
                        ],
                      ),
                    ),
                    // segundo container - fim
                    //terceiro container - inicio
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profList[1].nomeProf}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "Clientes mês Selecionado",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                          //informacoes do crescimento - inicio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${totalCortesMesSelecionadoProf2 ?? 0} Cortes", // AQUI FATURAMENTO MES ANTERIOR
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        color:
                                            calcularDiferencaPercentualProfissional2Cortes() >=
                                                    0
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.redAccent
                                                    .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      calcularDiferencaPercentualProfissional2Cortes() >=
                                              0
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      size: 20,
                                      color:
                                          calcularDiferencaPercentualProfissional2Cortes() >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${calcularDiferencaPercentualProfissional2Cortes().toStringAsFixed(2) ?? 0}%",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            calcularDiferencaPercentualProfissional2Cortes() >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //informacoes do crescimento - fim

                          //
                        ],
                      ),
                    ),
                    //terceiro container - fim
                    //container do terceiro profissional
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${profList[2].nomeProf}",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Text(
                                "Clientes mês Selecionado",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                          //informacoes do crescimento - inicio
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${totalCortesMesSelecionadoProf3 ?? 0} Cortes", // AQUI FATURAMENTO MES ANTERIOR
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        color:
                                            calcularDiferencaPercentualProfissional3Cortes() >=
                                                    0
                                                ? Colors.green.withOpacity(0.3)
                                                : Colors.redAccent
                                                    .withOpacity(0.2),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      calcularDiferencaPercentualProfissional3Cortes() >=
                                              0
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      size: 20,
                                      color:
                                          calcularDiferencaPercentualProfissional3Cortes() >=
                                                  0
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "${calcularDiferencaPercentualProfissional3Cortes().toStringAsFixed(2) ?? 0}%",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color:
                                            calcularDiferencaPercentualProfissional3Cortes() >=
                                                    0
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          //informacoes do crescimento - fim

                          //
                        ],
                      ),
                    ),
                    //container do terceiro profissional
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (metaDatabase == 0)
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.orangeAccent,
                        size: 17,
                      ),
                      Text(
                        "Novidade",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: ShowModalMeta,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      border: Border.all(
                        width: 0.2,
                        color: Colors.grey.shade100,
                      ),
                    ),
                    child: Text(
                      "Colocar/editar Meta",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
