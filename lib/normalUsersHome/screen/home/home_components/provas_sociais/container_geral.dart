import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/socialProvas.dart';

class ContainerGeralProvaSocial extends StatefulWidget {
  const ContainerGeralProvaSocial({
    super.key,
  });

  @override
  State<ContainerGeralProvaSocial> createState() =>
      _ContainerGeralProvaSocialState();
}

class _ContainerGeralProvaSocialState extends State<ContainerGeralProvaSocial> {
   
 

 

 
  @override
  Widget build(BuildContext context) {
    final List<provaSocialImages> provasocialListImagens = [
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.4,
        path: 'imagesOfApp/provasSociais/prova1.png',
        title: 'Estilo',//ok
        width: 100,
      ),
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.3,
        path: 'imagesOfApp/provasSociais/prova2.png',
        title: 'Confiança',//ok
        width: 100,
      ),
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.4,
        path: 'imagesOfApp/provasSociais/prova3.png',
        title: 'Moderno',//ok
        width: 50,
      ),
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.3,
        path: 'imagesOfApp/provasSociais/prova4.png',
        title: 'Elegância',//ok
        width: 50,
      ),
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.4,
        path: 'imagesOfApp/provasSociais/prova5.png',
        title: 'Personalizado',//ok
        width: 50,
      ),
      provaSocialImages(
        height: MediaQuery.of(context).size.height * 0.3,
        path: 'imagesOfApp/provasSociais/prova6.png',
        title: 'Renovação',//ok
        width: 50,
      ),
    ];
    double totalHeight =
        provasocialListImagens.fold(0.0, (sum, image) => sum + image.height);

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  'Muito mais que apenas um corte',
                  style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Ajusta a altura para o tamanho do conteúdo
                  children: [
                    MasonryGridView.count(
                      crossAxisCount: 2, // Número de colunas
                      mainAxisSpacing: 15.0,
                      crossAxisSpacing: 15.0,
                      itemCount: provasocialListImagens.length,
                      shrinkWrap:
                          true, // Garante que o grid ajuste a sua altura
                      physics:
                          const NeverScrollableScrollPhysics(), // Desativa a rolagem
                      itemBuilder: (context, index) {
                        final image = provasocialListImagens[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.elliptical(5, 5),
                                topRight: Radius.elliptical(5, 5),
                                bottomLeft: Radius.elliptical(5, 5),
                                bottomRight: Radius.elliptical(5, 5),
                              ),
                              child: Image.asset(
                                image.path,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: image.height.toDouble(),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  image.title,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.grade,
                                      color: Colors.yellow.shade600,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '5.0',
                                      style: GoogleFonts.openSans(
                                        textStyle: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
