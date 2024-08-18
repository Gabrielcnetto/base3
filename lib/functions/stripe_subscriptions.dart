import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeSubscriptions with ChangeNotifier {
  final database = FirebaseFirestore.instance;
  final authSettings = FirebaseAuth.instance;
  String chavePublicavel =
      'pk_live_51PhN0AJbuFc8lkJcbRa8cs7RwiwCSYLDN9t0fYZBDzPljS3IZdjsjLnXdfySp6ag69vuah4kvBkEvrwaVpqvgi1700YJEUalH6';
  String chaveSecreta =
      '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';
  final StripeChama = Stripe.instance;

  Future<Map<String, dynamic>> createCustomer(String email) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': email,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create customer');
    }
  }

  Future<Map<String, dynamic>> createPrice(int amount) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/prices'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'unit_amount': amount.toString(),
        'currency': 'BRL',
        'recurring[interval]': 'month',
        'product_data[name]': 'Monthly Subscription',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create price');
    }
  }

  Future<Map<String, dynamic>> createSubscription(
      String customerId, String priceId) async {
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
        'items[0][price]': priceId,
      },
    );

    if (response.statusCode == 200) {
      try {
        final userIdDB = await authSettings.currentUser!.uid;
        final subscription = await jsonDecode(response.body);
        String subscriptionId = await subscription['id'];
        final pubOnSubsIdDATABASEUser =
            await database.collection('usuarios').doc(userIdDB).update({
          'assinaturaId': subscriptionId,
        });
      } catch (e) {
        print('ao pegar o id do usuario e enviar ao db:$e');
      }
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create subscription');
    }
  }

  Future<Map<String, dynamic>> attachPaymentMethod(
      String customerId, String paymentMethodId) async {
    final response = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'customer': customerId,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to attach payment method');
    }
  }

  Future<void> createAndSubscribeCustomer(
      String email, int amount, PaymentMethod paymentMethod) async {
    final customer = await createCustomer(email);
    final customerId = customer['id'];

    await attachPaymentMethod(customerId, paymentMethod.id!);

    await http.post(
      Uri.parse('https://api.stripe.com/v1/customers/$customerId'),
      headers: {
        'Authorization': 'Bearer $chaveSecreta',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'invoice_settings[default_payment_method]': paymentMethod.id!,
      },
    );

    final price = await createPrice(amount);
    final priceId = price['id'];

    await createSubscription(customerId, priceId);
  }
  //parte do banco de dados onde envia ao usuario que ele tem um bool positivo para assinatura

  Future<void> enviarAssinaturaAtivaAoBancodeDados() async {
    final userid = await authSettings.currentUser!.uid;
    try {
      final postSignature =
          await database.collection('usuarios').doc(userid).update({
        'assinatura': true,
      });
    } catch (e) {
      print('ao enviar bool deu isto:$e');
    }
  }

  //enviar o valor da assinatura para o database da barbearia(manager ver)
  Future<void> enviandoValorMensalDeAssinaturaSParaGerenciador({
    required double valorAssinatura,
  }) async {
    try {
      final docRef =
          database.collection('estabelecimento').doc('totalAssinaturas');
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Atualiza o documento existente com incremento
        await docRef.update({
          'saqueDeMensalidades': FieldValue.increment(valorAssinatura),
        });
      } else {
        // Cria um novo documento com o valor inicial
        await docRef.set({
          'saqueDeMensalidades': valorAssinatura,
        });
      }
    } catch (e) {
      print('Erro ao enviar valor da assinatura para o database: $e');
    }
  }

  //enviando o valor de depositos para o gerenciador ver
  Future<void> enviandoValordeDepositosnoApp({
    required double valorAssinatura,
  }) async {
    try {
      final docRef =
          database.collection('estabelecimento').doc('saldoAdicionados');
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        // Atualiza o documento existente com incremento
        await docRef.update({
          'saldoAdicionados': FieldValue.increment(valorAssinatura),
        });
      } else {
        // Cria um novo documento com o valor inicial
        await docRef.set({
          'saldoAdicionados': valorAssinatura,
        });
      }
    } catch (e) {
      print('Erro ao enviar valor da assinatura para o database: $e');
    }
  }

  //fazendo o get dos saldos

  Future<double?> getTotalemMensalidades() async {
    print('#iu: abri a funcao');
    try {
      if (authSettings.currentUser != null) {
        double? valorAssinaturaUm;

        final docSnapshot = await database
            .collection("estabelecimento")
            .doc('assinaturaValor')
            .get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Verifica se 'saldoConta' existe e converte para double se necessário
          var valorAssinatura1DB = data['saqueDeMensalidades'];
          if (valorAssinatura1DB is int) {
            valorAssinaturaUm = valorAssinatura1DB.toDouble();
          } else if (valorAssinatura1DB is double) {
            valorAssinaturaUm = valorAssinatura1DB;
          } else {
            // Trate o caso onde saldoConta não é nem int nem double, se necessário
            print('#iu: saldoConta não é um número válido');
          }
        } else {
          print('#iu: Documento não encontrado');
        }

        print('#iu: valor final: ${valorAssinaturaUm}');
        return valorAssinaturaUm;
      }

      return null;
    } catch (e) {
      print('#iu: houve um erro: $e');
      return null; // Certifique-se de retornar null no caso de erro
    }
  }

  Future<void> cancelSubscription(
      {required String subscriptionId,
      required String userId,
      required double precoAssinatura}) async {
    try {
      final String endpoint =
          'https://api.stripe.com/v1/subscriptions/$subscriptionId';

      final response = await http.delete(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $chaveSecreta',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      if (response.statusCode == 200) {
        print('Subscription canceled successfully');
        try {
          final ajustOnProfile =
              await database.collection('usuarios').doc(userId).update({
            'assinatura': false,
            'assinaturaId': '',
          });
          final updateValorMensalidadesResgate = await database
              .collection('estabelecimento')
              .doc('totalAssinaturas')
              .update({
            'saqueDeMensalidades': FieldValue.increment(-precoAssinatura)
          });
        } catch (e) {
          print('pos cancelar na stripe, dentro do db deu isto: $e');
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        print(
            'Failed to cancel subscription: ${errorResponse['error']['message']}');
      }
    } catch (e) {
      throw e;
    }
  }
}
