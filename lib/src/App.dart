import 'package:_pecpocket/src/pages/login_page.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        body: Login(),
      ),
    );
  }
}
