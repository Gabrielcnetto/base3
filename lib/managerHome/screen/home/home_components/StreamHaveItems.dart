import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/functions/CorteProvider.dart';
import 'package:easebase/functions/profileScreenFunctions.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/header.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/homeHeaderSemItens.dart';
import 'package:easebase/normalUsersHome/screen/home/home_components/header/home_noItenswithLoading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StreamHaveItens extends StatefulWidget {
  final double widhTela;
  final double heighTela;

  const StreamHaveItens(
      {super.key, required this.heighTela, required this.widhTela});

  @override
  State<StreamHaveItens> createState() => _StreamHaveItensState();
}

class _StreamHaveItensState extends State<StreamHaveItens> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<CorteProvider>(context, listen: false).loadHistoryCortes();
    loadUserIsManager();
    loadUserIsFuncionario();
  }

  bool? isManager;

  Future<void> loadUserIsManager() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsManager();

    if (isManager != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      isManager = bolIsManager!;
    });
  }

   bool? isFuncionario;

  Future<void> loadUserIsFuncionario() async {
    bool? bolIsManager = await MyProfileScreenFunctions().getUserIsFuncionario();

    if (isFuncionario != null) {
    } else {
      const Text('N/A');
    }

    setState(() {
      isFuncionario = bolIsManager!;
    });
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<CorteProvider>(context, listen: true).cortesStream,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SafeArea(
            child: Home_noItensWithLoadin(
              heighTela: widget.heighTela,
              widhTela: widget.widhTela,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else {
          final List<CorteClass>? cortes = snapshot.data;

          if (cortes != null &&
              cortes.isNotEmpty &&
              cortes[0].isActive == true &&
              isManager != true && isFuncionario !=true) {
            // Se houver itens na lista, mostre o widget correspondente
            return SafeArea(
              child: HomePageHeader(
                heighTela: widget.heighTela,
                widhTela: widget.widhTela,
              ),
            );
          } else {
            // Se a lista estiver vazia, mostre o widget correspondente
            return SafeArea(
              child: HomeHeaderSemLista(
                heighTela: widget.heighTela,
                widhTela: widget.widhTela,
              ),
            );
          }
        }
      },
    );
  }
}
