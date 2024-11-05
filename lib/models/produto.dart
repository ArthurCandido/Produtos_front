class Produto {
  final int id;
  final String descricao;
  final int estoque;
  final double preco;
  final DateTime data;

  Produto(
      {required this.id,
      required this.descricao,
      required this.estoque,
      required this.preco,
      required this.data});

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      descricao: json['descricao'],
      estoque: json['estoque'],
      preco: double.parse(json['preco']),
      data: DateTime.parse(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descricao': descricao,
      'estoque': estoque,
      'preco': preco,
      'data': data.toIso8601String(),
    };
  }
}
