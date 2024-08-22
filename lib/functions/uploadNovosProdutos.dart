import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easebase/classes/produtosAVenda.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadnovosprodutosBarbeiro with ChangeNotifier {
  //bibliotecas DB
  final database = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;

  Future<void> setNewProduct({
    required File urlImage,
    required Produtosavenda produtoVenda,
  }) async {
    print("entrei na funcao de enviar o produto ao db");
    //INICIO => Enviando a foto
    try {
      print("entrei no try");
      Reference ref = storage
          .ref()
          .child("ProdutosBarbeiroImagens/${produtoVenda.id.toLowerCase()}");
      UploadTask uploadTask = ref.putFile(urlImage);
      await uploadTask.whenComplete(() => null);
      String imageProfileImage = await ref.getDownloadURL();
      print("postei a foto:${imageProfileImage}");
      //FIM => enviando a foto

      //Enviando o Produto ao DATABASE
      await database.collection("MeusProdutos").doc(produtoVenda.id).set({
        "categorias": produtoVenda.categorias,
        "ativoParaExibir": true,
        'descricao': produtoVenda.descricao,
        'estoque': produtoVenda.estoque,
        'id': produtoVenda.id,
        'nome': produtoVenda.nome,
        'preco': produtoVenda.preco,
        'quantiavendida': 0,
        'urlImage': imageProfileImage,
        'precoAntigo': 0,
      });
    } catch (e) {
      print("ocorreu um erro: $e");
      throw e;
    }
    notifyListeners();
  }

  final StreamController<List<Produtosavenda>> _produtosAvendaStream =
      StreamController<List<Produtosavenda>>.broadcast();

  Stream<List<Produtosavenda>> get ProdutosAvendaStream =>
      _produtosAvendaStream.stream;
  List<Produtosavenda> _produtosAvenda = [];
  List<Produtosavenda> get produtosAvenda => [..._produtosAvenda];
  Future<void> LoadProductsBarbearia() async {
    print("entrei no load");
    try {
      print("entrei no try");
      QuerySnapshot querySnapshot =
          await database.collection('MeusProdutos').get();
      _produtosAvenda = querySnapshot.docs.map((doc) {
        print("entrei no map do doc");
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
        print("${data!.isEmpty ? "empy" : "tem item"}");
              List<String> categorias = List<String>.from(data?['categorias'] ?? []);
      
        // Acessando os atributos diretamente usando []
        return Produtosavenda(
          categorias: categorias,
          ativoParaExibir: data?["ativoParaExibir"] ?? true,
          descricao: data?["descricao"] ?? "",
          estoque: data?["estoque"] ?? 0,
          id: data?["id"] ?? "",
          nome: data?["nome"] ?? "",
          preco: (data?["preco"] as num?)?.toDouble() ?? 0.0,
          quantiavendida: data?["quantiavendida"] ?? 0,
          urlImage: data?["urlImage"] ?? "",
          precoAntigo: (data?["precoAntigo"] as num?)?.toDouble() ?? 0.0,
      
        );
      }).toList();
      _produtosAvendaStream.add(_produtosAvenda);
      print("o lengh da lista de produto é ${_produtosAvenda.length}");
      // Ordenar os dados pela data
     // _produtosAvenda.sort((a, b) {
     //   return a.estoque.compareTo(b.estoque);
     // });
    } catch (e) {
      print("houve um erro:$e");    }
  }
}
