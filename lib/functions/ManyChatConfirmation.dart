// ignore_for_file: unnecessary_null_comparison, unnecessary_type_check, unused_local_variable, file_names, unnecessary_brace_in_string_interps, avoid_print, non_constant_identifier_names, unnecessary_string_interpolations, await_only_futures

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easebase/classes/Estabelecimento.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ManyChatConfirmation with ChangeNotifier {
  //ADICIONANDO O CONTATO

  Future<void> setClientsManyChat({
    required String userPhoneNumber,
    required String username,
    required DateTime dateSchedule,
    required int externalId,
  }) async {
    String cleanedNumber =
        userPhoneNumber.replaceAll(RegExp(r'^\+?55|\- '), '');
    var createSubscriberUrl = Uri.parse(
        "${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/createSubscriber");
    var myManyToken = "${Estabelecimento.myManyToken}";
    print("#manychatPRINT: o numero que chega aqui é o ${cleanedNumber}");
    // Dados do assinante a serem enviados
    var subscriberData = {
      "phone": "+55$cleanedNumber",
      "whatsapp_phone": "+55$cleanedNumber",
      "first_name": username,
      "external_id": externalId.toString(),
      "has_opt_in_sms": true,
      "has_opt_in_email": true,
      "consent_phrase": "I accept receiving messages"
    };

    try {
      // Criar um novo assinante
      var createResponse = await http.post(
        createSubscriberUrl,
        headers: {
          "Authorization": "Bearer $myManyToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(subscriberData),
      );
       print("#manychatPRINT: criando um novo assinante");
      var createResponseBody = jsonDecode(createResponse.body);
      var subscriberId = await createResponseBody['data']['id'];
      print("#manychatPRINT: o id do usuario ficou com: ${subscriberId}");
      await ScheduleMessageFirst(finalDate: dateSchedule, userId: subscriberId);
      await saveContactID(
          phoneNumber: userPhoneNumber, subscriber_id: subscriberId);
      // Assinante criado com sucesso, agora você pode adicionar tags, enviar mensagens, etc.
      print("#manychatPRINT: Assinante criado com sucesso. ID: $subscriberId");
    } catch (e) {
      try {
        print("#manychatPRINT: entrei aqui na funcao de enviar a segunda mensagem ");
        await UserExistButSendConfirmation(phoneNumber: userPhoneNumber);
      } catch (e) {
        print("#manychatPRINT: erro maior, nao executamos");
      }
    }
  }

  Future<void> UserExistButSendConfirmation({
    required String phoneNumber,
  }) async {
    final getSubscriberId =
        await database.collection("ManyChatids").doc(phoneNumber).get();
    try {
      if (getSubscriberId.exists) {
        var subId = await getSubscriberId.data()?["subscriber_id"];
        var myManyToken = "${Estabelecimento.myManyToken}";
        List<String> tag = await getTagsSystem(contactId: subId);
        List<String>? userTag =
            await fetchTags(userId: subId); // Change to nullable
        print("#manychatPRINT: a tag que deveria ser usada é esta: ${tag[0]}");

        // Check if userTag is null or empty
        if (userTag == null || userTag.isEmpty || userTag[0] == null) {
          print("#manychatPRINT: Não há tag definida para este usuário.");
          print("#manychatPRINT: A tag que vamos adicionar será esta: ${tag[0]}");
          print("#manychatPRINT: Não tem tag, vamos enviar.");

          String tagUrl =
              "${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/addTag";

          // Corpo da requisição
          Map<String, dynamic> body = {
            'subscriber_id': subId,
            'tag_id': tag[0],
          };

          // Headers da requisição
          Map<String, String> headers = {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $myManyToken',
          };

          String jsonBody = jsonEncode(body);

          try {
            print("#manychatPRINT: Fazendo o post da tag.");
            final response = await http.post(
              Uri.parse(tagUrl),
              headers: headers,
              body: jsonBody,
            );

            if (response.statusCode == 200) {
              print(
                  'Tag atribuída com sucesso ao contato $subId.');
            } else {
              print(
                  'Erro ao atribuir tag ao contato $subId. Status code: ${response.statusCode}');
              print('Response body: ${response.body}');
            }
          } catch (e) {
            print("#manychatPRINT: Ao enviar a tag ao usuário, ocorreu o seguinte erro: $e");
          }
        } else {
          removetag(
            tagId: tag[0],
            userId: subId,
          );
          print("#manychatPRINT: Tinha tag atribuída, então foi removida.");
        }
      }
    } catch (e) {
      print("#manychatPRINT: Problemas na função da tag, ocorreu o seguinte erro: $e");
    }
  }

  Future<List<String>> getTagsSystem({required String contactId}) async {
    String url =
        '${Estabelecimento.urlKeyManyChatFunctions}/fb/page/getTags';
    String apiKey = '${Estabelecimento.myManyToken}';

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // Decodifica o corpo da resposta de JSON para um mapa (Map<String, dynamic>)
        Map<String, dynamic> data = jsonDecode(response.body);
        print(data);
        // Verifica se a chave 'data' existe no mapa
        if (data.containsKey('data')) {
          print("#manychatPRINT: existe data");
          // Extrai a lista de tags do campo 'data' da resposta
          List<dynamic> tags = data['data'];

          // Mapeia as tags para obter apenas os nomes
          List<String> tagNames =
              tags.map((tag) => tag['id'].toString()).toList();
          print("#manychatPRINT: tagsNames $tagNames");
          // Retorna a lista de nomes das tags
          return tagNames;
        } else {
          // Se 'data' não estiver presente na resposta
          print('Resposta da API não contém o campo "data"');
          return [];
        }
      } else {
        // Se a requisição não for bem sucedida, imprime o código de status
        print('Erro de requisição: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Captura e imprime quaisquer exceções que ocorram durante a requisição
      print("#manychatPRINT: Erro geral na função: $e");
      return [];
    }
  }

  //pegando as tags que ja tem no user
  Future<List<String>> fetchTags({required String userId}) async {
    String url =
        '${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/getInfo?subscriber_id=$userId';
    String accessToken = '${Estabelecimento.myManyToken}';

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      var response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('data')) {
          // Acessa o array de tags dentro de 'data'
          List<dynamic> tagsData = data['data']['tags'];

          if (tagsData is List) {
            List<String> tagNames =
                tagsData.map((tag) => tag['id'].toString()).toList();
            return tagNames;
          } else {
            print(
                'O campo "tags" na resposta da API não é uma lista');
            return [];
          }
        } else {
          print('Resposta da API não contém o campo "data"');
          return [];
        }
      } else {
        print('Erro de requisição: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print("#manychatPRINT: Erro geral na função: $e");
      return [];
    }
  }

  //removendo a tag caso preciso:
  Future<void> removetag(
      {required String userId, required String tagId}) async {
    String url =
        '${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/removeTag';
    String accessToken = '${Estabelecimento.myManyToken}';
    try {
      var subscriberData = {
        "subscriber_id": userId,
        "tag_id": tagId,
      };

      var createResponse = await http.post(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode(subscriberData),
      );
    } catch (e) {
      print("#manychatPRINT: ao remover a tag aconteceu isto: $e");
    }
  }

  //Caso for um usuario novo, também armazenando o id dele no firebase:
  final firebaseAuth = FirebaseAuth.instance;
  final database = FirebaseFirestore.instance;
  Future<void> saveContactID(
      {required String phoneNumber, required String subscriber_id}) async {
    final sendIdFirebase =
        await database.collection("ManyChatids").doc(phoneNumber).set({
      "subscriber_id": subscriber_id,
    });
  }

  //funcao que envia mensagem aos atrasados (desativada)
  Future<void> sendLembreteParaAtrasados({
    required String phoneNumber,
  }) async {
    String url =
        "${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/setCustomFields";
    String accessToken = '${Estabelecimento.myManyToken}';
    String cleanedNumber = phoneNumber.replaceAll(RegExp(r'^\+?55|\-'), '');

    //
    final getSubscriberId =
        await database.collection("ManyChatids").doc(cleanedNumber).get();
    var subId = await getSubscriberId.data()?["subscriber_id"];
    print("#manychatPRINT: o aid do user é ${subId}");
    try {
      var subscriberData = {
        "subscriber_id": subId,
        "fields": [
          {
            "field_id": Estabelecimento.enviarLembreteParaAtrasados,
            "field_name": Estabelecimento.fieldIdLembreteAtrasados,
            "field_value": "${Random().nextDouble().toString()}"
          }
        ]
      };
      var jsonBody = await jsonEncode(subscriberData);
      var createResponse = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      print("#manychatPRINT: o bool foi enviado");
    } catch (e) {
      print("#manychatPRINT: ao enviar o lembrete pelo bool, deu este erro: $e");
    }
  }

  Future<void> ScheduleMessage({
    required String phoneNumber,
    required DateTime finalDate,
  }) async {
    String url =
        "${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/setCustomFields";
    String accessToken = '${Estabelecimento.myManyToken}';
    String cleanedNumber = await phoneNumber.replaceAll(RegExp(r'^\+?55|\-'), '');

    try {
      // Obter o subscriber_id do banco de dados
      final getSubscriberId =
          await database.collection("ManyChatids").doc(cleanedNumber).get();
      var subId = await getSubscriberId.data()?["subscriber_id"];
      print("#manychatPRINT: Schd: o subs id é ${subId}");

      // Formatando a data para o formato desejado (YYYY-MM-DDTHH:MM:SSZ)
      DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss+00:00");
      DateTime horaAtrasada = finalDate.subtract(const Duration(hours: 1));
      String formattedDate = dateFormat.format(horaAtrasada.toUtc());
      print("#manychatPRINT: a hora ficou: ${formattedDate}");
     
      var subscriberData = {
        "subscriber_id": subId,
        "fields": [
          {
            "field_id": Estabelecimento.AtualizarHorarioLembreteAoAgendar,
            "field_name": Estabelecimento.fieldIdAgendamentoMensagem,
            "field_value": formattedDate, // Usar a data formatada
          }
        ]
      };

      var jsonBody = jsonEncode(subscriberData);
      var createResponse = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (createResponse.statusCode == 200) {
        print("#manychatPRINT: Schd: a data foi enviada com sucesso.");
      } else {
        print(
            "Schd: não foi possível enviar a data. Status code: ${createResponse.statusCode}");
      }
    } catch (e) {
      print("#manychatPRINT: Schd: houve um erro ao enviar a data: $e");
    }
  }

  //agendar mensagem para o primeiro perfil do cliente
  Future<void> ScheduleMessageFirst({
    required String userId,
    required DateTime finalDate,
  }) async {
    String url =
        "${Estabelecimento.urlKeyManyChatFunctions}/fb/subscriber/setCustomFields";
    String accessToken = '${Estabelecimento.myManyToken}';

    try {
      // Formatando a data para o formato desejado (YYYY-MM-DDTHH:MM:SSZ)
      DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss+00:00");
      DateTime horaAtrasada = finalDate.subtract(const Duration(hours: 1));
      String formattedDate = dateFormat.format(horaAtrasada.toUtc());
      print("#manychatPRINT: a hora ficou: ${formattedDate}");
      var subscriberData = {
        "subscriber_id": userId,
        "fields": [
          {
            "field_id": Estabelecimento.AtualizarHorarioLembreteAoAgendar,
            "field_name": Estabelecimento.fieldIdAgendamentoMensagem,
            "field_value": formattedDate, // Usar a data formatada
          }
        ]
      };

      var jsonBody = jsonEncode(subscriberData);
      var createResponse = await http.post(
        Uri.parse(url),
        body: jsonBody,
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
      );

      if (createResponse.statusCode == 200) {
        print("#manychatPRINT: Schd: a data foi enviada com sucesso.");
      } else {
        print(
            "Schd: não foi possível enviar a data. Status code: ${createResponse.statusCode}");
      }
    } catch (e) {
      print("#manychatPRINT: Schd: houve um erro ao enviar a data: $e");
    }
  }
}
