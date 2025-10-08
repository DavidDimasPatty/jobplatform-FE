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
import 'package:responsive_framework/responsive_framework.dart';

class Progressdetail extends StatefulWidget {
  final String? dataId;
  Progressdetail({super.key, required this.dataId});
  @override
  State<Progressdetail> createState() => _Progressdetail();
}

class _Progressdetail extends State<Progressdetail> {
  _Progressdetail();

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
  int stepsImpl = 0;
  List<String> steps = [];
  // Usecase
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _loadProfileData();
    steps = ["Review", "Interview", "Offering", "Close"];
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
          decoration: BoxDecoration(
            color: Colors.white,
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
          child: Padding(
            padding: EdgeInsets.all(20),
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
                          // child: IconButton(
                          //   icon: const Icon(
                          //     Icons.edit,
                          //     color: Colors.white,
                          //     size: 20,
                          //   ),
                          //   onPressed: () {
                          //     // onTabSelected(3);
                          //   },
                          // ),
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

                                // Positioned(
                                //   right: 0,
                                //   bottom: 0,
                                //   child: Container(
                                //     height: 30,
                                //     width: 30,
                                //     decoration: const BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       color: Colors.grey,
                                //     ),
                                //     // child: IconButton(
                                //     //   icon: const Icon(
                                //     //     Icons.camera_alt,
                                //     //     color: Colors.white,
                                //     //     size: 20,
                                //     //   ),
                                //     //   padding: EdgeInsets.zero,
                                //     //   constraints: const BoxConstraints(),
                                //     //   onPressed: () {
                                //     //     print("Ganti foto profil diklik");
                                //     //   },
                                //     // ),
                                //   ),
                                // ),
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
                  child: WorkexperienceProgress(
                    dataWork: dataWork,
                    // onAddPressed: () => _navigateAndRefresh('/add-experience'),
                    // onEditPressed: (experience) => _navigateAndRefresh(
                    //   '/edit-experience',
                    //   arguments: experience,
                    // ),
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: OrganizationalProgress(dataOrg: dataOrg),
                ),
                ResponsiveRowColumnItem(
                  child: EducationProgress(dataEdu: dataEdu),
                ),
                ResponsiveRowColumnItem(
                  child: CertificateProgress(dataCertificates: dataCertificate),
                ),
                ResponsiveRowColumnItem(
                  child: SkillProgress(dataSkills: dataSkill),
                ),
                ResponsiveRowColumnItem(
                  child: CareerPreferenceProgress(
                    dataPreferences: dataPreference,
                  ),
                ),
                ResponsiveRowColumnItem(
                  child: Container(
                    //height: 200,
                    child: Column(
                      spacing: 40,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            bool isMobile = ResponsiveBreakpoints.of(
                              context,
                            ).smallerThan(TABLET);
                            if (!isMobile) {
                              return SizedBox(
                                width: 800,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      child: Text(
                                        "Proses Rekrutment",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.davidLibre(
                                          textStyle: TextStyle(
                                            color: Colors.blue,
                                            letterSpacing: 2,
                                            fontSize: 25,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(
                                        steps.length * 2 - 1,
                                        (index) {
                                          if (index.isEven) {
                                            int stepIndex = index ~/ 2;
                                            return Container(
                                              margin: EdgeInsets.only(top: 60),
                                              child: Column(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        stepsImpl >= stepIndex
                                                        ? Colors.blue
                                                        : Colors.grey.shade200,
                                                    child: Text(
                                                      "${stepIndex + 1}",
                                                      style: TextStyle(
                                                        color:
                                                            stepsImpl >=
                                                                stepIndex
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    height: 60,
                                                    margin: EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    child: Text(
                                                      steps[stepIndex],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: GoogleFonts.ptSerif(
                                                        textStyle: TextStyle(
                                                          color:
                                                              stepsImpl >=
                                                                  stepIndex
                                                              ? Colors.blue
                                                              : Colors
                                                                    .grey
                                                                    .shade600,
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
                                        },
                                      ),
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
                                      "Proses Rekrutment",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.davidLibre(
                                        textStyle: TextStyle(
                                          color: Colors.blue,
                                          letterSpacing: 2,
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
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
                                              backgroundColor:
                                                  stepsImpl >= index
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

                        Row(
                          spacing: 40,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                                  // padding: EdgeInsets.symmetric(
                                  //   vertical: 16,
                                  //   horizontal: 14,
                                  // ),
                                ),
                                icon: Icon(Icons.check),
                                label: Text("Accept (Offering)"),
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
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: Size(
                                    MediaQuery.of(context).size.width * 0.4,
                                    60,
                                  ),
                                  // padding: EdgeInsets.symmetric(
                                  //   vertical: 16,
                                  //   horizontal: 14,
                                  // ),
                                ),
                                icon: Icon(Icons.close),
                                label: Text("Reject"),
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
      ),
    );
  }
}
