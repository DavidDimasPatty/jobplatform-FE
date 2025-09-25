import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/home/persentation/widgets/benchmarkApplicant.dart';
import 'package:job_platform/features/components/home/persentation/widgets/benchmarkItem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/graficProfil.dart';
import 'package:job_platform/features/components/home/persentation/widgets/hrSeen.dart';
import 'package:job_platform/features/components/home/persentation/widgets/listJobReceive.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Homepagebody extends StatefulWidget {
  // final CandidateItems item;
  GlobalKey<NavigatorState> navigatorKeys;
  List<Benchmarkitem>? items;
  Homepagebody({super.key, required this.navigatorKeys, this.items});

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
                  Listjobreceive(navigatorKeys: widget.navigatorKeys),
                  SizedBox(height: 20),
                  Benchmarkapplicant(
                    items: widget.items,
                    navigatorKeys: widget.navigatorKeys,
                  ),
                ],
              ),
              //child: Listjobreceive(navigatorKeys: widget.navigatorKeys),
            ),

            // kelengkapan profil + grafik jadi satu kolom
            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Graficprofil(navigatorKeys: widget.navigatorKeys),
                  SizedBox(height: 20),
                  Hrseen(navigatorKeys: widget.navigatorKeys),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
