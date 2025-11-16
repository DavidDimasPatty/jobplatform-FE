import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';

class statusJobDetailMore extends StatelessWidget {
  final StatusDetailVM? data;
  final String? status;

  statusJobDetailMore({super.key, this.data, this.status});
  Map<String, String> get careerDescriptions => {
    "Salary Expectation".tr(): data != null
        ? data?.gajiMaxNego != null && data?.gajiMin != null
              ? "${NumberFormat('#,###').format(data?.gajiMinNego)} - ${NumberFormat('#,###').format(data?.gajiMaxNego)}"
              : "${NumberFormat('#,###').format(data?.gajiMin)} - ${NumberFormat('#,###').format(data?.gajiMax)}"
        : "Not specified".tr(),
    "Position".tr(): data != null
        ? data?.namaPosisi ?? "Not specified".tr()
        : "Not specified".tr(),
    "Job Type".tr(): data != null
        ? data?.tipePekerjaanNego != null
              ? data!.tipePekerjaanNego!
              : data?.tipePekerjaan ?? "Not specified".tr()
        : "Not specified".tr(),
    "Work System".tr(): data != null
        ? data?.sistemKerjaNego != null
              ? data!.sistemKerjaNego!
              : data?.sistemKerja ?? "Not specified".tr()
        : "Not specified".tr(),
    "Location".tr(): data != null
        ? data?.lokasiKerja ?? "Not specified".tr()
        : "Not specified".tr(),
    "Career Level".tr(): data != null
        ? data?.jabatan ?? "Not specified".tr()
        : "Not specified".tr(),
    "Min. Exprience".tr(): data != null
        ? "${data?.minExperience.toString()} ${"Tahun".tr()}" ??
              "Not specified".tr()
        : "Not specified".tr(),
    "Skill Required": data != null && data?.skill != null
        ? data!.skill!.map((x) => x.nama).join(", ")
        : "Not specified".tr(),
  };

  final Map<String, IconData> careerIcons = {
    "Salary Expectation": Icons.attach_money,
    "Position": Icons.business,
    "Job Type": Icons.co_present,
    "Work System": Icons.access_time,
    "Location": Icons.location_on,
    "Career Level": Icons.trending_up,
    "Availability": Icons.event_available,
    "Min. Exprience": Icons.work,
    "Skill Required": Icons.add_chart,
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
                "Offering Details".tr(),
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
