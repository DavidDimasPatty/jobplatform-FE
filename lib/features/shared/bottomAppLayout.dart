import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';

class BottomApplayout extends StatefulWidget implements PreferredSizeWidget {
  const BottomApplayout({super.key});

  @override
  State<BottomApplayout> createState() => _BottomApplayout();
  @override
  Size get preferredSize => Size.fromHeight(60);
}

class _BottomApplayout extends State<BottomApplayout> {
  void _LogOut() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.shopping_bag, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
