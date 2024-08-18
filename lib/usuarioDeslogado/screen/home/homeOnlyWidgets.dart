import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/rankingProviderHome.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/StreamHaveItems.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/homeHeaderSemItens.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/home_noItenswithLoading.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/profissionaisList.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/promotionBanner.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/provas_sociais/container_geral.dart';
import 'package:easebase/normalUsersHome/screen/home/ranking/rankingHome.dart';
import 'package:easebase/normalUsersHome/screen/home/ranking/semUsuarios.dart';
import 'package:flutter/material.dart';
import 'package:easebase/usuarioDeslogado/screen/home/home_components/header/homeHeaderSemItens.dart';
import 'package:easebase/usuarioDeslogado/screen/home/home_components/profissionaisList.dart';
import 'package:provider/provider.dart';

import '../../../classes/GeralUser.dart';
import 'home_components/header/header.dart';

class HomeOnlyWidgetsDeslogado extends StatefulWidget {
  const HomeOnlyWidgetsDeslogado({super.key});

  @override
  State<HomeOnlyWidgetsDeslogado> createState() => _HomeOnlyWidgetsDeslogadoState();
}

class _HomeOnlyWidgetsDeslogadoState extends State<HomeOnlyWidgetsDeslogado> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).userCortesTotal;
    Provider.of<RankingProvider>(context, listen: false).loadingListUsers();
    Provider.of<RankingProvider>(context, listen: false).listaUsers;
    List<GeralUser> userList =
        Provider.of<RankingProvider>(context, listen: false).listaUsers;
  }

  @override
  Widget build(BuildContext context) {
    int rankingTamanho =
        Provider.of<RankingProvider>(context, listen: true).listaUsers.length;

    double widhtTela = MediaQuery.of(context).size.width;
    double heighTela = MediaQuery.of(context).size.height;
    bool existList = Provider.of<CorteProvider>(context, listen: false)
                .userCortesTotal
                .length >=
            1
        ? true
        : false;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         SafeArea(
              child: HomeHeaderSemListaDeslogado(
                heighTela: heighTela,
                widhTela: widhtTela,
              ),
            ),
            ProfissionaisListDeslogado(
              heighScreen: heighTela,
              widhScreen: widhtTela,
            ),
            PromotionBannerComponents(
              widhtTela: widhtTela,
            ),
            const ContainerGeralProvaSocial(),
            rankingTamanho >= 5
                ? RankingHome(
                    heighScreen: heighTela,
                    widhScreen: widhtTela,
                  )
                : const RankingSemUsuarios(),
          ],
        ),
      ),
    );
  }
}
