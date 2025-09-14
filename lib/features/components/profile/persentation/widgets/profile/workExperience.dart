import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Workexperience extends StatefulWidget {
  @override
  State<Workexperience> createState() => _Workexperience();
}

class _Workexperience extends State<Workexperience> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "Work Experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Column(),
        ],
      ),
    );
  }
}
