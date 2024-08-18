// ignore_for_file: unused_local_variable, equal_keys_in_map, dead_code, file_names, non_constant_identifier_names, avoid_print, await_only_futures, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:math';

import 'package:easebase/classes/cortecClass.dart';
import 'package:easebase/classes/horarios.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class CorteProvider with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;

  //    feitoporassinatura: data?['feitoPorassinatura'] ?? false,
  //pagoComCreditos: data?['pagoComCreditos'] ?? false,
  //ENVIANDO O CORTE PARA AS LISTAS NO BANCO DE DADOS - INICIO
  Future<void> AgendamentoCortePrincipalFunctions({
    required CorteClass corte,
    required DateTime selectDateForUser,
    required String nomeBarbeiro,
    required int pricevalue,
    required bool barbaHoraExtra,
    required int valorMultiplicador,
  }) async {
    print("entrei na funcao");

    await initializeDateFormatting('pt_BR');
    int diaCorteSelect = corte.diaCorte.day;
    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(selectDateForUser);
    print(monthName);
    print("entrei na funcao");
    final bool pagoPeloApp = await corte.pagoComCreditos;
    final nomeBarber = Uri.encodeFull(nomeBarbeiro);
    final String idUserDeslogado = Random().nextDouble().toString();
    try {
      //adicionado lista principal de cortes do dia
      final addOnDB = await database
          .collection("agenda")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(corte.horarioCorte)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': pagoPeloApp,
        "pagocomcupom": corte.pagoComCupom,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": corte.horariosExtra,
        "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "id": corte.id,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA INICIO :
      // ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA INICIO:
      if (barbaHoraExtra == true) {
        // Verificar se o primeiro horário extra não existe antes de adicioná-lo
        final docRefHorario2 = database
            .collection("agenda")
            .doc(monthName)
            .collection("${diaCorteSelect}")
            .doc(nomeBarber)
            .collection("all")
            .doc(corte.horariosExtra[0]);
        final docSnapshotHorario2 = await docRefHorario2.get();
        if (!docSnapshotHorario2.exists) {
          await docRefHorario2.set({
            'feitoPorassinatura': corte.feitoporassinatura,
            'pagoComCreditos': pagoPeloApp,
            'pagocomcupom': corte.pagoComCupom,
            "detalheDoProcedimento": "",
            "horariosExtras": [],
            "totalValue": 0,
            'isActive': false,
            "diaDoCorte": corte.DiaDoCorte,
            "id": "extra",
            "dataCreateAgendamento": corte.dateCreateAgendamento,
            "clientName": "extra",
            "numeroContato": "extra",
            "barba": false,
            "diaCorte": corte.diaCorte,
            "horarioCorte": corte.horarioCorte,
            "profissionalSelect": "extra",
            "ramdomNumber": 00000,
            "monthName": "extra",
          });
        }

        // Verificar se o segundo horário extra não existe antes de adicioná-lo
        final docRefHorario3 = database
            .collection("agenda")
            .doc(monthName)
            .collection("${diaCorteSelect}")
            .doc(nomeBarber)
            .collection("all")
            .doc(corte.horariosExtra[1]);
        final docSnapshotHorario3 = await docRefHorario3.get();
        if (!docSnapshotHorario3.exists) {
          await docRefHorario3.set({
            'feitoPorassinatura': corte.feitoporassinatura,
            'pagoComCreditos': pagoPeloApp,
            'pagocomcupom': corte.pagoComCupom,
            "horariosExtras": [],
            "detalheDoProcedimento": "",
            "totalValue": 0,
            'isActive': false,
            "diaDoCorte": corte.DiaDoCorte,
            "id": "extra",
            "dataCreateAgendamento": corte.dateCreateAgendamento,
            "clientName": "extra",
            "numeroContato": "extra",
            "barba": false,
            "diaCorte": corte.diaCorte,
            "horarioCorte": corte.horarioCorte,
            "profissionalSelect": "extra",
            "ramdomNumber": 00000,
            "monthName": "extra",
          });
        }
      }

      //ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA FIM :
      //adicionado allcuts
      final addAllcuts = await database
          .collection("allCuts")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(corte.id)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': pagoPeloApp,
        'pagocomcupom': corte.pagoComCupom,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": corte.horariosExtra,
        "totalValue": corte.totalValue,
        "id": corte.id,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //adicionando na lista de cada funcionario - inicio

      final addOnProfListAllcuts = await database
          .collection("mensalCuts")
          .doc(monthName)
          .collection(corte.profissionalSelect)
          .doc(corte.id)
          .set({
        "price": pricevalue,
      });
      //adicionando na lista de cada funcionario - fim

      //adicionando o valor no faturamento total da barbearia - inicio

      if (corte.feitoporassinatura == false) {
        final addFaturamentoTotal = await database
            .collection("estabelecimento")
            .doc("faturamento")
            .collection(monthName)
            .doc(corte.id)
            .set({
          "price": pricevalue,
          "cliente": corte.clientName,
        });
      }
      //adicionando o valor no faturamento total da barbearia - fim

      final addTotalCortes = await database
          .collection("totalCortes")
          .doc(monthName)
          .collection("all")
          .doc(corte.id)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': pagoPeloApp,
        'pagocomcupom': corte.pagoComCupom,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": corte.horariosExtra,
        "id": corte.id,
        "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": corte.DiaDoCorte,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": corte.horarioCorte,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //adicionando em lista aleatoria apenas para soma:
      final userId = await authSettings.currentUser!.uid;
      if (authSettings.currentUser != null) {
        final myCortes = await database
            .collection("meusCortes")
            .doc(userId)
            .collection("lista")
            .doc(corte.id)
            .set({
          'feitoPorassinatura': corte.feitoporassinatura,
          'pagoComCreditos': pagoPeloApp,
          'pagocomcupom': corte.pagoComCupom,
          "easepoints": valorMultiplicador,
          "detalheDoProcedimento": corte.detalheDoProcedimento,
          "horariosExtras": corte.horariosExtra,
          "id": corte.id,
          "totalValue": corte.totalValue,
          'isActive': corte.isActive,
          "diaDoCorte": corte.DiaDoCorte,
          "clientName": corte.clientName,
          "numeroContato": corte.numeroContato,
          "barba": corte.barba,
          "diaCorte": corte.diaCorte,
          "dataCreateAgendamento": corte.dateCreateAgendamento,
          "horarioCorte": corte.horarioCorte,
          "profissionalSelect": corte.profissionalSelect,
          "ramdomNumber": corte.ramdomCode,
          "monthName": monthName,
          "easepoints": (1 * valorMultiplicador),
        });

        //caso for usado o saldo da carteira, aqui substraimos o saldo
        if (corte.pagoComCreditos == true) {
          try {
            final updateSaldo =
                await database.collection('usuarios').doc(userId).update({
              'saldoConta': FieldValue.increment(-corte.totalValue),
            });
          } catch (e) {
            print('ao reduzir o saldo houve isto: $e');
          }
        }

        //adicionado aos meus cortes
        try {
          final updateLenghCortesInProfile =
              await database.collection("usuarios").doc(userId).update({
            "easepoints": FieldValue.increment(1 * valorMultiplicador),
            "totalCortes": FieldValue.increment(1),
          });
        } catch (e) {
          print("ao atualizar os easepoints do user deu isto: $e");
        }
        final upDateDatetimeLastCortes =
            await database.collection("usuarios").doc(userId).update({
          "ultimoAgendamento": corte
              .diaCorte, //update do int para +1 atualizando ototal de cortes
        });
        //CASO FOR UMA TROCA DE PONTOS POR CORTES, ESSE CODIGO É LIDO:
        if (corte.pagoComCupom) {
          try {
            final String userId = authSettings.currentUser!.uid;
            int pontosASubtrair = 0;

            await database
                .collection("estabelecimento")
                .doc("resgateCupons")
                .get()
                .then((event) {
              if (event.exists) {
                Map<String, dynamic> data =
                    event.data() as Map<String, dynamic>;

                pontosASubtrair = data['totalParaResgate'] ?? 0;
              } else {
                print("#erro77 erro ao fazer o get dos pontos");
              }
            });
            final attPointsInProfile =
                await database.collection('usuarios').doc(userId).update({
              'easepoints': FieldValue.increment(-pontosASubtrair),
            });
          } catch (e) {
            print("#erro77 a leitura e subtracao de pontos deu erro: $e");
          }
        }
      }
    } catch (e) {
      print("#erro77 ocorreu isto:${e.toString()}");

    }
    notifyListeners();
  }
  //ENVIANDO O CORTE PARA AS LISTAS NO BANCO DE DADOS - FIM

  //CARREGANDO OS CORTES E FAZENDO A VERIFICACAO - INICIO

  List<Horarios> _horariosListLoad = [];
  List<Horarios> get horariosListLoad => [..._horariosListLoad];
  //
  Future<void> loadCortesDataBaseFuncionts({
    required DateTime mesSelecionado,
    required int DiaSelecionado,
    required String Barbeiroselecionado,
  }) async {
    _horariosListLoad.clear();
    await initializeDateFormatting('pt_BR');

    String monthName = DateFormat('MMMM', 'pt_BR').format(mesSelecionado);
    final nomeBarber = Uri.encodeFull(Barbeiroselecionado);

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("agenda")
          .doc(monthName)
          .collection("${DiaSelecionado}")
          .doc(nomeBarber)
          .collection("all")
          .get();

      List<Horarios> horarios = querySnapshot.docs.map((doc) {
        return Horarios(
          quantidadeHorarios: 1,
          horario: doc.id,
          id: "",
        );
      }).toList();
      for (var hor in _horariosListLoad) {
        print("horario da lista preenchido: ${hor.horario}");
      }
      _horariosListLoad = horarios;
      notifyListeners();
      DiaSelecionado = 0;
    } catch (e) {
      print("o erro especifico é: ${e}");
    } // Notifica os ouvintes sobre a mudança nos dados
  }

  final StreamController<List<CorteClass>> _cortesController =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get cortesStream => _cortesController.stream;

  List<CorteClass> _historyList = [];
  List<CorteClass> get userCortesTotal => [..._historyList];
  Future<void> loadHistoryCortes() async {
    try {
      // Emite a lista atualizada através do StreamController

      QuerySnapshot querySnapshot = await database
          .collection('meusCortes/${authSettings.currentUser!.uid}/lista')
          .get();

      _historyList = querySnapshot.docs.map((doc) {
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
        // Acessando os atributos diretamente usando []
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?['easepoints'] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: data?["horariosExtras"] != null
              ? List<String>.from(data?["horariosExtras"])
              : [],

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
      _cortesController.add(_historyList);
      // Ordenar os dados pela data
      _historyList.sort((a, b) {
        return b.dateCreateAgendamento.compareTo(a.dateCreateAgendamento);
      });

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os dados do Firebase: $e');
    }
  }

  //CARREGANDO A LISTA DO DIA, PARA EXIBIR NA TELA DE MANAGER (lista 2) - INICIO
  final StreamController<List<CorteClass>> _CorteslistaManager =
      StreamController<List<CorteClass>>.broadcast();

  Stream<List<CorteClass>> get CorteslistaManager => _CorteslistaManager.stream;

  List<CorteClass> _managerListCortes = [];
  List<CorteClass> get managerListCortes => [..._managerListCortes];
  Future<void> loadHistoryCortesManagerScreen() async {
    print("Entrei na funcao do load Manager");
    try {
      print("Entrei no try do manager");
      // Emite a lista atualizada através do StreamController
      DateTime MomentoAtual = DateTime.now();
      await initializeDateFormatting('pt_BR');
      int diaAtual = MomentoAtual.day;
      String monthName = DateFormat('MMMM', 'pt_BR').format(MomentoAtual);
      QuerySnapshot querySnapshot =
          await database.collection('allCuts/${monthName}/${diaAtual}').get();

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
        // Acessando os atributos diretamente usando []
        return CorteClass(
          feitoporassinatura: data?['feitoPorassinatura'] ?? false,
          pagoComCreditos: data?['pagoComCreditos'] ?? false,
          pagoComCupom: data?['pagocomcupom'] ?? false,
          easepoints: data?[''] ?? 0,
          apenasBarba: false,
          detalheDoProcedimento: data?["detalheDoProcedimento"] ?? "",
          horariosExtra: data?["horariosExtras"] != null
              ? List<String>.from(data?["horariosExtras"])
              : [],

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

      notifyListeners();
    } catch (e) {
      print('Erro ao carregar os dados do Firebase do Manager: $e');
    }
  }

  //CARREGANDO ALISTA DO DIA, PARA EXIBIR NA TELA DO MANAGER(LISTA2) - FIM

  Future<void> desmarcarCorte(CorteClass corte) async {
    final String useriDSearch = await authSettings.currentUser!.uid;
    try {
      //retirando a pontuacao deste procedimento - inicio

      //retirando a pontuacao deste procedimento - fim
      //DELETANDO DA LISTA PRINCIPAL - INICIO
      print("Entramos na configuração de excluir");
      final nomeBarber = Uri.encodeFull(corte.profissionalSelect);
      final referencia = await database
          .collection("agenda")
          .doc(corte.NomeMes)
          .collection("${corte.DiaDoCorte}")
          .doc(nomeBarber)
          .collection("all")
          .doc(corte.horarioCorte);
      if (corte.barba == true) {
        final referencia2 = await database
            .collection("agenda")
            .doc(corte.NomeMes)
            .collection("${corte.DiaDoCorte}")
            .doc(nomeBarber)
            .collection("all")
            .doc(corte.horariosExtra[0]);
        final referencia3 = await database
            .collection("agenda")
            .doc(corte.NomeMes)
            .collection("${corte.DiaDoCorte}")
            .doc(nomeBarber)
            .collection("all")
            .doc(corte.horariosExtra[1]);

        await referencia2.delete();
        await referencia3.delete();
      }

      print("Esta é a referência: ${referencia.path}");

      await referencia.delete();
      //DELETANDO DA LISTA PRINCIPAL - FIM
      //DELETANDO DA MINHA LISTA - INICIO
      final referenciaMeusCortes = database
          .collection("meusCortes")
          .doc(useriDSearch)
          .collection("lista")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");

      await referenciaMeusCortes.delete();
      //DELETANDO DA MINHA LISTA FIM
      //Desmarcando da lista do profissional
      final faturamentoGeral = await database
          .collection("estabelecimento")
          .doc("faturamento")
          .collection(corte.NomeMes)
          .doc(corte.id);
      final mensalProfissional = await database
          .collection("mensalCuts")
          .doc(corte.NomeMes)
          .collection(nomeBarber)
          .doc(corte.id);
      final totalCortes = await database
          .collection("totalCortes")
          .doc(corte.NomeMes)
          .collection("all")
          .doc(corte.id);
      await faturamentoGeral.delete();
      await mensalProfissional.delete();
      await totalCortes.delete();
      print("Deletamos com sucesso");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }

    notifyListeners();
  }

  Future<void> desmarcarCorteMeus(CorteClass corte) async {
    String useriDSearch = await authSettings.currentUser!.uid;
    try {
      print("#989 fazendo o get do total de pontos deste corte");

      // Variável para armazenar a pontuação total gerada
      int pontuacaoTotalGerada = 0;
      final docPointsGet = await database
          .collection("meusCortes")
          .doc(useriDSearch)
          .collection("lista")
          .doc(corte.id)
          .get();
      if (docPointsGet.exists) {
        pontuacaoTotalGerada = await docPointsGet.data()?['easepoints'] ?? 0;
        final userAtt =
            await database.collection("usuarios").doc(useriDSearch).update({
          'totalCortes': FieldValue.increment(-1),
        });
        final totalCortesSub =
            await database.collection("usuarios").doc(useriDSearch).update({
          'easepoints': FieldValue.increment(-pontuacaoTotalGerada),
        });
        print("#989 após o 2 get o valor do int ficou:${pontuacaoTotalGerada}");

        //recuperando os pontos no caso de cancelamento - inicio
        if (corte.pagoComCupom) {
          try {
            final String userId = authSettings.currentUser!.uid;
            int pontosASubtrair = 0;

            await database
                .collection("estabelecimento")
                .doc("resgateCupons")
                .get()
                .then((event) {
              if (event.exists) {
                Map<String, dynamic> data =
                    event.data() as Map<String, dynamic>;

                pontosASubtrair = data['totalParaResgate'] ?? 0;
              } else {
                print("#erro77 erro ao fazer o get dos pontos");
              }
            });
            final attPointsInProfile =
                await database.collection('usuarios').doc(userId).update({
              'easepoints': FieldValue.increment(pontosASubtrair),
            });
          } catch (e) {
            print("#erro77 a leitura e subtracao de pontos deu erro: $e");
          }
        }
      } else {
        print("este caminho nao foi encontrado");
      }
      if (corte.pagoComCreditos == true) {
        try {
          final updateSaldo =
              await database.collection('usuarios').doc(useriDSearch).update({
            'saldoConta': FieldValue.increment(corte.totalValue),
          });
        } catch (e) {
          print('ao reduzir o saldo houve isto: $e');
        }
      }
    } catch (e) {
      // Capturando e tratando possíveis erros
      print("#989 houve um erro ao tentar acessar o documento: $e");
    }
    try {
      final referenciaMeusCortes = database
          .collection("meusCortes")
          .doc(useriDSearch)
          .collection("lista")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");
      await referenciaMeusCortes.delete();
      _historyList.removeWhere((item) => item.id == corte.id);
      _cortesController.add(_historyList);

      print("Deletamos com sucesso o do MeusCortes");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }
    notifyListeners();
  }

  Future<void> desmarcarAgendaManager(CorteClass corte) async {
    try {
      final referenciaMeusCortes = database
          .collection("allCuts")
          .doc(corte.NomeMes)
          .collection("${corte.DiaDoCorte}")
          .doc(corte.id);
      print("referenciaMeus: ${referenciaMeusCortes.path}");
      await referenciaMeusCortes.delete();
      _historyList.removeWhere((item) => item.id == corte.id);
      _cortesController.add(_historyList);

      print("Deletamos com sucesso o do MeusCortes");
    } catch (e) {
      print("Não conseguimos excluir, houve um erro: ${e}");
    }
    notifyListeners();
  }

  Future<void> removeAgendamentoForEditReagendar({
    required CorteClass corte,
    required String nomeMes,
    required String horario,
    required String nomeBarbeiro,
  }) async {
    //Referencia
    int diaCorteSelect = corte.DiaDoCorte;
    try {
      await initializeDateFormatting('pt_BR');

      final nomeBarber = Uri.encodeFull(nomeBarbeiro);
      final caminhoParaExcluir = await database
          .collection("agenda")
          .doc(nomeMes)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(horario);
      final totalCortes = await database
          .collection("totalCortes")
          .doc(corte.NomeMes)
          .collection("all")
          .doc(corte.id);
      try {
        await caminhoParaExcluir.delete();
        totalCortes.delete();
        print("o caminho foi excluido");
      } catch (e) {
        print("na funcao deletar deu iso: $e");
      }
      print("deletamos da agenda");
    } catch (e) {
      print("houve um erro pra tentar excluir este horário");
    }
  }

  Future<void> removeAgendamentoForEditReagendar2({
    required CorteClass corte,
    required String nomeMes,
    required String horario,
    required String nomeBarbeiro,
  }) async {
    //Referencia
    int diaCorteSelect = corte.DiaDoCorte;

    try {
      await initializeDateFormatting('pt_BR');

      final nomeBarber = Uri.encodeFull(nomeBarbeiro);
      final caminhoParaExcluir = await database
          .collection("agenda")
          .doc(nomeMes)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(horario);

      try {
        await caminhoParaExcluir.delete();
        print("o caminho foi excluido");
      } catch (e) {
        print("na funcao deletar deu iso: $e");
      }
      print("deletamos da agenda");
    } catch (e) {
      print("houve um erro pra tentar excluir este horário");
    }
  }

  Future<void> removeAgendamentoForEditReagendar3({
    required CorteClass corte,
    required String nomeMes,
    required String horario,
    required String nomeBarbeiro,
  }) async {
    //Referencia
    int diaCorteSelect = corte.DiaDoCorte;

    try {
      await initializeDateFormatting('pt_BR');

      final nomeBarber = Uri.encodeFull(nomeBarbeiro);
      final caminhoParaExcluir = await database
          .collection("agenda")
          .doc(nomeMes)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(horario);

      try {
        await caminhoParaExcluir.delete();
        print("o caminho foi excluido");
      } catch (e) {
        print("na funcao deletar deu iso: $e");
      }
      print("deletamos da agenda");
    } catch (e) {
      print("houve um erro pra tentar excluir este horário");
    }
  }

  Future<void> RemoveFaturamentosRemarcacao(CorteClass corte) async {
    final nomeBarber = Uri.encodeFull(corte.profissionalSelect);
    final faturamentoGeral = await database
        .collection("estabelecimento")
        .doc("faturamento")
        .collection(corte.NomeMes)
        .doc(corte.id);
    final mensalProfissional = await database
        .collection("mensalCuts")
        .doc(corte.NomeMes)
        .collection(nomeBarber)
        .doc(corte.id);

    await faturamentoGeral.delete();
    await mensalProfissional.delete();
  }

  Future<void> AgendamentoCortePrincipalFunctionsRemarcacao(
      {required CorteClass corte,
      required DateTime selectDateForUser,
      required String nomeBarbeiro,
      required int pricevalue,
      required String hourSetForUser,
      required bool barbaHoraExtra,
      required List<String> horariosExtras}) async {
    print("entrei na funcao de reagendamento");

    await initializeDateFormatting('pt_BR');
    int diaCorteSelect = selectDateForUser.day;
    String idAleatorioNew = Random().nextDouble().toString();
    String monthName =
        await DateFormat('MMMM', 'pt_BR').format(selectDateForUser);
    print(monthName);
    print("entrei na funcao para reagendamento");
    final nomeBarber = Uri.encodeFull(nomeBarbeiro);
    print(
        "#6 Caminho: agenda/$monthName/${diaCorteSelect}/$nomeBarber/all/${hourSetForUser}");
    try {
      //adicionado lista principal de cortes do dia
      final addOnDB = await database
          .collection("agenda")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(nomeBarber)
          .collection("all")
          .doc(hourSetForUser)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': false,
        'pagocomcupom': false,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": horariosExtras,
        "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": diaCorteSelect,
        "id": idAleatorioNew,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": hourSetForUser,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA INICIO :
      // ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA INICIO:
      if (barbaHoraExtra == true) {
        // Verificar se o primeiro horário extra não existe antes de adicioná-lo
        final docRefHorario2 = database
            .collection("agenda")
            .doc(monthName)
            .collection("${diaCorteSelect}")
            .doc(nomeBarber)
            .collection("all")
            .doc(horariosExtras[0]);
        final docSnapshotHorario2 = await docRefHorario2.get();
        if (!docSnapshotHorario2.exists) {
          await docRefHorario2.set({
            'feitoPorassinatura': corte.feitoporassinatura,
            'pagoComCreditos': false,
            'pagocomcupom': false,
            "detalheDoProcedimento": "",
            "horariosExtras": [],
            "totalValue": 0,
            'isActive': false,
            "diaDoCorte": diaCorteSelect,
            "id": "extra",
            "dataCreateAgendamento": corte.dateCreateAgendamento,
            "clientName": "extra",
            "numeroContato": "extra",
            "barba": false,
            "diaCorte": corte.diaCorte,
            "horarioCorte": hourSetForUser,
            "profissionalSelect": "extra",
            "ramdomNumber": 00000,
            "monthName": "extra",
          });
        }

        // Verificar se o segundo horário extra não existe antes de adicioná-lo
        final docRefHorario3 = database
            .collection("agenda")
            .doc(monthName)
            .collection("${diaCorteSelect}")
            .doc(nomeBarber)
            .collection("all")
            .doc(horariosExtras[1]);
        final docSnapshotHorario3 = await docRefHorario3.get();
        if (!docSnapshotHorario3.exists) {
          await docRefHorario3.set({
            'feitoPorassinatura': corte.feitoporassinatura,
            'pagoComCreditos': false,
            'pagocomcupom': false,
            "detalheDoProcedimento": "",
            "horariosExtras": [],
            "totalValue": 0,
            'isActive': false,
            "diaDoCorte": diaCorteSelect,
            "id": "extra",
            "dataCreateAgendamento": corte.dateCreateAgendamento,
            "clientName": "extra",
            "numeroContato": "extra",
            "barba": false,
            "diaCorte": corte.diaCorte,
            "horarioCorte": hourSetForUser,
            "profissionalSelect": "extra",
            "ramdomNumber": 00000,
            "monthName": "extra",
          });
        }
      }

      //ADICIONANDO 2 HORARIOS EXTRAS PARA SEREM PREENCHIDOS PELO HORARIO QUE É A BARBA FIM :
      //adicionado allcuts
      final addAllcuts = await database
          .collection("allCuts")
          .doc(monthName)
          .collection("${diaCorteSelect}")
          .doc(idAleatorioNew)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': false,
        'pagocomcupom': false,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": horariosExtras,
        "totalValue": corte.totalValue,
        "id": idAleatorioNew,
        'isActive': corte.isActive,
        "diaDoCorte": diaCorteSelect,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": hourSetForUser,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
      //adicionando na lista de cada funcionario - inicio
      final addOnProfListAllcuts = await database
          .collection("mensalCuts")
          .doc(monthName)
          .collection(corte.profissionalSelect)
          .doc(idAleatorioNew)
          .set({
        "price": pricevalue,
      });
      //adicionando na lista de cada funcionario - fim

      //adicionando o valor no faturamento total da barbearia - inicio
      final addFaturamentoTotal = await database
          .collection("estabelecimento")
          .doc("faturamento")
          .collection(monthName)
          .doc(idAleatorioNew)
          .set({
        "price": pricevalue,
        "cliente": corte.clientName,
      });
      //adicionando o valor no faturamento total da barbearia - fim

      final addTotalCortes = await database
          .collection("totalCortes")
          .doc(monthName)
          .collection("all")
          .doc(idAleatorioNew)
          .set({
        'feitoPorassinatura': corte.feitoporassinatura,
        'pagoComCreditos': false,
        'pagocomcupom': false,
        "detalheDoProcedimento": corte.detalheDoProcedimento,
        "horariosExtras": horariosExtras,
        "id": idAleatorioNew,
        "totalValue": corte.totalValue,
        'isActive': corte.isActive,
        "diaDoCorte": diaCorteSelect,
        "dataCreateAgendamento": corte.dateCreateAgendamento,
        "clientName": corte.clientName,
        "numeroContato": corte.numeroContato,
        "barba": corte.barba,
        "diaCorte": corte.diaCorte,
        "horarioCorte": hourSetForUser,
        "profissionalSelect": corte.profissionalSelect,
        "ramdomNumber": corte.ramdomCode,
        "monthName": monthName,
      });
    } catch (e) {
      print("o agenadmento noao foi feito. Deu Isto: ${e}");
    }
    notifyListeners();
  }
}
//"agenda/${}/${}/${}/all/${}";