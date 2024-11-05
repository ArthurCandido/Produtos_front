import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../services/api_service.dart';

class AddEditProdutoScreen extends StatefulWidget {
  final Produto? produto;

  const AddEditProdutoScreen({super.key, this.produto});

  @override
  _AddEditProdutoScreenState createState() => _AddEditProdutoScreenState();
}

class _AddEditProdutoScreenState extends State<AddEditProdutoScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late TextEditingController descricaoController;
  late TextEditingController estoqueController;
  late TextEditingController precoController;
  late TextEditingController dataController;

  @override
  void initState() {
    super.initState();
    descricaoController =
        TextEditingController(text: widget.produto?.descricao ?? '');
    estoqueController =
        TextEditingController(text: widget.produto?.estoque.toString());
    precoController =
        TextEditingController(text: widget.produto?.preco.toString());
    dataController = TextEditingController(
        text: widget.produto?.data.toIso8601String().split('T').first);
  }

  @override
  void dispose() {
    descricaoController.dispose();
    estoqueController.dispose();
    precoController.dispose();
    dataController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dataController.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.produto == null ? 'Adicionar Produto' : 'Editar Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: estoqueController,
                decoration: const InputDecoration(labelText: 'Estoque'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o estoque';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: precoController,
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dataController,
                decoration: InputDecoration(
                  labelText: 'Data',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira a data';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Produto produto = Produto(
                      id: widget.produto?.id ?? 0,
                      descricao: descricaoController.text,
                      estoque: int.parse(estoqueController.text),
                      preco: double.parse(precoController.value.text),
                      data: DateTime.parse(dataController.text),
                    );

                    if (widget.produto == null) {
                      await apiService.createProduto(produto);
                    } else {
                      await apiService.updateProduto(
                          widget.produto!.id, produto);
                    }

                    Navigator.pop(context, true);
                  }
                },
                child: Text(widget.produto == null ? 'Adicionar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
