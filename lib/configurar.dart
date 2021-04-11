import 'package:flutter/material.dart';
import 'package:mercado/utils/firebase.dart';
import 'components/loading.dart';
import 'package:mercado/model/produtos.dart';

class Configurar extends StatefulWidget {
  @override
  _ConfigurarState createState() => _ConfigurarState();
}

List _listaProdutos = [];
final String _collection = "produtos";

class _ConfigurarState extends State<Configurar> {
  Widget _conteudoPagina;

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
    carregarProdutos().then((resp) {
      _listaProdutos = resp;

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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xff056162),
            onPressed: () {
              _mensagemLimparListaCompras();
            },
            child: const Icon(
              Icons.remove_shopping_cart,
              color: Colors.white,
            ),
          ),
        );
      });
    });
  }

  _mensagemLimparListaCompras() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Limpar Lista?'),
            content: Text('Deseja limpar toda a lista de compras atual?'),
            actions: [
              FlatButton(
                  child: Text("Não"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    _limparListaCompras();
                  })
            ],
          );
        });
  }

  void _limparListaCompras() async {
    setState(() {
      _conteudoPagina = loading();
    });

    await Future.forEach(_listaProdutos, (item) {
      _atualizarListaItens(item);
    });

    setState(() {
      _carregarLista();
    });
  }

  _atualizarListaItens(i) {
    if (i.quantidade > 0) {
      ProdutoProperties _p = new ProdutoProperties();
      _p.produto = i.produto;
      _p.marca = i.marca;
      _p.quantidade = 0;
      _p.carrinho = false;
      _p.lista = false;

      _p.toJSON().then((json) => {atualizar(_collection, i.codigo, json)});
    }
  }

  Widget _criarListaProdutos(context, index) {
    return ListItem(
        index: index,
        codigo: _listaProdutos[index].codigo,
        produto: _listaProdutos[index].produto,
        marca: _listaProdutos[index].marca,
        quantidade: _listaProdutos[index].quantidade,
        carrinho: _listaProdutos[index].carrinho);
  }
}

class ListItem extends StatefulWidget {
  final int index;
  final String codigo;
  final String produto;
  final String marca;
  final int quantidade;
  final bool carrinho;

  const ListItem(
      {this.index,
      this.codigo,
      this.produto,
      this.marca,
      this.quantidade,
      this.carrinho});

  @override
  _ListItemState createState() =>
      _ListItemState(index, codigo, produto, marca, quantidade, carrinho);
}

class _ListItemState extends State<ListItem> {
  int _index;
  String _codigo;
  String _produto;
  String _marca;
  int _quantidade;
  bool _carrinho;

  _ListItemState(this._index, this._codigo, this._produto, this._marca,
      this._quantidade, this._carrinho);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Card(
            child: ListTile(
                leading: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      _quantidade.toString() + ' un.',
                      style: TextStyle(
                          color: Colors.amber[800],
                          fontWeight: FontWeight.bold),
                    )),
                title: Text(
                  _produto,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: _marca == "" ? null : Text("Marca: " + _marca),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          child: Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onTap: () {
                            _addQuantidade();
                          },
                        )),
                    GestureDetector(
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onTap: () {
                        if (_quantidade > 0) {
                          setState(() {
                            _removeQuantidade();
                          });
                        }
                      },
                    )
                  ],
                ))));
  }

  _addQuantidade() {
    setState(() {
      _quantidade++;
      _listaProdutos[_index].quantidade = _quantidade;
    });

    _atualizarQuantidade();
  }

  _removeQuantidade() {
    setState(() {
      _quantidade--;
      _listaProdutos[_index].quantidade = _quantidade;
    });

    _atualizarQuantidade();
  }

  _atualizarQuantidade() {
    ProdutoProperties _p = new ProdutoProperties();
    _p.produto = _produto;
    _p.marca = _marca;
    _p.quantidade = _quantidade;
    _p.carrinho = _carrinho;
    _p.lista = _quantidade > 0 ? true : false;

    _p.toJSON().then((json) => {atualizar(_collection, _codigo, json)});
  }
}
