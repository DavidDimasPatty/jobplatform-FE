import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';

class Graph2 extends StatefulWidget {
  final ProsesPelamaran? item;
  Graph2({super.key, this.item});

  @override
  State<Graph2> createState() => _Graph2();
}

class _Graph2 extends State<Graph2> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final storage = StorageService();
  double? header, subHeader, body, icon;

  Future<void> _initializeFontSize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
  }

  @override
  void initState() {
    super.initState();
    _initializeFontSize();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLineChart(List<FlSpot> spots, String title) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: subHeader, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toInt().toString());
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    barWidth: 3,
                    color: Colors.blue,
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
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
                "Banyaknya Proses Pelamaran".tr(),
                style: TextStyle(fontSize: header, color: Colors.white),
              ),
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: "Harian".tr()),
              Tab(text: "Mingguan".tr()),
              Tab(text: "Bulanan".tr()),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLineChart([
                  FlSpot(1, widget.item!.harian![0].toDouble()),
                  FlSpot(2, widget.item!.harian![1].toDouble()),
                  FlSpot(3, widget.item!.harian![2].toDouble()),
                  FlSpot(4, widget.item!.harian![3].toDouble()),
                  FlSpot(5, widget.item!.harian![4].toDouble()),
                  FlSpot(6, widget.item!.harian![5].toDouble()),
                ], "Harian".tr()),
                _buildLineChart([
                  FlSpot(1, widget.item!.mingguan![0].toDouble()),
                  FlSpot(2, widget.item!.mingguan![1].toDouble()),
                  FlSpot(3, widget.item!.mingguan![2].toDouble()),
                  FlSpot(4, widget.item!.mingguan![3].toDouble()),
                ], "Mingguan".tr()),
                _buildLineChart([
                  FlSpot(1, widget.item!.bulanan![0].toDouble()),
                  FlSpot(2, widget.item!.bulanan![1].toDouble()),
                  FlSpot(3, widget.item!.bulanan![2].toDouble()),
                  FlSpot(4, widget.item!.bulanan![3].toDouble()),
                  FlSpot(5, widget.item!.bulanan![4].toDouble()),
                  FlSpot(6, widget.item!.bulanan![5].toDouble()),
                  FlSpot(7, widget.item!.bulanan![6].toDouble()),
                  FlSpot(8, widget.item!.bulanan![7].toDouble()),
                  FlSpot(9, widget.item!.bulanan![8].toDouble()),
                  FlSpot(10, widget.item!.bulanan![9].toDouble()),
                  FlSpot(11, widget.item!.bulanan![10].toDouble()),
                  FlSpot(12, widget.item!.bulanan![11].toDouble()),
                ], "Bulanan".tr()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
