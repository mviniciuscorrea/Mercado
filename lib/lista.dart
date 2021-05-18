import 'package:flutter/material.dart';
import 'package:mercado/components/loading.dart';
import 'package:mercado/utils/firebase.dart';
import 'package:mercado/model/produtos.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  Widget _conteudoPagina;
  List _listaProdutos = [];

  @override
  void initState() {
    super.initState();
    if (!mounted) return;

    _conteudoPagina = loading();
    _carregarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: _conteudoPagina,
    );
  }

  _carregarLista() {
    _listaProdutos = [];

    carregarProdutosListaCompras().then((resp) {
      _listaProdutos = resp;

      if (_listaProdutos.length == 0) {
        setState(() {
          _conteudoPagina = Scaffold(
              body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  '"Sem produtos na lista"',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                )
              ])
            ],
          ));
        });
      } else {
        setState(() {
          _conteudoPagina = Scaffold(
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemCount: _listaProdutos.length,
                  itemBuilder: _criarListaProdutos,
                ))
              ],
            ),
          );
        });
      }
    });
  }

  Widget _criarListaProdutos(context, index) {
    return ListItem(
      codigo: _listaProdutos[index].codigo,
      produto: _listaProdutos[index].produto,
      marca: _listaProdutos[index].marca,
      quantidade: _listaProdutos[index].quantidade,
      carrinho: _listaProdutos[index].carrinho,
      lista: _listaProdutos[index].lista,
    );
  }
}

class ListItem extends StatefulWidget {
  final String codigo;
  final String produto;
  final String marca;
  final int quantidade;
  final bool carrinho;
  final bool lista;

  const ListItem(
      {this.codigo,
      this.produto,
      this.marca,
      this.quantidade,
      this.carrinho,
      this.lista});

  @override
  _ListItemState createState() =>
      _ListItemState(codigo, produto, marca, quantidade, carrinho, lista);
}

class _ListItemState extends State<ListItem> {
  final String _collection = "produtos";

  String _codigo;
  String _produto;
  String _marca;
  int _quantidade;
  bool _carrinho;
  bool _lista;

  _ListItemState(this._codigo, this._produto, this._marca, this._quantidade,
      this._carrinho, this._lista);

  Widget _icon(carrinho) {
    return Icon(
      Icons.check_circle,
      color: carrinho ? Colors.amber[800] : Colors.transparent,
    );
  }

  @override
  void initState() {
    _icon(_carrinho);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Card(
          child: ListTile(
              onTap: () {
                setState(() {
                  ProdutoProperties _p = new ProdutoProperties();
                  _p.produto = _produto;
                  _p.marca = _marca;
                  _p.quantidade = _quantidade;
                  _p.carrinho = _carrinho ? false : true;
                  _p.lista = _lista;

                  _p.toJSON().then((json) => {
                        atualizar(_collection, _codigo, json).then((resp) => {
                              if (resp) {_carrinho = _carrinho ? false : true}
                            })
                      });
                });
              },
              leading: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    _quantidade.toString() + ' un.',
                    style: TextStyle(
                        color: Colors.amber[800], fontWeight: FontWeight.bold),
                  )),
              title: Text(
                _produto,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: _marca == "" ? null : Text("Marca: " + _marca),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                GestureDetector(
                  child: _icon(_carrinho),
                )
              ]))),
    );
  }
}
