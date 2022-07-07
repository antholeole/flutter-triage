import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(body: Center(child: TextField(
    minLines: 3,
    maxLines: 3,
  )))));
}
