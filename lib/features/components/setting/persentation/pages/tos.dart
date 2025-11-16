import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/core/utils/providers/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Tos extends StatefulWidget {
  Tos({super.key});

  State<Tos> createState() => _Tos();
}

class _Tos extends State<Tos> {
  List<String> Judul = [];
  List<String> Desc = [];
  bool _isLoading = true;
  late String? _languageController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final setting = context.read<SettingProvider>();
      await setting.loadSetting();
      _languageController = setting.language;
      if (_languageController != "IND") {
        Judul = [
          "Acceptance of Terms",
          "Description of Service",
          "User Responsibilites",
          "Intellectual Property",
          "Privacy Policy",
          "Limitation of Liability",
          "Changes to Terms",
          "Contact Us",
        ];

        Desc = [
          "By using Skillen’s services, you confirm that you have read, understood, and agreed to these Terms of Service. If you do not agree, please discontinue use of our platform immediately.",
          "Skillen provides IT solutions and related digital services for individuals and businesses. We may update, modify, or discontinue any part of our services without prior notice.",
          "You agree to: Provide accurate and up-to-date information when using our platform. Not misuse or attempt to gain unauthorized access to our systems. Comply with all applicable local and international laws. We reserve the right to suspend or terminate accounts that violate these terms.",
          "All content, including logos, text, graphics, and software on Skillen, are the property of Skillen or its licensors. You may not reproduce, modify, or distribute any part of our materials without written permission.",
          "Your privacy is important to us. Please refer to our Privacy Policy for information on how we collect, use, and protect your data.",
          "Skillen shall not be liable for any indirect, incidental, or consequential damages arising from the use or inability to use our services.",
          "We may update these Terms of Service periodically. Any changes will be posted on this page, and continued use of our services means you accept the updated terms.",
          "If you have any questions about these Terms, please contact us at: 📧 support@skillen.com",
        ];
      } else {
        Judul = [
          "Penerimaan Persyaratan",
          "Deskripsi Layanan",
          "Tanggung Jawab Pengguna",
          "Kekayaan Intelektual",
          "Kebijakan Privasi",
          "Batasan Tanggung Jawab",
          "Perubahan Persyaratan",
          "Hubungi Kami",
        ];
        Desc = [
          "Dengan menggunakan layanan Skillen, Anda menyatakan bahwa Anda telah membaca, memahami, dan menyetujui Ketentuan Layanan ini. Jika Anda tidak setuju, harap hentikan penggunaan platform kami segera.",
          "Skillen menyediakan solusi IT dan layanan digital terkait untuk individu maupun bisnis. Kami dapat memperbarui, memodifikasi, atau menghentikan sebagian atau seluruh layanan kami tanpa pemberitahuan terlebih dahulu.",
          "Anda setuju untuk: Memberikan informasi yang akurat dan terbaru saat menggunakan platform kami. Tidak menyalahgunakan atau mencoba mendapatkan akses tidak sah ke sistem kami. Mematuhi semua hukum dan peraturan yang berlaku, baik lokal maupun internasional. Kami berhak menangguhkan atau menghentikan akun yang melanggar persyaratan ini.",
          "Seluruh konten, termasuk logo, teks, grafik, dan perangkat lunak di Skillen, merupakan milik Skillen atau pemegang lisensi terkait. Anda tidak diperbolehkan menyalin, memodifikasi, atau mendistribusikan materi kami tanpa izin tertulis.",
          "Privasi Anda penting bagi kami. Silakan merujuk ke Kebijakan Privasi kami untuk informasi tentang bagaimana kami mengumpulkan, menggunakan, dan melindungi data Anda.",
          "Skillen tidak bertanggung jawab atas kerugian tidak langsung, insidental, atau konsekuensial yang timbul dari penggunaan atau ketidakmampuan menggunakan layanan kami.",
          "Kami dapat memperbarui Ketentuan Layanan ini secara berkala. Setiap perubahan akan diumumkan di halaman ini, dan penggunaan berkelanjutan atas layanan kami berarti Anda menerima persyaratan yang telah diperbarui.",
          "Jika Anda memiliki pertanyaan terkait Ketentuan ini, silakan hubungi kami di: 📧 support@skillen.com",
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
          ? const Center(
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
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10,
                bottom: 20,
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(20),
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
                  width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                      ? double.infinity
                      : MediaQuery.of(context).size.width * 0.45,
                  alignment: Alignment.center,
                  child: ResponsiveRowColumn(
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    columnMainAxisAlignment: MainAxisAlignment.center,
                    rowCrossAxisAlignment: CrossAxisAlignment.center,
                    layout: ResponsiveRowColumnType.COLUMN,
                    rowSpacing: 100,
                    columnSpacing: 20,
                    children: [
                      ResponsiveRowColumnItem(
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Terms Of Service".tr(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Last Updated: ".tr(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "TanggalUpdateTOS".tr(),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      ResponsiveRowColumnItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 15,
                          children: [
                            for (var i = 0; i < Judul.length; i++)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${i + 1}. ${Judul[i]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(Desc[i], overflow: TextOverflow.clip),
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
