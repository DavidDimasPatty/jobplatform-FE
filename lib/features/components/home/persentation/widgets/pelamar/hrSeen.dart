import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Hrseen extends StatefulWidget {
  // final CandidateItems item;
  Hrseen({super.key});

  @override
  State<Hrseen> createState() => _Hrseen();
}

class _Hrseen extends State<Hrseen> with SingleTickerProviderStateMixin {
  // final CandidateItems item;
  // _Listjobreceive(this.item);
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

  Widget _buildLineChart(List<FlSpot> spots, String title) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                "Grafik Profile Dilihat",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: const [
              Tab(text: "Harian"),
              Tab(text: "Mingguan"),
              Tab(text: "Bulanan"),
            ],
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLineChart([
                  FlSpot(1, 2),
                  FlSpot(2, 3),
                  FlSpot(3, 1),
                  FlSpot(4, 4),
                  FlSpot(5, 2.5),
                ], "Kunjungan Harian"),
                _buildLineChart([
                  FlSpot(1, 10),
                  FlSpot(2, 12),
                  FlSpot(3, 7),
                  FlSpot(4, 14),
                ], "Kunjungan Mingguan"),
                _buildLineChart([
                  FlSpot(1, 30),
                  FlSpot(2, 40),
                  FlSpot(3, 28),
                  FlSpot(4, 45),
                ], "Kunjungan Bulanan"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
