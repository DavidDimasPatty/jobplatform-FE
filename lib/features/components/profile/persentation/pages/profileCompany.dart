import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/persentation/pages/profileCompany/personalInfoCompany.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/careerPreference.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/certificate.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/education.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/organizational.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/skill.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/workExperience.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileCompany extends StatefulWidget {
  const ProfileCompany({super.key});

  @override
  State<ProfileCompany> createState() => _ProfileCompany();
}

class _ProfileCompany extends State<ProfileCompany> {
  _ProfileCompany();

  // Data
  Profiledata? dataUser;
  List<EducationMV> dataEdu = [];
  List<OrganizationMV> dataOrg = [];
  List<WorkexperienceMV> dataWork = [];
  List<CertificateMV> dataCertificate = [];
  List<SkillMV> dataSkill = [];
  List<PreferenceMV> dataPreference = [];

  // Loading state
  bool isLoading = true;
  String? errorMessage;

  // Usecase
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    // _initializeUseCase();
    // _loadProfileData();
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _profileUseCase = ProfileUsecase(repository);
  }

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('idUser');

      if (userId != null) {
        var profile = await _profileUseCase.getProfile(userId);
        if (!mounted) return;

        if (profile != null) {
          setState(() {
            dataUser = profile.user;
            dataEdu = profile.educations ?? [];
            dataOrg = profile.organizations ?? [];
            dataWork = profile.experiences ?? [];
            dataCertificate = profile.certificates ?? [];
            dataSkill = profile.skills ?? [];
            dataPreference = profile.preferences ?? [];
            isLoading = false;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading profile data: $e");
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Error loading profile: $e";
      });
    }
  }

  // Generic method for handling navigation with refresh
  Future<void> _navigateAndRefresh(
    String routeName, {
    Object? arguments,
  }) async {
    final result = await Navigator.of(
      context,
    ).pushNamed(routeName, arguments: arguments);

    if (result == true) {
      await _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         CircularProgressIndicator(),
    //         SizedBox(height: 16),
    //         Text('Loading profile data...'),
    //       ],
    //     ),
    //   );
    // }

    // Show error message if there's an error
    // if (errorMessage != null) {
    //   return Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.error_outline, size: 48, color: Colors.red),
    //         SizedBox(height: 16),
    //         Text(
    //           errorMessage!,
    //           textAlign: TextAlign.center,
    //           style: TextStyle(color: Colors.red),
    //         ),
    //         SizedBox(height: 16),
    //         ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
    //       ],
    //     ),
    //   );
    // }

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
                            context.go("/personalInfoCompany");
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
                            "PT. ASTRA OTOPARTS",
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
                            "Bandung, Jawa Barat",
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

                        Container(
                          child: Text(
                            "Otomotif",
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
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Deskripsi",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black,
                                //letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          child: Text(
                            '''PT Inovasi Digital Nusantara adalah perusahaan teknologi yang berfokus pada pengembangan solusi digital modern untuk mendukung transformasi bisnis di berbagai sektor. Kami menghadirkan layanan yang mencakup pengembangan perangkat lunak, integrasi sistem, hingga konsultasi teknologi informasi dengan tujuan membantu perusahaan meningkatkan efisiensi, keamanan, dan daya saing di era digital.
Dengan tim yang berpengalaman dan berorientasi pada inovasi, kami berkomitmen untuk memberikan produk serta layanan berkualitas tinggi yang sesuai dengan kebutuhan pelanggan. Kepercayaan dan kepuasan klien menjadi prioritas utama kami, sehingga setiap proyek ditangani dengan pendekatan yang profesional, transparan, dan berkelanjutan.
Visi kami adalah menjadi mitra strategis dalam perjalanan digitalisasi, sementara misi kami adalah menciptakan solusi teknologi yang sederhana, efektif, dan bernilai nyata bagi masyarakat maupun dunia usaha.''',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              //letterSpacing: 2,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              ResponsiveRowColumnItem(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Benefit",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black,
                                //letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Icon(
                                        Icons.health_and_safety,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        "BPJS Kesehatan",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Icon(
                                        Icons.money,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        "Salary",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(5.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                      child: Icon(
                                        Icons.monetization_on,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8),
                                      Text(
                                        "Bonus Tahunan",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Available",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
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
                  ),
                ),
              ),

              ResponsiveRowColumnItem(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white60, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      spacing: 20,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "Company Info",
                            textAlign: TextAlign.start,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: Colors.black,
                                //letterSpacing: 2,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.blueAccent,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "Jl. Merdeka No.123, Jakarta, Indonesia",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.green),
                            const SizedBox(width: 10),
                            Text(
                              "+62 812 3456 7890",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            const Icon(Icons.email, color: Colors.redAccent),
                            const SizedBox(width: 10),
                            Text(
                              "contact@company.com",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            const Icon(Icons.public, color: Colors.blueGrey),
                            const SizedBox(width: 10),
                            Text(
                              "www.astra.com",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(Icons.facebook, color: Colors.blue),
                            SizedBox(width: 10),
                            Text(
                              "Astra",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
