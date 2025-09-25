import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
import 'package:job_platform/features/components/profile/persentation/widgets/profile/careerPreference.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/certificate.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/education.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/organizational.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/skill.dart';
import 'package:job_platform/features/components/profile/persentation/widgets/profile/workExperience.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  _Profile();

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
    _initializeUseCase();
    _loadProfileData();
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
  Future<void> _navigateAndRefresh(String routeName, {Object? arguments}) async {
    final result = await Navigator.of(context).pushNamed(
      routeName,
      arguments: arguments,
    );
    
    if (result == true) {
      await _loadProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profile data...'),
          ],
        ),
      );
    }

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
                            // onTabSelected(3);
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
                            dataUser!.nama,
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
                            dataUser!.headline,
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
                  onAddPressed: () => _navigateAndRefresh('/add-experience'),
                  onEditPressed: (experience) => _navigateAndRefresh('/edit-experience', arguments: experience)
                ),
              ),
              ResponsiveRowColumnItem(
                child: Organizational(
                  dataOrg: dataOrg,
                  onAddPressed: () => _navigateAndRefresh('/add-organization'),
                  onEditPressed: (organization) => _navigateAndRefresh('/edit-organization', arguments: organization)
                ),
              ),
              ResponsiveRowColumnItem(
                child: Education(
                  dataEdu: dataEdu,
                  onAddPressed: () => _navigateAndRefresh('/add-education'),
                  onEditPressed: (education) => _navigateAndRefresh('/edit-education', arguments: education)
                ),
              ),
              ResponsiveRowColumnItem(
                child: Certificate(
                  dataCertificates: dataCertificate,
                  onAddPressed: () => _navigateAndRefresh('/add-certificate'),
                  onEditPressed: (certificate) => _navigateAndRefresh('/edit-certificate', arguments: certificate)
                ),
              ),
              ResponsiveRowColumnItem(
                child: Skill(
                  dataSkills: dataSkill,
                  // onTabSelected: onTabSelected,
                ),
              ),
              ResponsiveRowColumnItem(
                child: CareerPreference(dataPreferences: dataPreference),
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
