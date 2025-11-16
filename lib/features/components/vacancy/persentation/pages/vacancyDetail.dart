import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/vacancy/domain/entities/vacancyData.dart';
import 'package:responsive_framework/responsive_framework.dart';

class VacancyDetail extends StatelessWidget {
  final VacancyData data;

  const VacancyDetail({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(3, 3),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          'Detail Vacancy'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.attach_money,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.gajiMin} - ${data.gajiMax}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.business, color: Colors.blueAccent),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.namaPosisi}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.co_present,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.tipeKerja}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.sistemKerja}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.lokasi}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${data.jabatan}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),

                      ElevatedButton.icon(
                        onPressed: () {
                          context.go('/vacancy');
                        },
                        icon: Icon(Icons.arrow_back),
                        iconAlignment: IconAlignment.start,
                        label: Text('Back'.tr()),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
