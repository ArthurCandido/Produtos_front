import 'package:flutter/material.dart';
import 'screens/produtos_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD produtos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ProdutosScreen(),
    );
  }
}
