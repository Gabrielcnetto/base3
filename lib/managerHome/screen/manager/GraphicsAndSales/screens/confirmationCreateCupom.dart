import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/rotas/Approutes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ConfirmCreateCupomImage extends StatefulWidget {
  final String cupomCode;
  final String horarioCupom;
  const ConfirmCreateCupomImage({
    super.key,
    required this.cupomCode,
    required this.horarioCupom,
  });

  @override
  State<ConfirmCreateCupomImage> createState() =>
      _ConfirmCreateCupomImageState();
}

class _ConfirmCreateCupomImageState extends State<ConfirmCreateCupomImage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadImage();
  }

  String UrlImage = "";
  void loadImage() {
    List<String> partes = widget.horarioCupom.split(":");
    String horas = partes[0];
    String minutos = partes[1];
    String urlNet =
        "https://res.cloudinary.com/dn7f8uryz/image/upload/co_rgb:000000,l_text:arial_60_bold_normal_left:${widget.cupomCode.toUpperCase()}/fl_layer_apply,x_30,y_-270/co_rgb:000000,l_text:arial_80_bold_underline_left:${horas}%253A${minutos}/fl_layer_apply,y_500/ruv3tgz63r6nmmc4j3fi.jpg";
    setState(() {
      UrlImage = urlNet;
    });
  }

  Future<void> _shareImageFromUrl() async {
    if (kIsWeb) {
      await showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                "Para compartilhar, use o App",
                style: GoogleFonts.openSans(
                  textStyle: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              content: Text(
                "Compartilhar novos cupons diretamente nas redes sociais é permitido apenas criando o cupom pelo App",
                style: GoogleFonts.openSans(
                  textStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutesApp.HomeScreen01);
                  },
                  child: Text(
                    "Fechar",
                    style: GoogleFonts.openSans(
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            );
          });
    } else if (Platform.isAndroid || Platform.isIOS) {
      try {
        // Baixar a imagem
        final response = await http.get(Uri.parse(UrlImage));
        final bytes = response.bodyBytes;

        // Obter o diretório temporário
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/temp_image.jpg').create();

        // Escrever os bytes no arquivo
        await file.writeAsBytes(bytes);

        // Compartilhar o arquivo
        Share.shareXFiles(
          [XFile(file.path)],
        );
      } catch (e) {
        print('Erro ao baixar ou compartilhar a imagem: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutesApp.HomeScreen01,
                        );
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade400,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                          AppRoutesApp.HomeScreen01,
                        );
                      },
                      child: Text(
                        "Voltar",
                        style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  children: [
                    Text(
                      "Cupom Criado!",
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Compartilhe seu cupom nos stories para os clientes ficarem sabendo da promoção!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    //Container da imagem
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.67,
                child: Image.network(
                  UrlImage,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _shareImageFromUrl,
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.share,
                              color: Colors.black,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Compartilhar Agora",
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
