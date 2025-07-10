import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Center(child: LoginForm()),
    );
  }
}
