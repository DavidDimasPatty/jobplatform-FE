import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_platform/features/components/progress/data/models/organizationProgressModel.dart';

class OrganizationalProgress extends StatelessWidget {
  final List<OrganizationProgressModel>? dataOrg;

  OrganizationalProgress({super.key, this.dataOrg});

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
                  "Organizational Experience",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    letterSpacing: 1,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Column(
            children: dataOrg!.asMap().entries.map((entry) {
              int idx = entry.key + 1;
              var data = entry.value;
              return InkWell(
                //onTap: () => onEditPressed(data),
                // onTap: () {},
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
                            data.nama ?? "",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data.jabatan!,
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
