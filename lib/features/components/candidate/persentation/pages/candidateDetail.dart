import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/careerPreferenceCandidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/certificateCandidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/educationCandidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/organizationalCandidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/skillCandidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidateDetail/workExperienceCandidate.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Candidatedetail extends StatefulWidget {
  final String? dataId;
  Candidatedetail({super.key, required this.dataId});
  @override
  State<Candidatedetail> createState() => _Candidatedetail();
}

class _Candidatedetail extends State<Candidatedetail> {
  _Candidatedetail();

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
                            //dataUser!.headline,
                            dataUser?.headline ?? "test",
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
                child: WorkexperienceCandidate(
                  dataWork: dataWork,
                  // onAddPressed: () => _navigateAndRefresh('/add-experience'),
                  // onEditPressed: (experience) => _navigateAndRefresh(
                  //   '/edit-experience',
                  //   arguments: experience,
                  // ),
                ),
              ),
              ResponsiveRowColumnItem(
                child: OrganizationalCandidate(dataOrg: dataOrg),
              ),
              ResponsiveRowColumnItem(
                child: EducationCandidate(dataEdu: dataEdu),
              ),
              ResponsiveRowColumnItem(
                child: CertificateCandidate(dataCertificates: dataCertificate),
              ),
              ResponsiveRowColumnItem(
                child: SkillCandidate(dataSkills: dataSkill),
              ),
              ResponsiveRowColumnItem(
                child: CareerPreferenceCandidate(
                  dataPreferences: dataPreference,
                ),
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  //height: 200,
                  child: Column(
                    spacing: 40,
                    children: [
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
                              icon: Icon(Icons.shopping_cart),
                              label: Text("Add To Cart"),
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
                                // padding: EdgeInsets.symmetric(
                                //   vertical: 16,
                                //   horizontal: 14,
                                // ),
                              ),
                              icon: Icon(Icons.favorite),
                              label: Text("Add To Favorites"),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        spacing: 30,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            flex: 4,
                            // height: 40,
                            child: DropdownButtonFormField<String>(
                              value: lowonganSelected,
                              isExpanded: true,
                              hint: Text("Pilih Lowongan Anda"),
                              items: lowongan.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  // const SizedBox(width: 4),
                                  // Flexible(
                                  //   child: Text(
                                  //     country.code,
                                  //     style: const TextStyle(fontSize: 14),
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 4),
                                  // Flexible(
                                  //   child: Text(
                                  //     country.dialCode,
                                  //     style: const TextStyle(fontSize: 14),
                                  //     overflow: TextOverflow.ellipsis,
                                  //   ),
                                  // ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  lowonganSelected = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
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
                                // padding: EdgeInsets.symmetric(
                                //   vertical: 16,
                                //   horizontal: 14,
                                // ),
                              ),
                              icon: Icon(Icons.check),
                              label: Text("Submit"),
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
