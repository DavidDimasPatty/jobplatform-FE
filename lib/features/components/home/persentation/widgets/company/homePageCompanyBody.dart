import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/graph1.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/graph2.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrList.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/hrListitem.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTable.dart';
import 'package:job_platform/features/components/home/persentation/widgets/company/vacancyTableItem.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomepageCompanybody extends StatefulWidget {
  List<Vacancytableitem>? items;
  List<hrListitem>? itemsHr;
  ProsesPerekrutan? dataPerekrutan;
  ProsesPelamaran? dataPelamaran;
  HomepageCompanybody({super.key, this.items, this.itemsHr});

  @override
  State<HomepageCompanybody> createState() => _HomepageCompanybody();
}

class _HomepageCompanybody extends State<HomepageCompanybody> {
  //final _searchController = TextEditingController();
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
                  hrList(items: widget.itemsHr),
                  SizedBox(height: 20),
                  Vacancytable(items: widget.items),
                ],
              ),
            ),

            ResponsiveRowColumnItem(
              rowFlex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Graph1(item: widget.dataPerekrutan),
                  SizedBox(height: 10),
                  Graph2(item: widget.dataPelamaran),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
