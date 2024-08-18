import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easebase/classes/cupomClass.dart';
import 'package:easebase/functions/cupomProvider.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/cupomItensViewList.dart';
import 'package:easebase/managerHome/screen/manager/GraphicsAndSales/screens/tela_de_criar_cupom.dart';
import 'package:provider/provider.dart';

class CuponsCreateandListView extends StatefulWidget {
  const CuponsCreateandListView({super.key});

  @override
  State<CuponsCreateandListView> createState() =>
      _CuponsCreateandListViewState();
}

class _CuponsCreateandListViewState extends State<CuponsCreateandListView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Provider.of<CupomProvider>(context, listen: false).loadCupons();

  }

 
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey.shade300,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bem-vindo(a) à tela dos seus cupons",
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          "Crie seus Cupons Exclusivos",
                          style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "imagesOfApp/banners/cupons_banner.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Todos os seus cupons criados",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(
                            "Desative manualmente assim que a promoção acabar",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade400,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          DialogRoute(
                              context: context,
                              builder: (ctx) {
                                return const CreateInfsCupom();
                              }),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding:
                            const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Criar",
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                const CuponsViewItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
