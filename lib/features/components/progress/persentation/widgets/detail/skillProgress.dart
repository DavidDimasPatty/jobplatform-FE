import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';

class SkillProgress extends StatefulWidget {
  final List<SkillMV> dataSkills;
  const SkillProgress({super.key, required this.dataSkills});

  @override
  _SkillStateProgress createState() => _SkillStateProgress(dataSkills);
}

class _SkillStateProgress extends State<SkillProgress> {
  final List<SkillMV> dataSkills;

  _SkillStateProgress(this.dataSkills);

  void _addSkill() {
    // Logic to add a new skill
    print("Add Skill button pressed");
  }

  void _viewSkillDetails(String title) {
    // Logic to view skill details
    print("View details for Skill $title");
  }

  @override
  Widget build(BuildContext context) {
    int idx = 1;

    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Skills",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
              // ElevatedButton.icon(
              //   onPressed: _addSkill,
              //   style: ElevatedButton.styleFrom(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     backgroundColor: Colors.blue, // Button color
              //     foregroundColor: Colors.white, // Icon/text color
              //   ),
              //   icon: Icon(Icons.add),
              //   label: Text("Add"),
              // ),
            ],
          ),
          SizedBox(height: 20),
          for (var entry in dataSkills) ...[
            SkillCard(
              idx: idx++,
              title: entry.skill.nama,
              onPressed: () => _viewSkillDetails(entry.skill.nama),
            ),
            SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final int idx;
  final String title;
  final VoidCallback onPressed;

  const SkillCard({
    required this.idx,
    required this.title,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      //onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Center(
                child: Text(
                  idx.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'test',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
