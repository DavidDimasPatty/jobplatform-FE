import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CompanyWaiting extends StatefulWidget {
  final String idPerusahaan;
  final String namaPerusahaan;
  final String stage;
  CompanyWaiting(this.stage, this.idPerusahaan, this.namaPerusahaan);

  @override
  State<CompanyWaiting> createState() =>
      _CompanyWaiting(this.stage, this.idPerusahaan, this.namaPerusahaan);
}

class _CompanyWaiting extends State<CompanyWaiting> {
  final String idPerusahaan;
  final String namaPerusahaan;
  final String stage;
  _CompanyWaiting(this.stage, this.idPerusahaan, this.namaPerusahaan);

  final List<String> steps = [
    "Pemilihan Surveyer",
    "Survey",
    "Konfirmasi Surveyer",
    "Konfirmasi Admin",
  ];
  int stepsImpl = 0;

  @override
  void initState() {
    super.initState();
    stepsChange();
  }

  int stepsChange() {
    if (stage == "Pending Survey" ||
        stage == "Belum ada proses survey/approval") {
      stepsImpl = 0;
    } else if (stage == "Process Survey") {
      stepsImpl = 1;
    } else if (stage == "Accept") {
      stepsImpl = 2;
    } else if (stage == "Accept Admin") {
      stepsImpl = 3;
    }
    return stepsImpl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isMobile = ResponsiveBreakpoints.of(
              context,
            ).smallerThan(TABLET);
            if (!isMobile) {
              return Container(
                width: 800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Proses Validasi",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dancingScript(
                          textStyle: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 5,
                            fontSize: 60,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      width: 400,
                      child: Text(
                        "Mohon menunggu validasi dari Skillen untuk perusahaan ${namaPerusahaan}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.ptSerif(
                          textStyle: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(steps.length * 2 - 1, (index) {
                        if (index.isEven) {
                          int stepIndex = index ~/ 2;
                          return Container(
                            margin: EdgeInsets.only(top: 60),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: stepsImpl >= stepIndex
                                      ? Colors.blue
                                      : Colors.grey.shade200,
                                  child: Text(
                                    "${stepIndex + 1}",
                                    style: TextStyle(
                                      color: stepsImpl >= stepIndex
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 100,
                                  height: 60,
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    steps[stepIndex],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.ptSerif(
                                      textStyle: TextStyle(
                                        color: stepsImpl >= stepIndex
                                            ? Colors.blue
                                            : Colors.grey.shade600,
                                        letterSpacing: 1,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          int stepIndex = index ~/ 2;
                          return Expanded(
                            child: Container(
                              height: 2,
                              color: stepsImpl >= stepIndex
                                  ? Colors.blue
                                  : Colors.grey.shade600,
                            ),
                          );
                        }
                      }),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Proses Validasi",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          color: Colors.blue,
                          letterSpacing: 5,
                          fontSize: 60,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    width: 400,
                    child: Text(
                      "Mohon menunggu validasi dari Skillen untuk perusahaan ${namaPerusahaan}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ptSerif(
                        textStyle: TextStyle(
                          color: Colors.blue,
                          letterSpacing: 2,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: steps.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: stepsImpl >= index
                                  ? Colors.blue
                                  : Colors.grey.shade200,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: stepsImpl >= index
                                      ? Colors.white
                                      : Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              steps[index],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.ptSerif(
                                textStyle: TextStyle(
                                  color: stepsImpl >= index
                                      ? Colors.blue
                                      : Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
