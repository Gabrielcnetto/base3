import 'dart:io';

import 'package:easebase/classes/Estabelecimento.dart';
import 'package:easebase/classes/produtosAVenda.dart';
import 'package:easebase/functions/uploadNovosProdutos.dart';
import 'package:easebase/managerHome/screen/manager/produtos%20do%20Manager/produtosAdicionadosParaVenda.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VisaoInternaDoProdutoCriado extends StatefulWidget {
  final Produtosavenda produto;
  const VisaoInternaDoProdutoCriado({
    super.key,
    required this.produto,
  });

  @override
  State<VisaoInternaDoProdutoCriado> createState() =>
      _VisaoInternaDoProdutoCriadoState();
}

class _VisaoInternaDoProdutoCriadoState
    extends State<VisaoInternaDoProdutoCriado> {
  @override
  void initState() {
    super.initState();
    toggleAtivacaoOuDesativarProduto = widget.produto.ativoParaExibir;
    DescricaoDoProdutoControler.text = widget.produto.descricao;
    nomeDoProdutoControler.text = widget.produto.nome;
    precoProdutoControler.text = widget.produto.preco.toString() + "0";
    estoqueDisponivel.text = widget.produto.estoque.toString();
    precoProdutoControler.addListener(() {
      final text = precoProdutoControler.text;
      final formattedText = _formatToCurrency(text);
      if (text != formattedText) {
        precoProdutoControler.value = TextEditingValue(
          text: formattedText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: formattedText.length),
          ),
        );
      }
    });
  }

  String _formatToCurrency(String text) {
    // Remove todos caracteres não numéricos
    final rawText = text.replaceAll(RegExp('[^0-9]'), '');
    final number = double.tryParse(rawText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    return formatter
        .format(number / 100); // Divida por 100 para converter centavos
  }

  final nomeDoProdutoControler = TextEditingController();
  final DescricaoDoProdutoControler = TextEditingController();
  final precoProdutoControler = TextEditingController();
  final estoqueDisponivel = TextEditingController();
  XFile? image;

  //GET IMAGEM DO PERFIL - FINAL(CAMERA)
  Future<void> getNewImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    setState(() {
      image = pickedFile;
    });
    //await setNewimageOnDB(); funcao pra enviar ao db, aguardar depois e adicionar
  }

  bool loadingAdd = false;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool toggleAtivacaoOuDesativarProduto = false;
  Future<void> alterarPossibilidadeBotao() async {
    print("entrei na troca do toggle");
    try {
      setState(() {
        toggleAtivacaoOuDesativarProduto = !toggleAtivacaoOuDesativarProduto;
      });
      print("valor final do bool: $toggleAtivacaoOuDesativarProduto");
      await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
          .ToggleProdutoDoCatalogoDaBarbearia(
        productId: widget.produto.id,
        newBool: toggleAtivacaoOuDesativarProduto,
      );
    } catch (e) {
      print("ao atualizar geral do bool:$e");
    }
  }

  Future<void> AtualizarDados() async {
    try {
      setState(() {
        loadingAdd = true;
      });
      String valorFormatado =
          precoProdutoControler.text.replaceAll("R\$", "").trim();
      valorFormatado = valorFormatado.replaceAll(",", ".");
      double valorDouble = double.parse(valorFormatado);
      if (image != null) {
        await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
            .uploadDeImagem(
          productId: widget.produto.id,
          urlImage: File(image!.path),
        );
      }
      if (nomeDoProdutoControler.text != widget.produto.nome) {
        await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
            .setNewTitle(
          productId: widget.produto.id,
          newtitle: nomeDoProdutoControler.text,
        );
      }
      if (precoProdutoControler.text != widget.produto.preco.toString()) {
        await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
            .setNewPrice(
          productId: widget.produto.id,
          newPrice: valorDouble,
        );
      }
      if (DescricaoDoProdutoControler.text != widget.produto.descricao) {
        await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
            .setNewDescription(
          productId: widget.produto.id,
          newDescription: DescricaoDoProdutoControler.text,
        );
      }
      if (estoqueDisponivel.text != widget.produto.estoque.toString()) {
        await Provider.of<UploadnovosprodutosBarbeiro>(listen: false, context)
            .setNewEstoque(
          productId: widget.produto.id,
          newEstoque: int.parse(estoqueDisponivel.text),
        );
      }
      setState(() {
        loadingAdd = false;
      });

      showDialog(
          context: context,
          builder: (ctx) {
            Future.delayed(Duration(seconds: 3), () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Produto Atualizado!",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              content: Text(
                "Os dados do seu Produto Foram Atualizados.",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          });
    } catch (e) {
      print("erro ao atualizar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "Seu Produto",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.grey.shade200,
                                ),
                                child: Icon(
                                  Icons.cancel_rounded,
                                  size: 25,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: image == null
                                  ? Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.network(
                                          "${widget.produto.urlImage ?? ""}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.24,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          File(image!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              child: InkWell(
                                onTap: () {
                                  if (!kIsWeb) {
                                    getNewImage();
                                  } else {
                                    showDialog(
                                        context: context,
                                        builder: (ctx) {
                                          return AlertDialog(
                                            title: Text(
                                                "Para atualizar a imagem, utilize o App"),
                                            content: Text(
                                                "esta funcão não é permitida pelo Site"),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Fechar",
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  transformAlignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: Estabelecimento.primaryColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Atualizar Imagem",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.library_add,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 1,
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Catálogo de Vendas",
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding: EdgeInsets.all(5),
                                              child: Icon(
                                                Icons.storefront,
                                                size: 15,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Ativo",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Catálogo Principal",
                                          style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: alterarPossibilidadeBotao,
                                      child: Icon(
                                        toggleAtivacaoOuDesativarProduto == true
                                            ? Icons.toggle_on
                                            : Icons.toggle_off,
                                        size: 50,
                                        color:
                                            toggleAtivacaoOuDesativarProduto ==
                                                    true
                                                ? Colors.blue.shade600
                                                : Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //outras informações
                        SizedBox(
                          height: 15,
                        ),
                        //NOME DO PRODUTO - INICIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nome do Produto",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite um Nome';
                                    }
                                    return null;
                                  },
                                  controller: nomeDoProdutoControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Clique para Digitar",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //NOME DO PRODUTO - FIM
                        //PRECO DO PRODUTO - INICIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Preço",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor, digite um Preço';
                                    }
                                    return null;
                                  },
                                  controller: precoProdutoControler,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    CurrencyInputFormatter(),
                                    // Custom formatter to ensure currency format is applied
                                  ],
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Clique para Digitar(R\$)",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //PRECO DO PRODUTO - FIM
                        //descrição inicio
                        SizedBox(
                          height: 15,
                        ),
                        //PRECO DO PRODUTO - INICIO
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Adicione uma Descrição",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 0.7,
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  vertical: 25,
                                  horizontal: 10,
                                ),
                                child: TextFormField(
                                  maxLines:
                                      5, // Permite que o campo expanda verticalmente
                                  minLines: 1,
                                  controller: DescricaoDoProdutoControler,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Atualize com uma Descrição do Produto",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //descrição fim
                        SizedBox(
                          height: 15,
                        ),
                        //ROW DE ESTOQUE
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 0.1,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Quantidade em Estoque:",
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade800,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 0.2,
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: MediaQuery.of(context).size.width * 0.2,
                                height:
                                    MediaQuery.of(context).size.height * 0.08,
                                padding: EdgeInsets.all(8),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Quantia?';
                                    }
                                    return null;
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  controller: estoqueDisponivel,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    label: Text(
                                      "Digite",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black38,
                                          fontSize: 11,
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
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                AtualizarDados();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade600,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                "Atualizar Produto",
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (loadingAdd == true) ...[
              Opacity(
                opacity: 0.5,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
              Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final rawText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    final number = double.tryParse(rawText) ?? 0;
    final formatter = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    );
    final formattedText = formatter.format(number / 100);
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: formattedText.length),
      ),
    );
  }
}
