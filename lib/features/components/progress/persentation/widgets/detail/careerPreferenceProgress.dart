import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/progress/data/models/preferenceProgressModel.dart';

class CareerPreferenceProgress extends StatelessWidget {
  final List<PreferenceProgressModel>? dataPreferences;

  CareerPreferenceProgress({super.key, required this.dataPreferences});

  // Sample data for career preferences
  Map<String, String> get careerDescriptions => {
    "Salary Expectation": dataPreferences!.isNotEmpty
        ? "${NumberFormat('#,###').format(dataPreferences![0].gajiMin)} - ${NumberFormat('#,###').format(dataPreferences![0].gajiMax)}"
        : "Not specified",
    "Position": dataPreferences!.isNotEmpty
        ? dataPreferences![0].posisi ?? "Not specified"
        : "Not specified",
    "Job Type": dataPreferences!.isNotEmpty
        ? dataPreferences![0].tipePekerjaan ?? "Not specified"
        : "Not specified",
    "Work System": dataPreferences!.isNotEmpty
        ? dataPreferences![0].sistemKerja ?? "Not specified"
        : "Not specified",
    "Location": dataPreferences!.isNotEmpty
        ? dataPreferences![0].lokasi ?? "Not specified"
        : "Not specified",
    "Career Level": dataPreferences!.isNotEmpty
        ? dataPreferences![0].levelJabatan ?? "Not specified"
        : "Not specified",
    "Availability": dataPreferences!.isNotEmpty
        ? "${DateFormat('dd/MM/yyyy').format(dataPreferences![0].dateWork ?? DateTime.now())}"
        : "Not specified",
  };

  // Map to store icon preferences for each career preference key
  final Map<String, IconData> careerIcons = {
    "Salary Expectation": Icons.attach_money,
    "Position": Icons.business,
    "Job Type": Icons.co_present,
    "Work System": Icons.access_time,
    "Location": Icons.location_on,
    "Career Level": Icons.trending_up,
    "Availability": Icons.event_available,
  };

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
                "Career Preferences",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          for (var entry in careerDescriptions.entries) ...[
            CareerPreferenceCard(
              icon: careerIcons[entry.key] ?? Icons.work,
              title: entry.key,
              description: entry.value,
            ),
            SizedBox(height: 10),
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

  const CareerPreferenceCard({
    required this.icon,
    required this.title,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(5.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              child: Center(
                child: Icon(icon, size: 30, color: Colors.blueAccent),
              ),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ],
        ),
      ),
    );
  }
}
