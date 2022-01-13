import 'package:flutter/material.dart';
import 'package:mercado/components/loading.dart';
import 'package:mercado/utils/firebase.dart';
import 'package:mercado/model/produtos.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Widget> _listaProdutos = [];
  bool _loading = false;

  static String _collection = "produtos";

  @override
  void initState() {
    super.initState();
    _carregarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [loading()])
              ])
            : _listaProdutos.length == 0
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '"Sem produtos na lista"',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[400],
                            ),
                          )
                        ]),
                  ])
                : SingleChildScrollView(
                    child: Column(children: _listaProdutos)));
  }

  void _carregarLista() {
    _loading = true;
    _listaProdutos.clear();

    carregarProdutosListaCompras().then((resp) {
      setState(() {
        _loading = false;
        bool _addCarrinho = false;

        for (var i = 0; i < resp.length; i++) {
          if (i == 0) {
            _listaProdutos.add(SizedBox(
              height: 5,
            ));
          }

          _addCarrinho = resp[i].carrinho;

          _listaProdutos.add(Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Card(
                child: ListTile(
                  leading: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      resp[i].quantidade.toString() + ' un.',
                      style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(resp[i].produto,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: resp[i].marca.isEmpty
                      ? null
                      : Text("Marca: " + resp[i].marca),
                  trailing: Icon(
                    Icons.check_circle,
                    color: _addCarrinho ? Colors.green : Colors.transparent,
                  ),
                  onTap: () {
                    ProdutoProperties _p = new ProdutoProperties();
                    _p.produto = resp[i].produto;
                    _p.marca = resp[i].marca;
                    _p.quantidade = resp[i].quantidade;
                    _p.carrinho = !resp[i].carrinho;
                    _p.lista = resp[i].lista;

                    _p.toJSON().then((json) => {
                          atualizar(_collection, resp[i].codigo, json)
                              .then((resp) {
                            if (resp) {
                              _carregarLista();
                            }
                          })
                        });
                  },
                ),
              )));
        }
      });
    });
  }
}
