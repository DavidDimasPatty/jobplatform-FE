import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _Setting();
}

class _Setting extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LoginForm()),
    );
  }
}
