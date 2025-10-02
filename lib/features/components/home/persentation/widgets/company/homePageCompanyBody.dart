import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/graph1.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/graph2.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrList.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrListitem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTable.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTableItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkApplicant.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/graficProfil.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/hrSeen.dart';
import 'package:job_platform/features/components/home/persentation/widgets/pelamar/listJobReceive.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomepageCompanybody extends StatefulWidget {
  // final CandidateItems item;
  List<Vacancytableitem>? items;
  List<hrListitem>? itemsHr;
  HomepageCompanybody({super.key, this.items, this.itemsHr});

  @override
  State<HomepageCompanybody> createState() => _HomepageCompanybody();
}

class _HomepageCompanybody extends State<HomepageCompanybody> {
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
                  hrList(items: widget.itemsHr),
                  SizedBox(height: 20),
                  Vacancytable(items: widget.items),
                ],
              ),
              //child: Listjobreceive(navigatorKeys: widget.navigatorKeys),
            ),

            // kelengkapan profil + grafik jadi satu kolom
            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Graph1(), SizedBox(height: 10), Graph2()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
