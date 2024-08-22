import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/functions/uploadNovosProdutos.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/TelaDosProdutosAdicionados.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProdutosParaVendaIcon extends StatelessWidget {
  const ProdutosParaVendaIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: () {
 
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext ctx) {
                return const MeusProdutosAdicionados();
              },
            ),
            (Route<dynamic> route) => false, // Remove todas as rotas anteriores
          ); //
        },
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Estabelecimento.primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Image.asset(
                      "imagesOfApp/meusprodutositem.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Seus Produtos",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Clique para acessar",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white54,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_outlined,
                    size: 20,
                    color: Colors.white54,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
