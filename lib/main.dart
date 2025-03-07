import 'package:animations/finances/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Animations());
}

class Animations extends StatelessWidget {
  const Animations({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
