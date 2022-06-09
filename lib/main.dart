import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final text = lorem(words: 100, paragraphs: 100);

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(body: Center(child: TextField())),
    );
  }
}
