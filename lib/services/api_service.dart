import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';

class ApiService {
  final String apiUrl = 'http://localhost:3000/produtos';

  Future<List<Produto>> fetchProdutos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((produto) => Produto.fromJson(produto)).toList();
    } else {
      throw Exception('Failed to load produtos');
    }
  }

  Future<Produto> createProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 201) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create produto');
    }
  }

  Future<Produto> updateProduto(int id, Produto produto) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(produto.toJson()),
    );

    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update produto');
    }
  }

  Future<void> deleteProduto(int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete produto');
    }
  }
}
