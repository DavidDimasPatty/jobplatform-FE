import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Aboutus extends StatefulWidget {
  Aboutus({super.key});
  @override
  State<Aboutus> createState() => _Aboutus();
}

class _Aboutus extends State<Aboutus> {
  bool _isLoading = true;
  late String? _languageController;

  late String title;
  late String subtitle;
  late String description;
  late List<Map<String, String>> features;
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final setting = context.read<SettingProvider>();
      await setting.loadSetting();
      _languageController = setting.language;

      if (_languageController == "IND") {
        title = "Tentang Skillen";
        subtitle = "Mendorong Transformasi Digital";
        description = """

Skillen adalah perusahaan IT Solution yang inovatif, berfokus membantu bisnis berkembang melalui sistem digital yang andal, aman, dan berkinerja tinggi.

Kami mengkhususkan diri dalam pengembangan perangkat lunak, integrasi cloud, dan automasi digital untuk menjadikan teknologi lebih sederhana dan efektif bagi semua orang.

Misi kami adalah menciptakan solusi yang membantu bisnis tumbuh lebih cepat, lebih cerdas, dan lebih efisien.
""";

        features = [
          {
            "icon": "💡",
            "title": "Inovasi",
            "desc":
                "Kami terus mengeksplorasi teknologi baru untuk menghadirkan solusi yang lebih cerdas.",
          },
          {
            "icon": "🛠️",
            "title": "Keandalan",
            "desc":
                "Kami memastikan setiap sistem yang kami bangun stabil, aman, dan dapat diskalakan.",
          },
          {
            "icon": "🤝",
            "title": "Kolaborasi",
            "desc":
                "Kami percaya bahwa produk hebat lahir dari kerja sama dan komunikasi yang baik.",
          },
          {
            "icon": "🔒",
            "title": "Keamanan",
            "desc":
                "Kami membangun solusi yang berlandaskan standar keamanan terbaik.",
          },
        ];
      } else {
        title = "About Skillen";
        subtitle = "Empowering Digital Transformation";
        description = """

Skillen is an innovative IT Solution company dedicated to helping businesses scale with reliable, secure, and high-performance digital systems.

We specialize in software development, cloud integration, and digital automation to make technology simple and effective for everyone.

Our mission is to create tools that help businesses grow faster, smarter, and more efficiently.
""";

        features = [
          {
            "icon": "💡",
            "title": "Innovation",
            "desc":
                "We antly explore new technologies to deliver smarter solutions.",
          },
          {
            "icon": "🛠️",
            "title": "Reliability",
            "desc":
                "We ensure every system we build is stable, secure, and scalable.",
          },
          {
            "icon": "🤝",
            "title": "Collaboration",
            "desc":
                "We believe great products are born from great teamwork and communication.",
          },
          {
            "icon": "🔒",
            "title": "Security",
            "desc":
                "We believe great products are born based on great security.",
          },
        ];
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading data...'),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Container(
                  padding: EdgeInsets.all(10),
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
                  child: ResponsiveRowColumn(
                    layout: ResponsiveBreakpoints.of(context).isDesktop
                        ? ResponsiveRowColumnType.ROW
                        : ResponsiveRowColumnType.COLUMN,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    columnCrossAxisAlignment: CrossAxisAlignment.start,
                    rowCrossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              'assets/images/BG_HRD.png',
                              width: 400,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      ResponsiveRowColumnItem(
                        rowFlex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20),
                            Text(
                              title,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              description,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    height: 1.6,
                                    color: Colors.grey[700],
                                  ),
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              children: [
                                for (var item in features)
                                  Container(
                                    width: 200,
                                    constraints: BoxConstraints(minHeight: 200),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 0.4,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item["icon"]!,
                                          style: TextStyle(fontSize: 24),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          item["title"]!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          item["desc"]!,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
