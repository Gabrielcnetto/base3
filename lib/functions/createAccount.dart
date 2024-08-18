// ignore_for_file: file_names, non_constant_identifier_names, await_only_futures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount with ChangeNotifier {
  final authSettings = FirebaseAuth.instance;
  final dataBaseFirestore = FirebaseFirestore.instance;

  //

  //

  Future<void> CreateAccountProvider({
    required String email,
    required String password,
    required String userName,
  }) async {
    await authSettings.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    String userIdCreate = await authSettings.currentUser!.uid;
    await dataBaseFirestore.collection("usuarios").doc(userIdCreate).set({
      'userName': userName,
      'userEmail': email,
      'PhoneNumber': "",
      "urlImagem":
          "https://firebasestorage.googleapis.com/v0/b/lionsbarber-easecorte.appspot.com/o/profileDefaultImage%2FdefaultUserImage.png?alt=media&token=5d61e887-4f54-4bca-be86-a34e43b1cb92",
      "totalCortes": 0,
      "isManager": false,
      "isfuncionario": false,
      "nameFuncionario": "",
      "easepoints": 0,
      'assinatura': false,
      'saldoConta': 0,
      'assinaturaId': '',
      'userIdDatabase': userIdCreate,
    });
    notifyListeners();
  }
}
