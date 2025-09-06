import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: LoginForm()),
    );
  }
}
