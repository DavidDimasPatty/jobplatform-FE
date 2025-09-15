import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:intl/intl.dart';

class Workexperience extends StatefulWidget {
  List<WorkexperienceMV>? dataWork;
  final Function(int page) onTabSelected;
  Workexperience({super.key, this.dataWork, required this.onTabSelected});

  @override
  State<Workexperience> createState() =>
      _Workexperience(dataWork, onTabSelected);
}

class _Workexperience extends State<Workexperience> {
  List<WorkexperienceMV>? dataWork;
  final Function(int page) onTabSelected;
  _Workexperience(this.dataWork, this.onTabSelected);
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
                  "Work Experience",
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
                  onTabSelected!(4);
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
            children: dataWork!.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              var data = entry.value;
              return InkWell(
                onTap: () {
                  onTabSelected(5);
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
                          Text(data.namaPerusahaan!),
                          Text(data.namaJabatan! + " - " + data.sistemKerja!),
                          // Text(data.penjurusan!),
                        ],
                      ),

                      Flexible(
                        flex: 2,
                        child: Text(
                          softWrap: true,
                          textAlign: TextAlign.center,
                          DateFormat(
                                'yyyy-MM-dd',
                              ).format(data.startDate!).toString() +
                              " - " +
                              DateFormat(
                                'yyyy-MM-dd',
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
