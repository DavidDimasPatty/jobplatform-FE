import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';

class statusJobDetailMore extends StatefulWidget {
  final StatusDetailVM? data;
  final String? status;

  statusJobDetailMore({super.key, this.data, this.status});

  @override
  State<statusJobDetailMore> createState() => _StatusJobDetailState();
}

class _StatusJobDetailState extends State<statusJobDetailMore> {
  final storage = StorageService();
  double? header, subHeader, body, icon;

  Future<void> _initializeFontSize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
  }

  @override
  void initState() {
    super.initState();
    _initializeFontSize();
  }

  Map<String, String> get careerDescriptions => {
    "Salary Expectation".tr(): widget.data != null
        ? widget.data?.gajiMaxNego != null && widget.data?.gajiMin != null
              ? "${NumberFormat('#,###').format(widget.data?.gajiMinNego)} - ${NumberFormat('#,###').format(widget.data?.gajiMaxNego)}"
              : "${NumberFormat('#,###').format(widget.data?.gajiMin)} - ${NumberFormat('#,###').format(widget.data?.gajiMax)}"
        : "Not specified".tr(),
    "Position".tr(): widget.data != null
        ? widget.data?.namaPosisi ?? "Not specified".tr()
        : "Not specified".tr(),
    "Job Type".tr(): widget.data != null
        ? widget.data?.tipePekerjaanNego != null
              ? widget.data!.tipePekerjaanNego!
              : widget.data?.tipePekerjaan ?? "Not specified".tr()
        : "Not specified".tr(),
    "Work System".tr(): widget.data != null
        ? widget.data?.sistemKerjaNego != null
              ? widget.data!.sistemKerjaNego!
              : widget.data?.sistemKerja ?? "Not specified".tr()
        : "Not specified".tr(),
    "Location".tr(): widget.data != null
        ? widget.data?.lokasiKerja ?? "Not specified".tr()
        : "Not specified".tr(),
    "Career Level".tr(): widget.data != null
        ? widget.data?.jabatan ?? "Not specified".tr()
        : "Not specified".tr(),
    "Min. Exprience".tr(): widget.data != null
        ? "${widget.data?.minExperience.toString()} ${"Tahun".tr()}" ??
              "Not specified".tr()
        : "Not specified".tr(),
    "Skill Required": widget.data != null && widget.data?.skill != null
        ? widget.data!.skill!.map((x) => x.nama).join(", ")
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
              headerSize: header,
              subtitleSize: body,
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
  final double? headerSize;
  final double? subtitleSize;

  const CareerPreferenceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.headerSize,
    required this.subtitleSize,
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
                  style: TextStyle(fontSize: headerSize ?? 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: subtitleSize ?? 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
