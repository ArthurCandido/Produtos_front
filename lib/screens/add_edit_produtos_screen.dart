import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
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
  late MoneyMaskedTextController precoController;
  late TextEditingController dataController;

  @override
  void initState() {
    super.initState();
    descricaoController =
        TextEditingController(text: widget.produto?.descricao ?? '');
    estoqueController =
        TextEditingController(text: widget.produto?.estoque.toString());
    precoController = MoneyMaskedTextController(
      initialValue: widget.produto?.preco ?? 0.0,
      leftSymbol: 'R\$ ',
      decimalSeparator: ',',
      thousandSeparator: '.',
    );
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: descricaoController,
                                decoration: const InputDecoration(
                                  labelText: 'Descrição',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.description),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira a descrição';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: estoqueController,
                                decoration: const InputDecoration(
                                  labelText: 'Estoque',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.storage),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o estoque';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: precoController,
                                decoration: const InputDecoration(
                                  labelText: 'Preço',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.attach_money),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Por favor, insira o preço';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: dataController,
                                decoration: InputDecoration(
                                  labelText: 'Data',
                                  border: const OutlineInputBorder(),
                                  prefixIcon: const Icon(Icons.calendar_today),
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Produto produto = Produto(
                      id: widget.produto?.id ?? 0,
                      descricao: descricaoController.text,
                      estoque: int.parse(estoqueController.text),
                      preco: precoController.numberValue,
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
            ),
          ],
        ),
      ),
    );
  }
}
