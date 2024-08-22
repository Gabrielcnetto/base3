import 'package:easebase/classes/produtosAVenda.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemParaVenda extends StatelessWidget {
  final Produtosavenda produto;
  const ItemParaVenda({
    super.key,
    required this.produto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.1,
          color: Colors.black12,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Text(
                  "item ativo",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.green.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  "${produto.nome ?? "Carregando..."}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  "${produto.descricao ?? "carregando..."}",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Estoque: ${produto.estoque ?? 0} Unidades",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Text(
                      "R\$${produto.preco.toStringAsFixed(2).replaceAll('.', ',')}",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "- ${produto.quantiavendida ?? 0} Vendidos",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.3,
            height: MediaQuery.of(context).size.height * 0.2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: produto.urlImage.isNotEmpty
                  ? Image.network(
                      produto.urlImage,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "imagesOfApp/caixa_itemsemFoto.png",
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
