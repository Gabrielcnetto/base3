// ignore_for_file: unused_local_variable, dead_code, file_names, non_constant_identifier_names, avoid_print, unnecessary_brace_in_string_interps, prefer_final_fields, unnecessary_string_interpolations, await_only_futures

import 'dart:async';

import 'package:easebase/classes/GeralUser.dart';
import 'package:easebase/classes/cortecClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:easebase/classes/profissionais.dart';

class ManagerScreenFunctions with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authConfigs = FirebaseAuth.instance;
  List<GeralUser> _CLIENTESLISTA = [];
  List<GeralUser> get clientesLista => [..._CLIENTESLISTA];
  Future<void> loadClientes() async {
    try {
      print("acessamos o database");
      QuerySnapshot querySnapshot = await database.collection("usuarios").get();
      print("acessamos aqui alista de clientes");
      _CLIENTESLISTA = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        return GeralUser(
          userIdDatabase: data?['userIdDatabase'] ?? '',
          assinaturaId: data?['assinaturaId'] ?? '',
          isAssinatura: data?["assinatura"] ?? false, //
          ultimoAgendamento: DateTime.now(),
          PhoneNumber: data?["PhoneNumber"] ?? "",
          isfuncionario: data?["isfuncionario"],
          isManager: data?["isManager"],
          listacortes: data?["totalCortes"],
          name: data?["userName"],
          urlImage: data?["urlImagem"],
        );
      }).toList();
      print("o tamanho da lista é ${_CLIENTESLISTA.length}");
    } catch (e) {
      print("houve um erro: ${e}");
    }
    notifyListeners();
  }

  List<CorteClass> _listaCortes = [];
  List<CorteClass> get listaCortes => [..._listaCortes];
  Future<void> loadMonthCortes() async {
    DateTime diaAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(diaAtual);
    print(monthName);

    QuerySnapshot querySnapshot = await database
        .collection("totalCortes")
        .doc("${monthName}")
        .collection("all")
        .get();
    List<DocumentSnapshot> docs = querySnapshot.docs;

    try {
      if (docs.isEmpty) {
        print("a lista de cortes está vazia");
      } else {
        _listaCortes.clear();
        for (var doc in docs) {
          String documentName = doc.id;
          _listaCortes.add(
            CorteClass(
              feitoporassinatura: false,
              pagoComCreditos: false,
              pagoComCupom: false,
              easepoints: 0,
              apenasBarba: false,
              detalheDoProcedimento: "",
              horariosExtra: [],
              totalValue: 0,
              isActive: false,
              DiaDoCorte: 0,
              clientName: "",
              NomeMes: "NomeMes",
              id: "id",
              numeroContato: "",
              profissionalSelect: "",
              diaCorte: DateTime.now(),
              horarioCorte: "",
              barba: false,
              ramdomCode: 0,
              dateCreateAgendamento: DateTime.now(),
            ),
          );
        }
      }
      print("o tamanho da lista pega do firebase é ${_listaCortes.length}");
    } catch (e) {
      print("ocorreu um erro: ${e}");
    }
    notifyListeners();
  }

  final StreamController<List<CorteClass>> _CorteslistaManager =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManager => _CorteslistaManager.stream;

  List<CorteClass> _managerListCortes = [];
  List<CorteClass> get managerListCortes => [..._managerListCortes];
  Future<void> loadAfterSetDay({
    required int selectDay,
    required String selectMonth,
    required String proffName,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      print("peguei o profissional:${proffName}");
      // _CorteslistaManager.sink.add([]); // Isso irá enviar uma lista vazia para o fluxo
      final nomeBarber = Uri.encodeFull(proffName);
      QuerySnapshot querySnapshot = await database
          .collection('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all')
          .get();
      print('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all');
      _managerListCortes = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        List<String>? horariosExtras = data?["horariosExtras"] != null
            ? List<String>.from(data?["horariosExtras"])
            : null;
        // Acessando os atributos diretamente usando []
        print("tipos de dados:");
        print(data?["totalValue"].toString());
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?['easepoints'] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: horariosExtras!,
          totalValue: data?["totalValue"],
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _CorteslistaManager.add(_managerListCortes);

      // Ordenar os dados pela data
      _managerListCortes.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _managerListCortes.sort((a, b) {
        // Aqui, estamos comparando os horários de corte como strings
        return a.horarioCorte.compareTo(b.horarioCorte);
      });
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print("o tamanho da lista é manager ${_managerListCortes.length}");
    notifyListeners();
  }

  Future<void> setDayOff(DateTime date) async {
    DateTime dataAtual = date;
    try {
      database.collection("estabelecimento").doc("diaSelect").set({
        "data": date,
      });
    } catch (e) {
      print("houve um erro ao enviar a data de folga: ${e}");
    }
    notifyListeners();
  }

  Future<void> setTimerBarbaandCabelo(
      {required int MinutoSelecionado, required int segundoSelecionado}) async {
    database.collection("estabelecimento").doc("timerBarba").set({
      'minutoSelecionado': MinutoSelecionado,
      'segundoSelecionado': segundoSelecionado,
    });
  }

  Future<void> setPrice({required int newPrice}) async {
    database.collection("estabelecimento").doc("timerBarba").set({
      'newPrice': newPrice,
    });
  }

  Future<DateTime?> getFolga() async {
    print("entramos no get da folga");
    DateTime? datafolga;
    await database
        .collection("estabelecimento")
        .doc("diaSelect")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;

        // Supondo que você tenha armazenado a data como um timestamp no Firestore
        Timestamp? timestamp = data[
            'data']; // Suponha 'offDay' é o nome do campo que armazena a data de folga

        if (timestamp != null) {
          datafolga = timestamp.toDate(); // Convertendo Timestamp para DateTime
        }
      }
      print("a data que foi pega foi: ${datafolga}");
      return datafolga;
    });
    return datafolga;
  }

  //fazendo os gets dos horarios da barba
  Future<int?> getMinutes() async {
    print("entramos no get da folga");
    int? minutos;
    await database
        .collection("estabelecimento")
        .doc("timerBarba")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        minutos = data['minutoSelecionado'];
      }
      print("a data que foi pega foi: ${minutos}");
      return minutos;
    });
    return minutos;
  }

  Future<int?> getSeconds() async {
    print("entramos no get da folga");
    int? segundos;
    await database
        .collection("estabelecimento")
        .doc("timerBarba")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        segundos = data['segundoSelecionado'];
      }
      print("a data que foi pega foi segundos: ${segundos}");
      return segundos;
    });
    return segundos;
  }

  Future<void> setNewprice({required int newprice}) async {
    database.collection("estabelecimento").doc("price").set({
      'newprice': newprice,
    });
  }

  //get do preco
  Future<int?> getPriceCorte() async {
    print("entramos no get da folga");
    int? newprice;
    await database
        .collection("estabelecimento")
        .doc("price")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        newprice = data['newprice'];
      }
      print("a data que foi pega foi: ${newprice}");
      return newprice;
    });
    return newprice;
  }

  //puxando o nome da lista(nome profissional) que deve carregar
  Future<String?> getNomeFuncionarioParaListarFaturamento() async {
    if (authConfigs.currentUser != null) {
      final String uidUser = await authConfigs.currentUser!.uid;
      String? userName;

      await database.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['nameFuncionario'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  Future<int> loadFaturamentoFuncionarios(
      {required String nomeFuncionario}) async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(monthName)
        .collection(nomeFuncionario)
        .get();

    int totalFaturamento = 0;

    for (QueryDocumentSnapshot doc in acessoFaturamentoSnapshot.docs) {
      // Verifica se o documento é nulo ou não tem a chave 'price'
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('price') && data['price'] is int) {
          totalFaturamento += data['price'] as int;
        }
      }
    }

    return totalFaturamento;
  }

  Future<int> TotalcortesProfissionalMes(
      {required String nomeFuncionario}) async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(monthName)
        .collection(nomeFuncionario)
        .get();

    return acessoFaturamentoSnapshot.docs.length;
  }

  //visao de gerente
  Future<int> loadFaturamentoBarbearia() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("estabelecimento")
        .doc("faturamento")
        .collection(monthName)
        .get();

    int totalFaturamento = 0;

    for (QueryDocumentSnapshot doc in acessoFaturamentoSnapshot.docs) {
      // Verifica se o documento é nulo ou não tem a chave 'price'
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('price') && data['price'] is int) {
          totalFaturamento += data['price'] as int;
        }
      }
    }

    return totalFaturamento;
  }

  //quantia de cortes feitos
  Future<int> TotalcortesMes() async {
    final DateTime dataAtual = DateTime.now();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(dataAtual);
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("estabelecimento")
        .doc("faturamento")
        .collection(monthName)
        .get();

    return acessoFaturamentoSnapshot.docs.length;
  }

  //setando o preco da barba
  Future<void> setAdicionalPriceBarba({required int barbaPrice}) async {
    database.collection("estabelecimento").doc("barbaPrice").set({
      'barbaPrice': barbaPrice,
    });
  }

  Future<int?> getAdicionalBarbaCorte() async {
    print("entramos no get da folga");
    int? barbaPrice;
    await database
        .collection("estabelecimento")
        .doc("barbaPrice")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        barbaPrice = data['barbaPrice'];
      }
      print("a data que foi pega foi: ${barbaPrice}");
      return barbaPrice;
    });
    return barbaPrice;
  }

  //setando a porcentagem
  Future<void> setPorcentagemFuncionario({required int porcentagem}) async {
    database.collection("estabelecimento").doc("porcentagem").set({
      'porcentagem': porcentagem,
    });
  }

  Future<int?> getPorcentagemFuncionario() async {
    print("entramos no get da folga");
    int? porcentagemFuncionario;
    await database
        .collection("estabelecimento")
        .doc("porcentagem")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        porcentagemFuncionario = data['porcentagem'];
      }
      print("a data que foi pega foi: ${porcentagemFuncionario}");
      return porcentagemFuncionario;
    });
    return porcentagemFuncionario;
  }

  // puxando todos os clientes
  Future<List<GeralUser>?> loadAllClientes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("usuarios").get();

      List<GeralUser> allUsers = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GeralUser(
          userIdDatabase: data['userIdDatabase'] ?? '',
          assinaturaId: data['assinaturaId'] ?? '',
          isAssinatura: data['assinatura'] ?? false,
          ultimoAgendamento: DateTime.now(),
          PhoneNumber: data[
              "PhoneNumber"], // Valor padrão para PhoneNumber é uma string vazia
          isManager: false, // Valor padrão para isManager é false
          listacortes: 0,
          isfuncionario: false, // Valor padrão para isfuncionario é false
          name: data['userName'] ??
              "", // Valor padrão para name é uma string vazia
          urlImage: "", // Valor padrão para urlImage é uma string vazia
        );
      }).toList();
      print("o valor da lista(tamanho é de${allUsers.length})");
      return allUsers;
    } catch (e) {
      print("Erro ao carregar os usuários do banco de dados: $e");
      return null;
    }
  }

  //setando e get dos valores adicionais
  Future<void> setAdicionalindex2({required int index2}) async {
    database.collection("estabelecimento").doc("index2").set({
      'index2': index2,
    });
  }

  Future<int?> getAdicionalindex2() async {
    print("entramos no get da folga");
    int? index2;
    await database
        .collection("estabelecimento")
        .doc("index2")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        index2 = data['index2'];
      }
      print("a data que foi pega foi: ${index2}");
      return index2;
    });
    return index2;
  }

  //index 3
  Future<void> setAdicionalindex3({required int index3}) async {
    database.collection("estabelecimento").doc("index3").set({
      'index3': index3,
    });
  }

  Future<int?> getAdicionalindex3() async {
    print("entramos no get da folga");
    int? index3;
    await database
        .collection("estabelecimento")
        .doc("index3")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        index3 = data['index3'];
      }
      print("a data que foi pega foi: ${index3}");
      return index3;
    });
    return index3;
  }

  //index 4
  Future<void> setAdicionalindex4({required int index4}) async {
    database.collection("estabelecimento").doc("index4").set({
      'index4': index4,
    });
  }

  Future<int?> getAdicionalindex4() async {
    print("entramos no get da folga");
    int? index4;
    await database
        .collection("estabelecimento")
        .doc("index4")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        index4 = data['index4'];
      }
      print("a data que foi pega foi: ${index4}");
      return index4;
    });
    return index4;
  }

  //index 5
  Future<void> setAdicionalindex5({required int index5}) async {
    database.collection("estabelecimento").doc("index5").set({
      'index5': index5,
    });
  }

  Future<int?> getAdicionalindex5() async {
    print("entramos no get da folga");
    int? index5;
    await database
        .collection("estabelecimento")
        .doc("index5")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;
        index5 = data['index5'];
      }
      print("a data que foi pega foi: ${index5}");
      return index5;
    });
    return index5;
  }

  //leitura de faturamento no manager especial
  Future<int> loadFaturamentoBarbeariaSelectMenu(
      {required String mesSelecionado}) async {
    print("mes selecionado no load menu: ${mesSelecionado}");
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("estabelecimento")
        .doc("faturamento")
        .collection(mesSelecionado)
        .get();

    int totalFaturamento = 0;

    for (QueryDocumentSnapshot doc in acessoFaturamentoSnapshot.docs) {
      // Verifica se o documento é nulo ou não tem a chave 'price'
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('price') && data['price'] is int) {
          totalFaturamento += data['price'] as int;
        }
      }
    }
    print("valor pego de faturamento: ${totalFaturamento}");
    return totalFaturamento;
  }

  Future<int> loadFaturamentoBarbeariaSelectMenuMesAnterior(
      {required String mesSelecionado}) async {
    print("mes selecionado no load menu: ${mesSelecionado}");
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("estabelecimento")
        .doc("faturamento")
        .collection(mesSelecionado)
        .get();

    int totalFaturamento = 0;

    for (QueryDocumentSnapshot doc in acessoFaturamentoSnapshot.docs) {
      // Verifica se o documento é nulo ou não tem a chave 'price'
      if (doc.exists && doc.data() is Map<String, dynamic>) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('price') && data['price'] is int) {
          totalFaturamento += data['price'] as int;
        }
      }
    }
    print("valor pego de faturamento: ${totalFaturamento}");
    return totalFaturamento;
  }

  // load ultimos 4 meses
  List<String> _ultimos4Meses = [];
  List<String> get ultimos4Meses => [..._ultimos4Meses];
  void gerarUltimos4Meses() {
    print("carregando a lista");
    // Limpar a lista antes de gerar os novos meses
    _ultimos4Meses.clear();

    // Obter o mês atual e o ano atual
    DateTime hoje = DateTime.now();
    int mesAtual = hoje.month;
    int anoAtual = hoje.year;

    // Gerar os últimos 4 meses
    for (int i = 0; i < 4; i++) {
      // Ajustado para gerar os últimos 4 meses
      // Calcular o mês e o ano do mês atual - i
      int mes = mesAtual - i;
      int ano = anoAtual;

      // Ajustar o ano se o mês for menor que 1 (menos de janeiro)
      if (mes <= 0) {
        mes += 12;
        ano--;
      }

      // Converter o número do mês para nome do mês
      String nomeMes = mes == 1
          ? 'Janeiro'
          : mes == 2
              ? 'Fevereiro'
              : mes == 3
                  ? 'Março'
                  : mes == 4
                      ? 'Abril'
                      : mes == 5
                          ? 'Maio'
                          : mes == 6
                              ? 'Junho'
                              : mes == 7
                                  ? 'Julho'
                                  : mes == 8
                                      ? 'Agosto'
                                      : mes == 9
                                          ? 'Setembro'
                                          : mes == 10
                                              ? 'Outubro'
                                              : mes == 11
                                                  ? 'Novembro'
                                                  : 'Dezembro';

      // Criar a string no formato desejado e adicionar à lista
      String mesAno = '$nomeMes';
      _ultimos4Meses.add(mesAno);
    }
  }

  //total de cortes do profissional para comparativo mensais
  Future<int> loadCortesMesesProfissional1MesSelecionado({
    required String mesSelecionado,
    required String profissiona1lName,
  }) async {
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(mesSelecionado)
        .collection(profissiona1lName)
        .get();
    print(
        "##1o caminho buscado foi: mensalCuts/${mesSelecionado}/${profissiona1lName}");
    return acessoFaturamentoSnapshot.docs.length;
  }

  Future<int> loadCortesMesesProfissional1MesAnterior({
    required String mesSelecionado,
    required String profissiona1lName,
  }) async {
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(mesSelecionado)
        .collection(profissiona1lName)
        .get();
    print(
        "##1o caminho buscado foi: mensalCuts/${mesSelecionado}/${profissiona1lName}");
    print("##2 total:${acessoFaturamentoSnapshot.docs.length}");
    return acessoFaturamentoSnapshot.docs.length;
  }

  Future<int> loadCortesMesesProfissional2MesSelecionado({
    required String mesSelecionado,
    required String profissiona1lName,
  }) async {
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(mesSelecionado)
        .collection(profissiona1lName)
        .get();
    print(
        "##3o caminho buscado foi: mensalCuts/${mesSelecionado}/${profissiona1lName}");
    print("##3o total do index1 ${acessoFaturamentoSnapshot.docs.length}");
    return acessoFaturamentoSnapshot.docs.length;
  }

  Future<int> loadCortesMesesProfissional2MesAnterior({
    required String mesSelecionado,
    required String profissiona1lName,
  }) async {
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(mesSelecionado)
        .collection(profissiona1lName)
        .get();
    print(
        "##3o caminho buscado foi: mensalCuts/${mesSelecionado}/${profissiona1lName}");
    print("##3o total do index1 ${acessoFaturamentoSnapshot.docs.length}");
    return acessoFaturamentoSnapshot.docs.length;
  }
  //setando meta

