import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: MyApp())));
}

class MyApp extends StatelessWidget {
  final text = lorem(paragraphs: 5, words: 500);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: TextField());
  }
}
