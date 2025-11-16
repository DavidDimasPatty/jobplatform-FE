import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:intl/intl.dart';

class WorkexperienceCandidate extends StatelessWidget {
  final List<WorkexperienceMV> dataWork;
  // final VoidCallback onAddPressed;
  // final ValueChanged<WorkexperienceMV> onEditPressed;

  WorkexperienceCandidate({
    super.key,
    required this.dataWork,
    // required this.onAddPressed,
    // required this.onEditPressed,
  });

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
              // ElevatedButton.icon(
              //   //onPressed: onAddPressed,
              //   onPressed: () {},
              //   icon: Icon(Icons.add, size: 20),
              //   label: Text("Add"),
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor:Theme.of(context).colorScheme.secondary,
              //      foregroundColor: Theme.of(context).colorScheme.primary,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: dataWork.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              var data = entry.value;
              return InkWell(
                // onTap: () => onEditPressed(data),
                //onTap: () {},
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
                            data.experience.namaPerusahaan,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data.namaJabatan! + " - " + data.sistemKerja!,
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
                          (data.endDate == null)
                              ? "${DateFormat('MMM yyyy').format(data.startDate!)} - Present"
                              : "${DateFormat('MMM yyyy').format(data.startDate!)} - ${DateFormat('MMM yyyy').format(data.endDate!)}",
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
