import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';

class TopApplayout extends StatefulWidget implements PreferredSizeWidget {
  const TopApplayout({super.key});

  @override
  State<TopApplayout> createState() => _TopAppLayout();
  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _TopAppLayout extends State<TopApplayout> {
  void _LogOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Yuk Kerja"),
        ElevatedButton(onPressed: _LogOut, child: Text("Log Out")),
      ],
    );
  }
}
