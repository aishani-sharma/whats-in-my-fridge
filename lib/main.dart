import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fridge to Recipe',
      home: Scaffold(
        appBar: AppBar(title: Text('Fridge to Recipe')),
        body: Center(child: Text('Hello!')),
      ),
    );
  }
}