//profissional 3 dados
  Future<int> loadCortesMesesProfissional3MesSelecionado({
    required String mesSelecionado,
    required String profissiona1lName,
  }) async {
    final QuerySnapshot acessoFaturamentoSnapshot = await database
        .collection("mensalCuts")
        .doc(mesSelecionado)
        .collection(profissiona1lName)
        .get();
    print(
        "##3o caminho buscado foi: mensalCuts/${mesSelecionado}/${profissiona1lName}");
    print("##3o total do index1 ${acessoFaturamentoSnapshot.docs.length}");
    return acessoFaturamentoSnapshot.docs.length;
  }

//profissional 3 dados
  Future<void> postMetaGeral({required int metaValue}) async {
    final post =
        await database.collection("estabelecimento").doc("metaMensal").set({
      "metaMensal": metaValue,
    });
    notifyListeners();
  }

  Future<int?> getMetaBarberShop() async {
    int? metaBarbershop;

    await database
        .collection("estabelecimento")
        .doc("metaMensal")
        .get()
        .then((event) {
      if (event.exists) {
        Map<String, dynamic> data = event.data() as Map<String, dynamic>;

        metaBarbershop = data['metaMensal'];
      } else {
        print("este evento nao existe");
      }
      return metaBarbershop;
    });
    return metaBarbershop;
  }

  // load das listas duplas na tela de calendario completo - visao geral
  final StreamController<List<CorteClass>> _CorteslistaManagerProfissional1 =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManagerProfissional1 =>
      _CorteslistaManagerProfissional1.stream;

  List<CorteClass> _managerListCortesProfssional1 = [];
  List<CorteClass> get managerListCortesProfssional1 =>
      [..._managerListCortesProfssional1];
  Future<void> loadAfterSetDayProfissional1({
    required int selectDay,
    required String selectMonth,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      // Isso irá enviar uma lista vazia para o fluxo
      final nomeBarber = Uri.encodeFull(profList[0].nomeProf);
      QuerySnapshot querySnapshot = await database
          .collection('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all')
          .get();
      print('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all');
      _managerListCortesProfssional1 = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        List<String>? horariosExtras = data?["horariosExtras"] != null
            ? List<String>.from(data?["horariosExtras"])
            : null;
        // Acessando os atributos diretamente usando []
        print("tipos de dados:");
        print(data?["totalValue"].toString());
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?['easepoints'] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: horariosExtras!,
          totalValue: data?["totalValue"],
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _CorteslistaManagerProfissional1.add(_managerListCortesProfssional1);

      // Ordenar os dados pela data
      _managerListCortesProfssional1.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _managerListCortesProfssional1.sort((a, b) {
        // Aqui, estamos comparando os horários de corte como strings
        return a.horarioCorte.compareTo(b.horarioCorte);
      });
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print(
        "o tamanho da lista é manager ${_managerListCortesProfssional1.length}");
    notifyListeners();
  }

  //lista 2 da visao geral
  final StreamController<List<CorteClass>> _CorteslistaManagerProfissional2 =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManagerProfissional2 =>
      _CorteslistaManagerProfissional2.stream;

  List<CorteClass> _managerListCortesProfssional2 = [];
  List<CorteClass> get managerListCortesProfssional2 =>
      [..._managerListCortesProfssional1];
  Future<void> loadAfterSetDayProfissional2({
    required int selectDay,
    required String selectMonth,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      // _CorteslistaManagerProfissional2.sink.add([]); // Isso irá enviar uma lista vazia para o fluxo
      final nomeBarber = Uri.encodeFull(profList[1].nomeProf);
      QuerySnapshot querySnapshot = await database
          .collection('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all')
          .get();
      print('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all');
      _managerListCortesProfssional1 = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        List<String>? horariosExtras = data?["horariosExtras"] != null
            ? List<String>.from(data?["horariosExtras"])
            : null;
        // Acessando os atributos diretamente usando []
        print("tipos de dados:");
        print(data?["totalValue"].toString());
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?['easepoints'] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: horariosExtras!,
          totalValue: data?["totalValue"],
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _CorteslistaManagerProfissional2.add(_managerListCortesProfssional1);

      // Ordenar os dados pela data
      _managerListCortesProfssional2.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _managerListCortesProfssional2.sort((a, b) {
        // Aqui, estamos comparando os horários de corte como strings
        return a.horarioCorte.compareTo(b.horarioCorte);
      });
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print(
        "o tamanho da lista é manager ${_managerListCortesProfssional2.length}");
    notifyListeners();
  }

  //EDITAR O VALOR NA TELA DE COMANDA(PARA CASO DE VENDA EXTERNA, OU ALGO)
  Future<void> updateValorCorte({
    required CorteClass corte,
    required String novoValor,
  }) async {
    //atualizando no geral do mês - inicio
    String novoValorFinalparte1 = await novoValor.replaceAll(RegExp(','), '.');
    double valorFinalDatabase = double.parse(novoValorFinalparte1);
    print("#767: o valor final ficou: ${valorFinalDatabase}");
    print("#767: o id é: ${corte.id}");
    try {
      try {
        final update = await database
            .collection('estabelecimento')
            .doc('faturamento')
            .collection('${corte.NomeMes.toLowerCase()}')
            .doc('${corte.id}')
            .update({
          "price": valorFinalDatabase,
        });
        print('#767: tudo ok com a atualização');
      } catch (e) {
        print("#767: atualizando na lista geral da barbearia, deu isto: ${e}");
      }
      //atualizando no geral do mês - fim
      //atualizando na lista normal - inicio
      try {
        final listaGeralUpdate = await database
            .collection('agenda')
            .doc(corte.NomeMes.toLowerCase())
            .collection('${corte.DiaDoCorte}')
            .doc(corte.profissionalSelect)
            .collection('all')
            .doc(corte.horarioCorte)
            .update({
          'totalValue': valorFinalDatabase,
        });
      } catch (e) {
        print("na lista geral deu este erro:$e");
      }
      //atualizando na lista normal - inicio
      //atualizando no faturamento do profissional - inicio
      try {
        final update2 = await database
            .collection('mensalCuts')
            .doc(corte.NomeMes.toLowerCase())
            .collection(corte.profissionalSelect)
            .doc(corte.id)
            .update({
          'price': valorFinalDatabase,
        });
        print('#767: atualizacao2 feita');
      } catch (e) {
        print('#767: erro no update2: $e');
      }
    } catch (e) {
      print("Houve um erro ao atualizar o valor diretamente no database. $e");
    }
    //atualizando no faturamento do profissional - fim

    //atualizando na allcuts - inicio
    try {
      final allcutsAtt = await database
          .collection('allCuts')
          .doc(corte.NomeMes.toLowerCase())
          .collection('${corte.DiaDoCorte}')
          .doc(corte.id)
          .update({
        'totalValue': valorFinalDatabase,
      });
    } catch (e) {
      print('na allcuts, deu este erro:$e');
    }
    //atualizando na allcuts - fim
  }

  //load  do prof 3
  final StreamController<List<CorteClass>> _CorteslistaManagerProfissional3 =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManagerProfissional3 =>
      _CorteslistaManagerProfissional3.stream;

  List<CorteClass> _managerListCortesProfssional3 = [];
  List<CorteClass> get managerListCortesProfssional3 =>
      [..._managerListCortesProfssional1];
  Future<void> loadAfterSetDayProfissional3({
    required int selectDay,
    required String selectMonth,
  }) async {
    print("tela do manager, 7 dias corte funcao executada");

    try {
      // _CorteslistaManagerProfissional2.sink.add([]); // Isso irá enviar uma lista vazia para o fluxo
      final nomeBarber = Uri.encodeFull(profList[2].nomeProf);
      QuerySnapshot querySnapshot = await database
          .collection('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all')
          .get();
      print('agenda/${selectMonth}/${selectDay}/${nomeBarber}/all');
      _managerListCortesProfssional1 = querySnapshot.docs.map((doc) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

        Timestamp? timestamp;
        if (data != null) {
          timestamp = data['dataCreateAgendamento'] as Timestamp?;
        }

        DateTime diaCorte = timestamp?.toDate() ?? DateTime.now();
        //CONVERTENDO O DIA DO CORTE AGORA
        Timestamp? diafinalCorte;
        if (data != null) {
          timestamp = data['diaCorte'] as Timestamp?;
        }

        DateTime diaCorteFinal = diafinalCorte?.toDate() ?? DateTime.now();
        List<String>? horariosExtras = data?["horariosExtras"] != null
            ? List<String>.from(data?["horariosExtras"])
            : null;
        // Acessando os atributos diretamente usando []
        print("tipos de dados:");
        print(data?["totalValue"].toString());
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?['easepoints'] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: horariosExtras!,
          totalValue: data?["totalValue"],
          isActive: data?["isActive"],
          DiaDoCorte: data?["diaDoCorte"],
          NomeMes: data?["monthName"],
          dateCreateAgendamento: diaCorte,
          clientName: data?['clientName'],
          id: data?['id'],
          numeroContato: data?['numeroContato'],
          profissionalSelect: data?['profissionalSelect'],
          diaCorte: diaCorteFinal, // Usando o atributo diaCorte
          horarioCorte: data?['horarioCorte'],
          barba: data?['barba'],
          ramdomCode: data?['ramdomNumber'],
        );
      }).toList();
      _CorteslistaManagerProfissional3.add(_managerListCortesProfssional1);

      // Ordenar os dados pela data
      _managerListCortesProfssional3.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });
      _managerListCortesProfssional3.sort((a, b) {
        // Aqui, estamos comparando os horários de corte como strings
        return a.horarioCorte.compareTo(b.horarioCorte);
      });
    } catch (e) {
      print("ao carregar a lista do manager dia, deu isto: ${e}");
    }
    print(
        "o tamanho da lista é manager ${_managerListCortesProfssional3.length}");
    notifyListeners();
  }
}
