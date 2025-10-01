import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  ErrorPage({super.key});

  @override
  State<ErrorPage> createState() => _ErrorPage();
}

class _ErrorPage extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: Center());
  }
}
