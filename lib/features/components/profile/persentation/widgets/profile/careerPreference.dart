import 'package:flutter/material.dart';

class CareerPreference extends StatefulWidget {
  const CareerPreference({super.key});

  @override
  _CareerPreferenceState createState() => _CareerPreferenceState();
}

class _CareerPreferenceState extends State<CareerPreference> {
  final Map<String, String> careerDescriptions = {
    "Preferred Job Title": "Software Engineer",
    "Location": "Remote",
    "Salary Expectation": "\$100,000 - \$120,000",
    "Job Type": "Full-time",
    "Industry": "Technology",
    "Work Environment": List<String>.from(["Remote", "Hybrid"]).join(", "),
    "Availability": "Immediate",
    "Willingness to Relocate": "Yes",
    "Career Level": "Mid-level",
    "Preferred Company Size": "50-200 employees",
  };

  // Map to store icon preferences for each career preference key
  final Map<String, IconData> careerIcons = {
    "Preferred Job Title": Icons.work,
    "Location": Icons.location_on,
    "Salary Expectation": Icons.attach_money,
    "Job Type": Icons.access_time,
    "Industry": Icons.business,
    "Work Environment": Icons.home_work,
    "Availability": Icons.event_available,
    "Willingness to Relocate": Icons.flight_takeoff,
    "Career Level": Icons.trending_up,
    "Preferred Company Size": Icons.people,
  };

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
          for (var entry in careerDescriptions.entries) ...[
            CareerPreferenceCard(
              icon: careerIcons[entry.key] ?? Icons.work,
              title: entry.key,
              description: entry.value,
            ),
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 20,
              indent: 0,
              endIndent: 0,
            ),
          ],
        ],
      ),
    );
  }
}

class CareerPreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  // final VoidCallback onPressed;

  const CareerPreferenceCard({
    required this.icon,
    required this.title,
    required this.description,
    // required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: Colors.blueAccent),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
