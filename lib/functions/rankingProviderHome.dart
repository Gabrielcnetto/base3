import 'dart:async';

import 'package:intl/intl.dart';
import 'package:easebase/classes/GeralUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:easebase/classes/cortecClass.dart';

class RankingProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  final storageSettings = FirebaseStorage.instance;

  List<GeralUser> _listaUsers = [];
  List<GeralUser> get listaUsers => [..._listaUsers];

  Future<void> loadingListUsers() async {
    try {
      QuerySnapshot querySnapshot = await database.collection("usuarios").get();
      _listaUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['ultimoAgendamento'] as Timestamp?;
        }
        DateTime diaFinal = timestamp?.toDate() ?? DateTime.now();

        return GeralUser(
          userIdDatabase: data?['userIdDatabase']??'',
          assinaturaId: data?['assinaturaId']?? '',
          isAssinatura: data?['assinatura'] ?? false,
          ultimoAgendamento: diaFinal,
          PhoneNumber: data?["PhoneNumber"] ?? 0,
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
      }).toList();
      // Ordenar a lista em ordem decrescente com base no totalCortes
      _listaUsers
          .sort((a, b) => (b.listacortes ?? 0).compareTo(a.listacortes ?? 0));
    } catch (e) {
      print("houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }
  //lista 2

  List<GeralUser> _listaUsuariosManager2 = [];
  List<GeralUser> get listaUsersManagerView2 => [..._listaUsuariosManager2];

  Future<void> loadingListUsersManagerView2() async {
    try {
      QuerySnapshot querySnapshot = await database.collection("usuarios").get();
      _listaUsuariosManager2 = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['ultimoAgendamento'] as Timestamp?;
        }
        DateTime diaFinal = timestamp?.toDate() ?? DateTime.now();

        return GeralUser(
          userIdDatabase: data?['userIdDatabase'] ?? '',
          assinaturaId: data?['assinaturaId']??'',
          isAssinatura: data?['assinatura'] ?? false,
          ultimoAgendamento: diaFinal,
          PhoneNumber: data?["PhoneNumber"] ?? 0,
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
      }).toList();
      // Ordenar a lista em ordem decrescente com base no totalCortes
      _listaUsuariosManager2
          .sort((a, b) => a.ultimoAgendamento.compareTo(b.ultimoAgendamento));
    } catch (e) {
      print("houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }

  //historico completo
  final StreamController<List<CorteClass>> _CorteslistaManager =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManager => _CorteslistaManager.stream;
  List<CorteClass> _historicoCompletoAllcuts = [];
  List<CorteClass> get historicoCompletoAllcuts =>
      [..._historicoCompletoAllcuts];
  Future<void> loadingListUsersHistoricoCompleto() async {
    try {
      DateTime dataAtual = DateTime.now();
      String monthName = await DateFormat('MMMM', 'pt_BR').format(dataAtual);
      QuerySnapshot querySnapshot = await database
          .collection('totalCortes')
          .doc(monthName)
          .collection('all')
          .get();

      _historicoCompletoAllcuts = querySnapshot.docs.map((item) {
        Map<String, dynamic>? data = item.data() as Map<String, dynamic>?;

        // Converta 'dataCreateAgendamento' de Timestamp para DateTime
        Timestamp? timestamp = data?['dataCreateAgendamento'] as Timestamp?;
        DateTime dateCreateAgendamento = timestamp?.toDate() ?? DateTime.now();

        // Converta 'diaCorte' de Timestamp para DateTime
        Timestamp? diaCorteTimestamp = data?['diaCorte'] as Timestamp?;
        DateTime diaCorteFinal = diaCorteTimestamp?.toDate() ?? DateTime.now();

        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: 0,
          detalheDoProcedimento: data?['detalheDoProcedimento'] ?? "",
          apenasBarba: false,
          isActive: data?['isActive'] ?? false,
          DiaDoCorte: data?['diaDoCorte'] ?? 0,
          clientName: data?['clientName'] ?? "",
          totalValue: data?['totalValue'] ?? 0,
          NomeMes: data?['monthName'] ?? "",
          id: data?['id'] ?? "",
          numeroContato: data?['numeroContato'] ?? "",
          profissionalSelect: data?['profissionalSelect'] ?? "",
          diaCorte: diaCorteFinal,
          horarioCorte: data?['horarioCorte'] ?? "",
          barba: data?['barba'] ?? false,
          ramdomCode: data?['ramdomNumber'] ?? 0,
          dateCreateAgendamento: dateCreateAgendamento,
          horariosExtra: [],
        );
      }).toList();
      _historicoCompletoAllcuts.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _CorteslistaManager.add(_historicoCompletoAllcuts);
      print('#787: tamanho da lista ${_historicoCompletoAllcuts.length}');
      // Ordenar a lista em ordem decrescente com base no totalCortes
    } catch (e) {
      print("#787: houve um erro ao carregar a lista do ranking: ${e}");
    }
    notifyListeners();
  }
}
