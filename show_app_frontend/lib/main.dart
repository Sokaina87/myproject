import 'package:flutter/material.dart';
import 'package:show_app_frontend/screens/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @overrider
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}