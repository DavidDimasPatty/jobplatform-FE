import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';

class Graph1 extends StatefulWidget {
  final ProsesPerekrutan? item;
  const Graph1({super.key, this.item});

  @override
  State<Graph1> createState() => _Graph1();
}

class _Graph1 extends State<Graph1> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<PieChartSectionData> _showingSections() {
    double totalData =
        widget.item!.rekrutBerhasil!.toDouble() +
        widget.item!.rekrutDiterima!.toDouble() +
        widget.item!.rekrutDitolak!.toDouble() +
        widget.item!.rekrutPending!.toDouble();
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: (widget!.item!.rekrutDiterima!.toDouble() / totalData) * 100,
        title:
            "${((widget!.item!.rekrutDiterima!.toDouble() / totalData) * 100).toStringAsFixed(2)}%",
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: (widget!.item!.rekrutDitolak!.toDouble() / totalData) * 100,
        title:
            "${((widget!.item!.rekrutDitolak!.toDouble() / totalData) * 100).toStringAsFixed(2)}%",
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: (widget!.item!.rekrutBerhasil!.toDouble() / totalData) * 100,
        title:
            "${((widget!.item!.rekrutBerhasil!.toDouble() / totalData) * 100).toStringAsFixed(2)}%",
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: (widget!.item!.rekrutPending!.toDouble() / totalData) * 100,
        title:
            "${((widget!.item!.rekrutPending!.toDouble() / totalData) * 100).toStringAsFixed(2)}%",
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            width: double.infinity,
            child: Center(
              child: Text(
                "Grafik Proses Perekrutan".tr(),
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 6,
                child: SizedBox(
                  height: 300,
                  child: PieChart(
                    PieChartData(
                      sections: _showingSections(),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ),

              Flexible(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Proses Rekrut diterima".tr(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Proses rekrut ditolak".tr(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Proses rekrut berhasil".tr(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Proses rekrut pending".tr(),
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
