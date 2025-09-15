import 'package:flutter/material.dart';

class CareerPreference extends StatefulWidget {
  const CareerPreference({ super.key });

  @override
  _CareerPreferenceState createState() => _CareerPreferenceState();
}

class _CareerPreferenceState extends State<CareerPreference> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Career Preferences",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            "This section will contain career preference details.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      )
    );
  }
}