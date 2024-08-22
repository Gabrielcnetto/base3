import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/uploadNovosProdutos.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/todosOsProdutosView.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MeusProdutosAdicionados extends StatefulWidget {
  const MeusProdutosAdicionados({super.key});

  @override
  State<MeusProdutosAdicionados> createState() =>
      _MeusProdutosAdicionadosState();
}

class _MeusProdutosAdicionadosState extends State<MeusProdutosAdicionados> {
  bool todosOsProdutos = true;
  bool produtosVendidos = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UploadnovosprodutosBarbeiro>(context, listen: false)
        .LoadProductsBarbearia();
        inttotalProducts();
  }

  int totalProdutos = 0;
  void inttotalProducts() {
    setState(() {
      totalProdutos =
          Provider.of<UploadnovosprodutosBarbeiro>(context, listen: false)
              .produtosAvenda
              .length;
    });
  }

  void ativarProdutosVendidos() {
    if (produtosVendidos == true) {
      return;
    }
    if (produtosVendidos == false) {
      setState(() {
        produtosVendidos = true;
        todosOsProdutos = false;
      });
    }
  }

  void ativarTodosOsProdutos() {
    if (todosOsProdutos == true) {
      return;
    }
    if (todosOsProdutos == false) {
      setState(() {
        todosOsProdutos = true;
        produtosVendidos = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Estabelecimento.primaryColor),
            width: double.infinity,
            padding: EdgeInsets.only(left: 15, right: 15, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Seu Catálogo de produtos',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container() // Placeholder for alignment
                  ],
                ),
                SizedBox(height: 10),
                // Row das opções
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: ativarTodosOsProdutos,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Todos os Produtos",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text("${totalProdutos ?? 0}"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: todosOsProdutos
                                  ? Colors.orangeAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: ativarProdutosVendidos,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Produtos vendidos",
                                    style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text("0"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          Container(
                            height: 5,
                            decoration: BoxDecoration(
                              color: produtosVendidos
                                  ? Colors.orangeAccent
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //parte de ver as informações
          Expanded(
            child: SingleChildScrollView(
              child: todosOsProdutos
                  ? Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TodosOsProdutosView(),
                    )
                  : Container(), // Placeholder for other content
            ),
          ),
        ],
      ),
    );
  }
}
