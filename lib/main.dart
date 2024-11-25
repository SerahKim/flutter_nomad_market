import 'package:flutter/material.dart';
import 'package:flutter_nomad_market/Pages/Login/loginPage.dart'; //불러오기 위한 루트

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Loginpage(), //내가 확인하고 싶은 class명
    );
  }
}
//