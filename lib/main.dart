import 'package:flutter/material.dart';
import 'Pages/Login/loginPage.dart';
import 'Pages/Home/homePage.dart';
import 'Pages/Description/descriptionPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/description': (context) => DescriptionPage(
              productData: ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>,
            ),
      },
      home: LoginPage(),
    );
  }
}
