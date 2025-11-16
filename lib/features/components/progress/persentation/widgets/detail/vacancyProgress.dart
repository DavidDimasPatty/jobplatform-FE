import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';

class VacancyProgress extends StatelessWidget {
  final CompanyVacancies? dataVacancy;
  final UserVacancies? dataUserVacancy;
  final String? status;

  VacancyProgress({
    super.key,
    this.dataVacancy,
    this.dataUserVacancy,
    this.status,
  });

  Map<String, String> get careerDescriptions => {
    "Salary Expectation": dataUserVacancy != null
        ? dataUserVacancy?.gajiMax != null && dataUserVacancy?.gajiMin != null
              ? "${NumberFormat('#,###').format(dataUserVacancy?.gajiMin)} - ${NumberFormat('#,###').format(dataUserVacancy?.gajiMax)}"
              : dataVacancy != null
              ? "${NumberFormat('#,###').format(dataVacancy?.gajiMin)} - ${NumberFormat('#,###').format(dataVacancy?.gajiMax)}"
              : "Not specified"
        : "Not specified",
    "Position": dataVacancy != null
        ? dataVacancy?.namaPosisi ?? "Not specified"
        : "Not specified",
    "Job Type": dataUserVacancy != null
        ? dataUserVacancy?.tipeKerja != null
              ? dataUserVacancy!.tipeKerja!
              : dataVacancy != null
              ? dataVacancy?.tipeKerja ?? "Not specified"
              : "Not specified"
        : "Not specified",
    "Work System": dataUserVacancy != null
        ? dataUserVacancy?.sistemKerja != null
              ? dataUserVacancy!.sistemKerja!
              : dataVacancy != null
              ? dataVacancy?.sistemKerja ?? "Not specified"
              : "Not specified"
        : "Not specified",
    "Location": dataVacancy != null
        ? dataVacancy?.lokasi ?? "Not specified"
        : "Not specified",
    "Career Level": dataVacancy != null
        ? dataVacancy?.jabatan ?? "Not specified"
        : "Not specified",
  };

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
                "Offering Details",
                style: TextStyle(
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
              if (status == "Offering")
                ElevatedButton.icon(
                  onPressed: () => context.go(
                    "/editVacancyCandidate",
                    extra: {
                      "dataVacancy": dataVacancy,
                      "dataUserVacancy": dataUserVacancy,
                    },
                  ),
                  icon: Icon(Icons.edit, size: 16),
                  label: Text("Edit"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.primary,
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
