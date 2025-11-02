import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';

class Skill extends StatefulWidget {
  final List<SkillMV> dataSkills;
  const Skill({super.key, required this.dataSkills});

  @override
  _SkillState createState() => _SkillState(dataSkills);
}

class _SkillState extends State<Skill> {
  final List<SkillMV> dataSkills;

  _SkillState(this.dataSkills);

  @override
  Widget build(BuildContext context) {
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
              ElevatedButton.icon(
                onPressed: () {
                  context.go('/edit-skill', extra: dataSkills);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue, // Button color
                  foregroundColor: Colors.white, // Icon/text color
                ),
                icon: Icon(Icons.edit),
                label: Text("Edit"),
              ),
            ],
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List<Widget>.generate(dataSkills.length, (int index) {
              return SkillChip(
                title: dataSkills[index].skill.nama,
                source: dataSkills[index].source ?? "",
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String title;
  final String source;

  const SkillChip({required this.title, required this.source, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: source.contains('user') ? source.substring(4) : "General",
      textStyle: const TextStyle(color: Colors.white, fontSize: 12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(8),
      ),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 3),
      child: Chip(
        label: Text(title),
        backgroundColor: Colors.lightBlue.shade100,
      ),
    );
  }
}
