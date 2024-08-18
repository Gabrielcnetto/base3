import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/rotas/Approutes.dart';

class MediaHorariosPreenchidos extends StatefulWidget {
  const MediaHorariosPreenchidos({super.key});

  @override
  State<MediaHorariosPreenchidos> createState() =>
      _MediaHorariosPreenchidosState();
}

class _MediaHorariosPreenchidosState extends State<MediaHorariosPreenchidos> {
  List<Horarios> _listaHorariosEncaixe = [...listaHorariosEncaixe];
  Map<String, int> horariosCount = {};

  @override
  void initState() {
    super.initState();
    fetchHorariosCount();
  }

  bool isLoadingList = false;
  Future<void> fetchHorariosCount() async {
    setState(() {
      isLoadingList = true;
    });
    try {
      for (var horario in _listaHorariosEncaixe) {
        final docRef = FirebaseFirestore.instance
            .collection("ComumPosts")
            .doc(horario.horario);
        final docSnapshot = await docRef.get();

        horariosCount[horario.horario] =
            docSnapshot.exists ? docSnapshot["totaldeMarcacoes"] : 0;
      }

      // Ordena os horários com base no valor em horariosCount
      _listaHorariosEncaixe.sort((a, b) {
        return (horariosCount[b.horario] ?? 0)
            .compareTo(horariosCount[a.horario] ?? 0);
      });
    } catch (e) {
      print("##4Erro ao buscar horários: $e");
    } finally {
      setState(() {
        isLoadingList = false;
      });
    }
  }

  bool viewMoreDetails = false;
  @override
  Widget build(BuildContext context) {
    int totalCount = horariosCount.values.fold(0, (sum, count) => sum + count);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: isLoadingList == false
              ? Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Icon(
                              Icons.keyboard_arrow_left_sharp,
                              color: Colors.black,
                              size: 15,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Ocupação de Horários na ${Estabelecimento.nomeLocal}",
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              Estabelecimento.urlLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Horários",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey.shade600,
                              size: 18,
                            ),
                            Text(
                              "Vezes escolhida",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Estabelecimento.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      width: double.infinity,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Entenda este Ranking",
                                style: GoogleFonts.openSans(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewMoreDetails = !viewMoreDetails;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Estabelecimento.contraPrimaryColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Saiba mais',
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                            color: Estabelecimento.primaryColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        viewMoreDetails == false
                                            ? Icons.arrow_drop_down
                                            : Icons.arrow_drop_up_outlined,
                                        color: Estabelecimento.primaryColor,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (viewMoreDetails == true)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "1 - A Barra azul representa a % de vezes que este horário costuma ser escolhido.",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Text(
                                      "2 - O Valor numérico representa quantos agendamentos foram feitos neste horário.",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Text(
                                      "3 - O Alerta ao lado do valor é uma maneira de sugerir possíveis focos de melhorias.",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Text(
                                      "4- Está é uma média de todos os profissionais de todo o período da ${Estabelecimento.nomeLocal}.",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    child: Text(
                                      "5- *Sugestão: Crie cupons para serem usados em horários com baixa frequência no ranking abaixo. (Acesse a área de cupons)",
                                      style: GoogleFonts.openSans(
                                        textStyle: TextStyle(
                                          color: Estabelecimento
                                              .contraPrimaryColor,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: _listaHorariosEncaixe.length,
                          itemBuilder: (context, index) {
                            if (index >= _listaHorariosEncaixe.length) {
                              return Container(); // Previne acessos fora do range
                            }
                            final horario = _listaHorariosEncaixe[index];
                            int count = horariosCount[horario.horario] ?? 0;
                            double percentage =
                                totalCount > 0 ? count / totalCount : 0.0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "${horario.horario}",
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: LinearProgressIndicator(
                                          minHeight: 10,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.blue.shade600,
                                          value: percentage,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          count <= 1
                                              ? Icons.warning
                                              : count <= 4
                                                  ? Icons.info
                                                  : count <= 8
                                                      ? Icons.check_circle
                                                      : Icons.star,
                                          size: 15,
                                          color: count <= 1
                                              ? Colors.red
                                              : count <= 4
                                                  ? Colors.orangeAccent
                                                  : count <= 8
                                                      ? Colors.yellow
                                                      : Colors.green.shade600,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "${count.toString()}",
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image.asset(
                          "imagesOfApp/loadingGif.gif",
                     
                        ),
                      ),
                      Text(
                        "Carregando...",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
