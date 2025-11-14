import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/data/models/KunjunganProfile.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/TawaranPekerjaan.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkApplicant.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/graficProfil.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/hrSeen.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/listJobReceive.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/openVacancyItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/openVacancyView.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Homepagebody extends StatefulWidget {
  bool? isHRD;
  List<Benchmarkitem>? items;
  String? photoURL;
  double? profileComplete;
  String? username;
  KunjunganProfile? dataKunjunganProfile;
  List<OpenVacancyItem>? dataVacancies;
  List<TawaranPekerjaan>? dataTawaranPekerjaan;
  Homepagebody({
    super.key,
    this.items,
    this.isHRD,
    this.dataKunjunganProfile,
    this.username,
    this.dataVacancies,
    this.photoURL,
    this.profileComplete,
    this.dataTawaranPekerjaan,
  });

  @override
  State<Homepagebody> createState() => _Homepagebody();
}

class _Homepagebody extends State<Homepagebody> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? double.infinity
            : MediaQuery.of(context).size.width * 0.85,
        alignment: Alignment.topCenter,
        child: ResponsiveRowColumn(
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          rowMainAxisAlignment: MainAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.start,
          layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowSpacing: 100,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Listjobreceive(dataTawaran: widget.dataTawaranPekerjaan),
                  SizedBox(height: 20),
                  Benchmarkapplicant(items: widget.items),
                  SizedBox(height: 20),
                  if (widget.isHRD!)
                    OpenVacancyView(items: widget.dataVacancies),
                ],
              ),
            ),

            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Graficprofil(
                    photoURL: widget.photoURL,
                    profileComplete: widget.profileComplete,
                    username: widget.username,
                  ),
                  SizedBox(height: 20),
                  Hrseen(item: widget.dataKunjunganProfile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
