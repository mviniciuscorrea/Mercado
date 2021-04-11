import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mercado/model/produtos.dart';
import 'package:mercado/utils/functions.dart';

Firestore _db = Firestore.instance;

Future<List<ProdutoProperties>> carregarProdutos() async {
  QuerySnapshot querySnapshot =
      await _db.collection("produtos").orderBy("produto").getDocuments();

  List<ProdutoProperties> _listaProdutos = [];

  for (var item in querySnapshot.documents) {
    ProdutoProperties _p = new ProdutoProperties();

    _p.codigo = item.documentID;
    _p.produto = item.data["produto"].toString().convertInitCap();
    _p.marca = item.data["marca"].toString().convertInitCap();
    _p.quantidade =
        ((item.data["quantidade"] == null) || (item.data["quantidade"] == ''))
            ? 0
            : item.data["quantidade"];
    _p.carrinho =
        ((item.data["carrinho"] == null) || (item.data["carrinho"] == ''))
            ? false
            : item.data["carrinho"];
    _p.lista = ((item.data["lista"] == null) || (item.data["lista"] == ''))
        ? false
        : item.data["lista"];
    _listaProdutos.add(_p);
  }

  return _listaProdutos;
}

Future<bool> novo(String collection, Map<String, dynamic> document) async {
  try {
    _db.collection(collection).add(document);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> atualizar(
    String collection, String codigo, Map<String, dynamic> document) async {
  try {
    _db.collection(collection)..document(codigo).setData(document);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> remover(String collection, String document) async {
  try {
    _db.collection(collection).document(document).delete();
    return true;
  } catch (e) {
    return false;
  }
}

Future<List<ProdutoProperties>> carregarProdutosListaCompras() async {
  List<ProdutoProperties> _listaProdutos = [];

  QuerySnapshot querySnapshot = await _db
      .collection("produtos")
      .where("lista", isEqualTo: true)
      .orderBy("produto")
      .getDocuments();

  for (var item in querySnapshot.documents) {
    ProdutoProperties _p = new ProdutoProperties();

    _p.codigo = item.documentID;
    _p.produto = item.data["produto"].toString().convertInitCap();
    _p.marca = item.data["marca"].toString().convertInitCap();
    _p.quantidade =
        ((item.data["quantidade"] == null) || (item.data["quantidade"] == ''))
            ? 0
            : item.data["quantidade"];
    _p.carrinho =
        ((item.data["carrinho"] == null) || (item.data["carrinho"] == ''))
            ? false
            : item.data["carrinho"];
    _p.lista = ((item.data["lista"] == null) || (item.data["lista"] == ''))
        ? false
        : item.data["lista"];
    _listaProdutos.add(_p);
  }

  return _listaProdutos;
}
