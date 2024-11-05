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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        produtos[index].descricao,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Estoque: ${produtos[index].estoque} - Preço: ${produtos[index].preco}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
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
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Divider(),
                ),
              ],
            );
          },
        ),
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }
}
