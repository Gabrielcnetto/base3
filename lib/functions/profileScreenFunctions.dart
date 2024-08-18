import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class MyProfileScreenFunctions with ChangeNotifier {
  final authSettings = FirebaseAuth.instance;
  final storageSettings = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;

  //alterando imagem do perfil - inicio
  Future<void> setImageProfile({required File urlImage}) async {
    String userIdCreate = authSettings.currentUser!.uid;

    //INICIO => Enviando a foto
    Reference ref =
        storageSettings.ref().child("userProfilePhotos/${userIdCreate}");
    UploadTask uploadTask = ref.putFile(urlImage);
    await uploadTask.whenComplete(() => null);
    String imageProfileImage = await ref.getDownloadURL();

    db.collection("usuarios").doc(userIdCreate).update({
      "urlImagem": imageProfileImage,
    });
  }
  //alterando imagem do perfil - fim

  //INICIO GET DO NOME
  Future<String?> getUserName() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['userName'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  //FIM GET DO NOME
  //get do phone

  //get do phone
  Future<String?> getPhone() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? PhoneNumber;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          PhoneNumber = data['PhoneNumber'];
        } else {}
        return PhoneNumber;
      });
      return PhoneNumber;
    }

    return null;
  }

  //get da imagem do perfil
  Future<bool?> getUserIsManager() async {
    if (authSettings.currentUser == null) {
      return null; // Retorna imediatamente se o usuário não estiver autenticado
    }

    final String uidUser = authSettings.currentUser!.uid;
    bool? isManager;

    await db.collection("usuarios").doc(uidUser).get().then((event) {
      if (event.exists) {
        Map<String, dynamic>? data = event.data(); // Use Map<String, dynamic>?

        if (data != null && data.containsKey('isManager')) {
          isManager = data['isManager'];
        }
      }
    });

    return isManager; // Retorna o valor de isManager, que pode ser null
  }

  //GET SE É FUNCIONARIO - INICIO
  Future<bool?> getUserIsFuncionario() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      bool? ismManager;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          ismManager = data['isfuncionario'];
        } else {}
        return ismManager;
      });
      return ismManager;
    }

    return null;
  }

  //GET SE É FUNCIONARIO - FIM
  //attnome
  Future<void> newName({required String newName}) async {
    db.collection("usuarios").doc(authSettings.currentUser!.uid).update({
      "userName": newName,
    });
  }

  Future<void> setPhone({required String phoneNumber}) async {
    String cleanedNumber =
        await phoneNumber.replaceAll(RegExp(r'^\+?55|\- '), '');
    db.collection("usuarios").doc(authSettings.currentUser!.uid).update({
      "PhoneNumber": '55${cleanedNumber}',
    });
  }

  //Pegando o bool do isManager - INICIO
  Future<String?> getUserImage() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? urlImagem;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          urlImagem = data['urlImagem'];
        } else {}
        return urlImagem;
      });
      return urlImagem;
    }

    return null;
  }

  //INICIO GET Da pontuacao
  Future<int?> getUserPontuation() async {
    print("carregando a pontuacao");
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      int? pontos;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          pontos = data['easepoints'] ?? 0;
        } else {}
        print("o valor deste user pego é${pontos}");
        return pontos;
      });
      return pontos;
    }

    return null;
  }

  //get email
  //INICIO GET DO NOME
  Future<String?> getUserEmail() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      String? userName;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          userName = data['userEmail'];
        } else {}
        return userName;
      });
      return userName;
    }

    return null;
  }

  Future<void> updateCreditosPerfil({required double saldoAdicionar}) async {
    final String userId = await authSettings.currentUser!.uid;
    try {
      final upCreditOnProfile =
          await db.collection('usuarios').doc(userId).update(
        {
          'saldoConta': FieldValue.increment(saldoAdicionar),
        },
      );
    } catch (e) {
      print("ao upar o credito no perfil deu erro: $e");
    }
  }

  Future<double?> getUserSaldo() async {
    print('#iu: abri a funcao');
    final String uidUser = await authSettings.currentUser!.uid;

    try {
      if (authSettings.currentUser != null) {
        double? userSaldo;

        final docSnapshot = await db.collection("usuarios").doc(uidUser).get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Verifica se 'saldoConta' existe e converte para double se necessário
          var saldo = data['saldoConta'];
          if (saldo is int) {
            userSaldo = saldo.toDouble();
          } else if (saldo is double) {
            userSaldo = saldo;
          } else {
            // Trate o caso onde saldoConta não é nem int nem double, se necessário
            print('#iu: saldoConta não é um número válido');
          }
        } else {
          print('#iu: Documento não encontrado');
        }

        print('#iu: valor final: ${userSaldo}');
        return userSaldo;
      }

      return null;
    } catch (e) {
      print('#iu: houve um erro: $e');
      return null; // Certifique-se de retornar null no caso de erro
    }
  }

  Future<double?> getValorAssinatura1() async {
    print('#iu: abri a funcao');
    try {
      if (authSettings.currentUser != null) {
        double? valorAssinaturaUm;

        final docSnapshot =
            await db.collection("estabelecimento").doc('assinaturaValor').get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Verifica se 'saldoConta' existe e converte para double se necessário
          var valorAssinatura1DB = data['precoAssinatura1'];
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

  //GET DO VALOR POSSIVEL DE SAQUE

  Future<double?> valorpossiveldesaque() async {
    print('#iu: abri a funcao');
    try {
      if (authSettings.currentUser != null) {
        double? valorAssinaturaUm;

        final docSnapshot =
            await db.collection("estabelecimento").doc('saldoAdicionados').get();
        if (docSnapshot.exists) {
          Map<String, dynamic> data =
              docSnapshot.data() as Map<String, dynamic>;

          // Verifica se 'saldoConta' existe e converte para double se necessário
          var valorAssinatura1DB = data['saldoAdicionados'];
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

  //get se o usuario é premium
  Future<bool?> getPremiumOrNot() async {
    if (authSettings.currentUser != null) {
      final String uidUser = await authSettings.currentUser!.uid;
      bool? premiumounao;

      await db.collection("usuarios").doc(uidUser).get().then((event) {
        if (event.exists) {
          Map<String, dynamic> data = event.data() as Map<String, dynamic>;

          premiumounao = data['assinatura'] ?? false;
        } else {}
        return premiumounao;
      });
      return premiumounao;
    }

    return null;
  }

  //get valor que o manager recebe em assinaturas:
    Future<double?> gettTotalemAssinaturasParaSaque() async {
    print('#iu: abri a funcao');
    try {
      if (authSettings.currentUser != null) {
        double? valorAssinaturaUm;

        final docSnapshot =
            await db.collection("estabelecimento").doc('totalAssinaturas').get();
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
}
