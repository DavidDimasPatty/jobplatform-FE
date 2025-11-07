import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkApplicant.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/graficProfil.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/hrSeen.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/listJobReceive.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Homepagebody extends StatefulWidget {
  // final CandidateItems item;
  List<Benchmarkitem>? items;
  Homepagebody({super.key, this.items});

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
          //layout: ResponsiveRowColumnType.COLUMN,
          rowSpacing: 100,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Listjobreceive(),
                  SizedBox(height: 20),
                  Benchmarkapplicant(items: widget.items),
                ],
              ),
              //child: Listjobreceive(navigatorKeys: widget.navigatorKeys),
            ),

            // kelengkapan profil + grafik jadi satu kolom
            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Graficprofil(), SizedBox(height: 20), Hrseen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
