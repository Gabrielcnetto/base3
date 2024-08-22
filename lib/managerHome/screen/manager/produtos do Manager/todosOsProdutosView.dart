import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/produtosAVenda.dart';
import 'package:easebase/functions/uploadNovosProdutos.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/CadastroDeProdutos.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/itemCriadoPeloGerente.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/visaoInternaDoProdutoCriado.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TodosOsProdutosView extends StatefulWidget {
  const TodosOsProdutosView({super.key});

  @override
  State<TodosOsProdutosView> createState() => _TodosOsProdutosViewState();
}

class _TodosOsProdutosViewState extends State<TodosOsProdutosView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();super.initState();
        Provider.of<UploadnovosprodutosBarbeiro>(context, listen: false)
        .LoadProductsBarbearia();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //criar um novo item
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return CadastrodeProdutosMeuCatalogo();
                    }));
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 0.1, color: Colors.grey.shade200),
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adicione um novo item",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //items visualização abaixo
            Text(
              "Sua lista",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
            ),
            StreamBuilder(
              stream: Provider.of<UploadnovosprodutosBarbeiro>(context,
                      listen: false)
                  .ProdutosAvendaStream,
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (ctx) {
                          return CadastrodeProdutosMeuCatalogo();
                        }));
                      },
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text(
                              "Adicione seu Primeiro Produto",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  final List<Produtosavenda>? produtosLista = snapshot.data;
                  return Column(
                    children: produtosLista!.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) => VisaoInternaDoProdutoCriado(
                                      produto: item,
                                    )));
                          },
                          child: ItemParaVenda(
                            produto: item,
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
