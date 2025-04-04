import 'package:flutter/material.dart';
import 'package:show_app_frontend/screens/login_page.dart';

void main() {
  runApp(const ShowApp());
}

class ShowApp extends StatelessWidget {
  const ShowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Show App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}
