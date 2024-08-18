import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserLoginApp with ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> deslogar() async {
    firebaseAuth.signOut();
  }

  Future<void> fazerLogin(String email, String password) async {
    print("#login1 entrei no provider do login");
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      print("#login1 : $e");
      throw e;
    }
  }

  //funcoes de recuperar a senha
  Future<void> resetPassword({required String emailController}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: emailController);
      print("tudo certo com o envio de e-mail");
    } catch (e) {
      print("ao recuperar a senha houve este erro: $e");
      throw e;
    }
  }
}
