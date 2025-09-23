import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:intl/intl.dart';

class Education extends StatefulWidget {
  List<EducationMV>? dataEdu;
  final Function(int page) onTabSelected;
  Education({super.key, this.dataEdu, required this.onTabSelected});

  @override
  State<Education> createState() => _Education(dataEdu, this.onTabSelected);
}

class _Education extends State<Education> {
  List<EducationMV>? dataEdu;
  final Function(int page) onTabSelected;
  _Education(this.dataEdu, this.onTabSelected);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  "Educational",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  onTabSelected!(6);
                },
                icon: Icon(Icons.add, size: 20),
                label: Text("Add"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: dataEdu!.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              var data = entry.value;
              return InkWell(
                onTap: () {
                  onTabSelected(7);
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
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
                        children: [
                          Text(
                            data.nama!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data.tingkat! + " - " + data.penjurusan!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          // Text(data.penjurusan!),
                        ],
                      ),

                      Flexible(
                        flex: 2,
                        child: Text(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          DateFormat(
                                'MMM yyyy',
                              ).format(data.startDate!).toString() +
                              " - " +
                              DateFormat(
                                'MMM yyyy',
                              ).format(data.endDate!).toString(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
