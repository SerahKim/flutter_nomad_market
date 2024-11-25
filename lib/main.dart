import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Login/loginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(), // LoginPage로 시작
    );
  }
}
//