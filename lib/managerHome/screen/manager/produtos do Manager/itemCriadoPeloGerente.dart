import 'package:easebase/classes/produtosAVenda.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemParaVenda extends StatefulWidget {
  final Produtosavenda produto;
  const ItemParaVenda({
    super.key,
    required this.produto,
  });

  @override
  State<ItemParaVenda> createState() => _ItemParaVendaState();
}

class _ItemParaVendaState extends State<ItemParaVenda> {

  String descricaoProduto(String descricao, int maxLength) {
  if (descricao.length > maxLength) {
    return descricao.substring(0, maxLength) + '...';
  } else {
    return descricao;
  }
}
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
                  widget.produto.ativoParaExibir ? "item ativo" : "Pausado",
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color:  widget.produto.ativoParaExibir ? Colors.green.shade600 : Colors.grey.shade600,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  "${widget.produto.nome ?? "Carregando..."}",
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
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                descricaoProduto(widget.produto.descricao ?? "carregando...", 15),
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
                  "Estoque: ${widget.produto.estoque ?? 0} Unidades",
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
                      "R\$${widget.produto.preco.toStringAsFixed(2).replaceAll('.', ',')}",
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
                      "- ${widget.produto.quantiavendida ?? 0} Vendidos",
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
              child: widget.produto.urlImage.isNotEmpty
                  ? Image.network(
                      widget.produto.urlImage,
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
