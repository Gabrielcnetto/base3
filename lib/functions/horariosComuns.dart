// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HorariosComuns with ChangeNotifier {
  final database = FirebaseFirestore.instance;

  Future<void> postHours({required String horarioEscolhido}) async {
    final docRef = database.collection("ComumPosts").doc(horarioEscolhido);

    // Verifica se o documento existe
    final docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      // Se existir, atualiza o documento
      await docRef.update({
        "totaldeMarcacoes": FieldValue.increment(1), // Incrementa o contador
      });
    } else {
      // Se não existir, cria um novo documento
      await docRef.set({
        "totaldeMarcacoes": 1,
      });
    }

    notifyListeners();
  }

  
}
