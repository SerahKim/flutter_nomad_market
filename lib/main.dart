import 'package:flutter/material.dart';
import 'Pages/Login/loginPage.dart';

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
