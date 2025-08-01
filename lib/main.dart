import 'package:flutter/material.dart';
import 'package:tempo/screens/registration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avatech Commerce',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const Registration(),
    );
  }
}
