import 'package:mercado/utils/functions.dart';

class ProdutoProperties {
  String codigo;
  String produto;
  String marca;
  int quantidade;
  bool carrinho;
  bool lista;

  Future<Map<String, dynamic>> toJSON() async {
    Map<String, dynamic> document = {
      "produto": this.produto.convertInitCap(),
      "marca": this.marca.convertInitCap(),
      "quantidade": this.quantidade,
      "carrinho": this.carrinho,
      "lista": this.lista
    };

    return document;
  }
}
