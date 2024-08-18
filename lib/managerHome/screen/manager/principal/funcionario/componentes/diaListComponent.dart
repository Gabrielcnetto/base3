import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:easebase/functions/CorteProvider.dart';

import 'package:flutter/material.dart';
import 'package:easebase/managerHome/screen/manager/principal/components/agendaDia/semCortesHoje.dart';
import 'package:easebase/managerHome/screen/manager/principal/funcionario/componentes/itemComponentHour.dart';
import 'package:provider/provider.dart';

class DiaListaComponentFuncionario extends StatefulWidget {
  
  const DiaListaComponentFuncionario({
  
    super.key,
  });

  @override
  State<DiaListaComponentFuncionario> createState() => _DiaListaComponentState();
}

class _DiaListaComponentState extends State<DiaListaComponentFuncionario> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadCortesAtualDayForManager();

  }

 

  Future<void> loadCortesAtualDayForManager() async {
    print("Entrei na funcao do load Manager Widget");
    Provider.of<CorteProvider>(context, listen: false)
        .loadHistoryCortesManagerScreen();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<CorteProvider>(context, listen: false)
            .CorteslistaManager,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: LinearProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const semCortesHojewidget();
          } else {
            final List<CorteClass>? cortes = snapshot.data;
            if (cortes != null) {
              return Column(
                children: cortes.map((corte) {
                  return ItemComponentHourFuncionario(
                    key: Key(corte.id),
                    Corte: corte,
                   
                  );
                }).toList(),
              );
            }
          }
          return Container();
        });
  }
}
