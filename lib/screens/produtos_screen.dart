import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';
import 'add_edit_produtos_screen.dart';

class ProdutosScreen extends StatefulWidget {
  const ProdutosScreen({super.key});

  @override
  _ProdutosScreenState createState() => _ProdutosScreenState();
}

class _ProdutosScreenState extends State<ProdutosScreen> {
  final ApiService apiService = ApiService();
  List<Produto> produtos = [];

  @override
  void initState() {
    super.initState();
    fetchProdutos();
  }

  fetchProdutos() async {
    try {
      final fetchedProdutos = await apiService.fetchProdutos();
      setState(() {
        produtos = fetchedProdutos;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Produtos'),
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produtos[index].descricao),
            subtitle: Text(
                'Estoque: ${produtos[index].estoque} - Preço: ${produtos[index].preco}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await apiService.deleteProduto(produtos[index].id);
                fetchProdutos();
              },
            ),
            onTap: () async {
              bool result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditProdutoScreen(produto: produtos[index]),
                ),
              );
              if (result) {
                fetchProdutos();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddEditProdutoScreen(),
            ),
          );
          if (result) {
            fetchProdutos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
