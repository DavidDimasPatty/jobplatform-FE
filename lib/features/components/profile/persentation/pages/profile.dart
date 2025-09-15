import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/education.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/organizational.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/workExperience.dart';
import 'package:job_platform/features/shared/layout.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Profile extends StatefulWidget {
  final Function(int page) onTabSelected;
  const Profile({super.key, required this.onTabSelected});

  @override
  State<Profile> createState() => _Profile(onTabSelected);
}

class _Profile extends State<Profile> {
  final Function(int page) onTabSelected;
  _Profile(this.onTabSelected);
  List<EducationMV> dataEdu = [];
  List<OrganizationMV> dataOrg = [];
  List<WorkexperienceMV> dataWork = [];
  @override
  void initState() {
    dataLoadDummy();
  }

  void dataLoadDummy() {
    dataEdu.add(
      EducationMV(
        "1",
        "SMAN 13 BANDUNG",
        "SMA",
        DateTime.now(),
        DateTime.now(),
        "Belajar Matematika",
        "IPA",
        "3.0",
      ),
    );
    dataEdu.add(
      EducationMV(
        "2",
        "UNPAR",
        "Kuliah",
        DateTime.now(),
        DateTime.now(),
        "Belajar Komputer",
        "Informatika",
        "3.0",
      ),
    );
    dataOrg.add(
      OrganizationMV(
        "1",
        "Unpar Radio Station",
        DateTime.parse("2020-05-02"),
        DateTime.parse("2023-05-02"),
        "Belajar Operator",
        "Operator Staff",
      ),
    );
    dataOrg.add(
      OrganizationMV(
        "2",
        "Unpar Runner",
        DateTime.parse("2020-05-02"),
        DateTime.parse("2023-05-02"),
        "Olahraga",
        "Staff",
      ),
    );

    dataWork.add(
      WorkexperienceMV(
        "1",
        "PT. YOGYA AKUR PRATAMA",
        "Back End Developer",
        DateTime.now(),
        DateTime.now(),
        "Mengerjakan 123",
        "IT",
        "Retail",
        "Bandung",
        "WFO",
        "Magang",
      ),
    );

    dataWork.add(
      WorkexperienceMV(
        "2",
        "PT. Indomarco",
        "Back End Developer",
        DateTime.now(),
        DateTime.now(),
        "Mengerjakan 123",
        "IT",
        "Retail",
        "Bandung",
        "WFO",
        "Magang",
      ),
    );
    dataWork.add(
      WorkexperienceMV(
        "2",
        "PT. Inti Dunia Sukses",
        "Back End Developer",
        DateTime.now(),
        DateTime.now(),
        "Mengerjakan 123",
        "IT",
        "Retail",
        "Bandung",
        "WFO",
        "Magang",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Center(
        child: Container(
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
          alignment: Alignment.center,
          child: ResponsiveRowColumn(
            columnCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.center,
            columnMainAxisAlignment: MainAxisAlignment.center,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            // layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
            //     ? ResponsiveRowColumnType.COLUMN
            //     : ResponsiveRowColumnType.ROW,
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   image: AssetImage("assets/images/BG_Login.png"),
                        //   fit: BoxFit.cover,
                        // ),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 0,
                      child: Container(
                        child: IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () {
                            onTabSelected(3);
                          },
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: const CircleAvatar(
                                  radius: 46,
                                  //backgroundImage: AssetImage("assets/profile.jpg"),
                                  backgroundColor: Colors.blueGrey,
                                ),
                              ),

                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () {
                                      print("Ganti foto profil diklik");
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          child: Text(
                            "Nama",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSerif(
                              textStyle: TextStyle(
                                color: Colors.white,
                                letterSpacing: 1,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          child: Text(
                            "Headline1|Headline2|Headline3",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ptSerif(
                              textStyle: TextStyle(
                                color: Colors.white,
                                //letterSpacing: 2,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ResponsiveRowColumnItem(
                child: Workexperience(
                  dataWork: dataWork,
                  onTabSelected: onTabSelected,
                ),
              ),
              ResponsiveRowColumnItem(
                child: Organizational(
                  dataOrg: dataOrg,
                  onTabSelected: onTabSelected,
                ),
              ),
              ResponsiveRowColumnItem(
                child: Education(
                  dataEdu: dataEdu,
                  onTabSelected: onTabSelected,
                ),
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  height: 200,
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.account_box),
                        title: Text("Account Configuration"),
                        subtitle: Text("Konfigurasi Account"),
                      ),
                      Divider(height: 1, thickness: 1),
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.call),
                        title: Text("Contact Support"),
                        subtitle: Text("Support Aplikasi Customer Service"),
                      ),
                      Divider(height: 1, thickness: 1),
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.logout),
                        title: Text("Log Out"),
                      ),
                      Divider(height: 1, thickness: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
