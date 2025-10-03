import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/careerPreferenceProgress.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/certificateCandidateProgress.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/educationProgress.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/organizationalProgress.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/skillProgress.dart';
import 'package:job_platform/features/components/progress/persentation/widgets/detail/workExperienceProgress.dart';
import 'package:job_platform/features/components/statusJob/persentation/widgets/statusJobDetail/statusJobDetailMore.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Statusjobdetail extends StatefulWidget {
  final String? dataId;
  Statusjobdetail({super.key, required this.dataId});
  @override
  State<Statusjobdetail> createState() => _Statusjobdetail();
}

class _Statusjobdetail extends State<Statusjobdetail> {
  _Statusjobdetail();

  // Data
  Profiledata? dataUser;
  List<EducationMV> dataEdu = [];
  List<OrganizationMV> dataOrg = [];
  List<WorkexperienceMV> dataWork = [];
  List<CertificateMV> dataCertificate = [];
  List<SkillMV> dataSkill = [];
  List<PreferenceMV> dataPreference = [];
  List<String> lowongan = ["Back End", "Front End", "Bussines Analyst"];
  // Loading state
  bool isLoading = true;
  String? errorMessage;
  String? lowonganSelected;

  // Usecase
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _loadProfileData();
  }

  void _initializeUseCase() {
    // final dataSource = AuthRemoteDataSource();
    // final repository = AuthRepositoryImpl(dataSource);
    // _profileUseCase = ProfileUsecase(repository);
  }

  Future<void> _loadProfileData() async {
    // try {
    //   setState(() {
    //     isLoading = true;
    //     errorMessage = null;
    //   });
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String? userId = prefs.getString('idUser');

    //   if (userId != null) {
    //     var profile = await _profileUseCase.getProfile(userId);
    //     if (!mounted) return;

    //     if (profile != null) {
    //       setState(() {
    //         dataUser = profile.user;
    //         dataEdu = profile.educations ?? [];
    //         dataOrg = profile.organizations ?? [];
    //         dataWork = profile.experiences ?? [];
    //         dataCertificate = profile.certificates ?? [];
    //         dataSkill = profile.skills ?? [];
    //         dataPreference = profile.preferences ?? [];
    //         isLoading = false;
    //       });
    //     }
    //   } else {
    //     print("User ID not found in SharedPreferences");
    //   }
    // } catch (e) {
    //   print("Error loading profile data: $e");
    //   if (!mounted) return;

    //   setState(() {
    //     isLoading = false;
    //     errorMessage = "Error loading profile: $e";
    //   });
    // }
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
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
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
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.blueAccent,
                      ),
                    ),
                    Positioned(right: 10, top: 0, child: Container()),
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
                            ],
                          ),
                        ),

                        Container(
                          child: Text(
                            dataUser?.nama != null ? dataUser!.nama : "test",
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
                            dataUser?.headline ?? '',
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
                child: statusJobDetailMore(dataPreferences: dataPreference),
              ),

              ResponsiveRowColumnItem(
                child: Container(
                  child: Column(
                    spacing: 40,
                    children: [
                      Row(
                        spacing: 40,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 3,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  60,
                                ),
                              ),
                              icon: Icon(Icons.check),
                              label: Text("Accept"),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  60,
                                ),
                              ),
                              icon: Icon(Icons.close),
                              label: Text("Reject"),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.4,
                                  60,
                                ),
                              ),
                              icon: Icon(Icons.chat),
                              label: Text("Chat"),
                            ),
                          ),
                        ],
                      ),
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
