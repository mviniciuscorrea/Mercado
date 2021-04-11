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
  void dispose() {
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tituloPagina,
          style: TextStyle(fontSize: 16),
        ),
        bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.shopping_cart_outlined),
              ),
              Tab(
                icon: Icon(Icons.fastfood_outlined),
              ),
              Tab(
                icon: Icon(Icons.post_add_rounded),
              )
            ]),
      ),
      body: TabBarView(
          controller: _tabController,
          children: [Lista(), Produtos(), Configurar()]),
    );
  }
}
