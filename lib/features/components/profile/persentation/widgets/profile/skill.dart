import 'package:flutter/material.dart';

class Skill extends StatefulWidget {
  const Skill({super.key});

  @override
  _SkillState createState() => _SkillState();
}

class _SkillState extends State<Skill> {
  void _addSkill() {
    // Logic to add a new skill
    print("Add Skill button pressed");
  }

  void _viewSkillDetails(String title) {
    // Logic to view skill details
    print("View details for Skill $title");
  }

  final Map<String, String> skillDescriptions = {
    "Skill 1": "Description for Skill 1",
    "Skill 2": "Description for Skill 2",
    "Skill 3": "Description for Skill 3",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 700,
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Skills",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _addSkill,
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Icon/text color
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                icon: Icon(Icons.add),
                label: Text("Add"),
              ),
            ],
          ),
          SizedBox(height: 20),
          for (var entry in skillDescriptions.entries) ...[
            SkillCard(
              title: entry.key,
              description: entry.value,
              onPressed: () => _viewSkillDetails(entry.key),
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

class SkillCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const SkillCard({
    required this.title,
    required this.description,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
