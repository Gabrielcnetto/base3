// ignore_for_file: unused_local_variable, file_names, avoid_print, use_rethrow_when_possible, prefer_final_fields, await_only_futures, unnecessary_brace_in_string_interps, unnecessary_cast

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easebase/classes/cupomClass.dart';

class CupomProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  //criacao do cupom - inicio
  Future<void> postNewCoupum({required cupomClass cupomClassInfs}) async {
    String cupomCodigo = "#${cupomClassInfs.codigo}";
    try {
      final post =
          await database.collection("cupons").doc(cupomClassInfs.codigo).set(
        {
          "name": cupomClassInfs.name,
          "id": cupomClassInfs.id,
          "horario": cupomClassInfs.horario,
          "isActive": cupomClassInfs.isActive,
          "codigo": cupomCodigo,
          "multiplicador": cupomClassInfs.multiplicador,
        },
      );
      notifyListeners();
    } catch (e) {
      print("#erro ao criar cupom no provider : $e");
      throw e;
    }
  }

  //criacao do cupom - fim
  StreamController<List<cupomClass>> _cupomStream =
      StreamController<List<cupomClass>>.broadcast();

  Stream<List<cupomClass>> get cupomStream => _cupomStream.stream;
  List<cupomClass> _cupomList = [];
  List<cupomClass> get cupomList => [..._cupomList];
  Future<void> loadCupons() async {
    print("funcao de carregar os cupons");
    QuerySnapshot querySnapshot = await database.collection("cupons").get();
    _cupomList = await querySnapshot.docs.map((doc) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      return cupomClass(
        codigo: data?['codigo'],
        name: data?['name'],
        horario: data?['horario'],
        id: data?['id'],
        isActive: data?['isActive'],
        multiplicador: data?['multiplicador'],
      );
    }).toList();

    _cupomStream.add(_cupomList);

    print("#90 o valor lengh final é ${_cupomList.length}");
    notifyListeners();
  }

  Future<void> turnOfforActiveFcuntionsCoupon({
    required cupomClass cupomItens,
  }) async {
    try {
      bool? atualValue;
      String cupomCodigoParaBuscar =
          await cupomItens.codigo.replaceAll(RegExp('#'), '');
      final cupomDoc =
          await database.collection('cupons').doc(cupomCodigoParaBuscar).get();
      if (cupomDoc.exists) {
        atualValue = cupomDoc.data()?['isActive'];
      }
      if (atualValue == true) {
        print("era true e agora vai ser false");
        final coupon = await database
            .collection('cupons')
            .doc(cupomCodigoParaBuscar)
            .update({
          "isActive": false,
        });
      } else {
        print("era false e agora vai ser true");
        final coupon = await database
            .collection('cupons')
            .doc(cupomCodigoParaBuscar)
            .update({
          "isActive": true,
        });
      }

      notifyListeners();
    } catch (e) {
      print("ao deixar off deu este erro: $e");
    }
  }

  Future<void> deleteCoupon({required cupomClass cupom}) async {
    String cupomCodigoParaBuscar =
        await cupom.codigo.replaceAll(RegExp('#'), '');
    print("nome do cupom será:${cupomCodigoParaBuscar}");
    try {
      final delete = await database
          .collection("cupons")
          .doc(cupomCodigoParaBuscar)
          .delete();
    } catch (e) {
      print("nao consegui deletar o cupon, motivo: $e");
    }
  }

  List<cupomClass> _cupomBuscado = [];
  List<cupomClass> get cupomBuscado => [..._cupomBuscado];
  StreamController<List<cupomClass>> _cupomBuscadoStream =
      StreamController<List<cupomClass>>.broadcast();

  Stream<List<cupomClass>> get cupomStreamBusca => _cupomBuscadoStream.stream;
  Future<void> searchCoupon({required String cupom}) async {
    String textoSemSimbolos = cupom.replaceAll('#', '');

    try {
      print("o objeto buscado foi: ${textoSemSimbolos}");
      final pesquisaDocs =
          await database.collection("cupons").doc(textoSemSimbolos).get();

      if (pesquisaDocs.exists) {
        Map<String, dynamic>? data =
            pesquisaDocs.data() as Map<String, dynamic>?;
        cupomClass novoCupom = cupomClass(
          id: pesquisaDocs.id,
          codigo: data?['codigo'],
          name: data?['name'],
          horario: data?['horario'],
          isActive: data?['isActive'],
          multiplicador: data?['multiplicador'],
        );
        _cupomBuscado.add(novoCupom);
        _cupomBuscadoStream.add(_cupomBuscado);
        print("buscamos, e ocorreu tudo certo");
      }
    } catch (e) {
      print("ao pesquisar o cupom deu este erro: $e");
    }
  }

  Future<void> AtivarOuDesativarUsoDeCupom({required bool Possivel}) async {
    final set = await database
        .collection("estabelecimento")
        .doc('possibilidadeUsoCupom')
        .set({
      'possivel': Possivel,
    });
  }

  Future<void> setValorResgateCuponsGerenteFunctions(
      {required int points}) async {
    final set =
        await database.collection("estabelecimento").doc('resgateCupons').set({
      'totalParaResgate': points,
    });
  }

  Future<bool?> getPossivelUsarCupom() async {
    bool? possibilidadeDeUsoCupom;

    await database
        .collection("estabelecimento")
        .doc("possibilidadeUsoCupom")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;

        possibilidadeDeUsoCupom = data['possivel'] ?? false;
      } else {}
      return possibilidadeDeUsoCupom;
    });
    return possibilidadeDeUsoCupom;
  }

  Future<int?> getCupons() async {
    int? pontuacaoSetada;

    await database
        .collection("estabelecimento")
        .doc("resgateCupons")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;

        pontuacaoSetada = data['totalParaResgate'] ?? 0;
      } else {}
      return pontuacaoSetada;
    });
    return pontuacaoSetada;
  }
}
