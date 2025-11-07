import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Graph1 extends StatefulWidget {
  // final CandidateItems item;
  Graph1({super.key});

  @override
  State<Graph1> createState() => _Graph1();
}

class _Graph1 extends State<Graph1> with SingleTickerProviderStateMixin {
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

  List<PieChartSectionData> _showingSections() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 40,
        title: '40%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 30,
        title: '30%',
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 20,
        title: '20%',
        radius: 50,
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 10,
        title: '10%',
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
                "Grafik Proses Perekrutan",
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
                        Text(
                          "Proses Rekrut diterima",
                          style: const TextStyle(fontSize: 14),
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
                        Text(
                          "Proses Rekrut ditolak",
                          style: const TextStyle(fontSize: 14),
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
                        Text(
                          "Proses Rekrut Berhasil",
                          style: const TextStyle(fontSize: 14),
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
                        Text(
                          "Proses Rekrut Pending",
                          style: const TextStyle(fontSize: 14),
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
