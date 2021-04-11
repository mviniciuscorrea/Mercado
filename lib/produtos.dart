import 'package:flutter/material.dart';
import 'package:mercado/components/loading.dart';
import 'package:mercado/utils/firebase.dart';
import 'package:mercado/model/produtos.dart';

class Produtos extends StatefulWidget {
  @override
  _ProdutosState createState() => _ProdutosState();
}

class _ProdutosState extends State<Produtos> with TickerProviderStateMixin {
  TextEditingController _controllerProduto = TextEditingController();
  TextEditingController _controllerMarca = TextEditingController();

  String _collection = "produtos";
  String _codigoProduto = "";

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

  _showDialogAlert(context, String titulo, String mensagem) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            FlatButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        );
      },
    );
  }

  _showDialogInput(context, produto) {
    if (produto != null) {
      _controllerProduto.text = produto.produto;
      _controllerMarca.text = produto.marca;
      _codigoProduto = produto.codigo;
    }

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Produto'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _controllerProduto,
                  decoration: InputDecoration(labelText: "Qual o produto?"),
                  onChanged: (text) {},
                ),
                TextField(
                  controller: _controllerMarca,
                  decoration:
                      InputDecoration(labelText: "Marca de preferência?"),
                  onChanged: (text) {},
                )
              ],
            ),
            actions: [
              FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                    _controllerProduto.text = '';
                    _controllerMarca.text = '';
                  }),
              FlatButton(
                  child: Text("Salvar"),
                  onPressed: () {
                    _incluirAtualizar(produto);
                  })
            ],
          );
        });
  }

  Widget _criarListaProdutos(context, index) {
    return Dismissible(
      key: Key(_listaProdutos[index].codigo),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        remover(_collection, _listaProdutos[index].codigo).then((resp) {
          if (resp) {
            _listaProdutos.removeAt(index);
          } else {
            // msg de erro na exclusão
          }
        });
      },
      child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Card(
              child: ListTile(
            title: Text(
              _listaProdutos[index].produto,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: _listaProdutos[index].marca == ""
                ? null
                : Text("Marca: " + _listaProdutos[index].marca),
            trailing: GestureDetector(
              child: Icon(
                Icons.edit,
                color: Colors.grey[400],
              ),
              onTap: () {
                _showDialogInput(context, _listaProdutos[index]);
              },
            ),
          ))),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.white),
            Padding(padding: EdgeInsets.fromLTRB(7, 0, 0, 0)),
            Text(
              "Deletar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  _carregarLista() {
    carregarProdutos().then((resp) {
      _listaProdutos = resp;

      if (!mounted) return;

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
              _showDialogInput(context, null);
            },
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      });
    });
  }

  _incluirAtualizar(produto) {
    if (_controllerProduto.text.isEmpty) {
      Navigator.pop(context);
      return _showDialogAlert(
          context, "Produto não cadastrado", "Informe o nome do produto!");
    }

    ProdutoProperties _p = new ProdutoProperties();
    _p.produto = _controllerProduto.text;
    _p.marca = _controllerMarca.text;

    if (produto == null) {
      _p.quantidade = 0;
      _p.carrinho = false;
      _p.lista = false;
    } else {
      _p.quantidade = produto.quantidade;
      _p.carrinho = produto.carrinho;
      _p.lista = produto.lista;
    }

    _p.toJSON().then((json) {
      if (_codigoProduto == '') {
        novo(_collection, json).then((resp) {
          if (resp) {
            if (!mounted) return;

            setState(() {
              _carregarLista();
            });

            _showDialogAlert(
                context, "Sucesso", "Produto cadastrado com sucesso!");
          } else {
            //mensagem de erro
          }
        });
      } else {
        atualizar(_collection, _codigoProduto, json).then((resp) {
          _codigoProduto = '';

          if (resp) {
            if (!mounted) return;

            setState(() {
              _carregarLista();
            });

            _showDialogAlert(
                context, "Sucesso", "Produto atualizado com sucesso!");
          } else {
            //mensagem de erro
          }
        });
      }
    });

    Navigator.pop(context);
    _controllerProduto.text = '';
    _controllerMarca.text = '';
  }
}
