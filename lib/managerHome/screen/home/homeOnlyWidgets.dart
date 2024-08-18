import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/rankingProviderHome.dart';
import 'package:easebase/managerHome/screen/home/home_components/profissionaisList.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/StreamHaveItems.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/homeHeaderSemItens.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/home_noItenswithLoading.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/profissionaisList.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/promotionBanner.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/provas_sociais/container_geral.dart';
import 'package:easebase/normalUsersHome/screen/home/ranking/rankingHome.dart';
import 'package:easebase/normalUsersHome/screen/home/ranking/semUsuarios.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_components/header/header.dart';

class HomeOnlyWidgetsForManagers extends StatefulWidget {
  final bool ismanagerGet;
  final bool isfuncionarioGet;
  const HomeOnlyWidgetsForManagers({
    super.key,
    required this.isfuncionarioGet,
    required this.ismanagerGet,
  });

  @override
  State<HomeOnlyWidgetsForManagers> createState() =>
      _HomeOnlyWidgetsForManagersState();
}

class _HomeOnlyWidgetsForManagersState
    extends State<HomeOnlyWidgetsForManagers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).userCortesTotal;
    Provider.of<RankingProvider>(context, listen: false).loadingListUsers();
    Provider.of<RankingProvider>(context, listen: false)
        .loadingListUsersManagerView2();
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
            StreamHaveItens(
              heighTela: heighTela,
              widhTela: widhtTela,
            ),
            ProfissionaisListProfView(
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
