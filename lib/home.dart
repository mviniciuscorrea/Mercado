import 'package:flutter/material.dart';
import 'package:mercado/configurar.dart';
import 'package:mercado/lista.dart';
import 'package:mercado/produtos.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  String _tituloPagina = "Lista de Compras";
  TabController _tabController;

  final _corSelecionado = Colors.amber[800];
  final _corSemSelecionado = Colors.grey;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        setState(() {
          _tituloPagina = "Lista de Compras";
        });
      } else if (_tabController.index == 1) {
        setState(() {
          _tituloPagina = "Cadastro de Produto";
        });
      } else {
        setState(() {
          _tituloPagina = "Configurar Lista";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloPagina,
          style: TextStyle(fontSize: 16, color: Colors.amber[800]),
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.amber[800],
            tabs: [
              Tab(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: _tabController.index == 0
                      ? _corSelecionado
                      : _corSemSelecionado,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.fastfood_outlined,
                  color: _tabController.index == 1
                      ? _corSelecionado
                      : _corSemSelecionado,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.post_add_rounded,
                  color: _tabController.index == 2
                      ? _corSelecionado
                      : _corSemSelecionado,
                ),
              )
            ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [Lista(), Produtos(), Configurar()]),
    );
  }
}
