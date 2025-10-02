import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/profileRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/domain/entities/SkillMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/persentation/pages/personalInfo.dart';
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
  bool isPrivate = false;

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
            isPrivate = profile.user!.privacy ?? false;
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

  Future _editProfileAvatar() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        Uint8List? bytes;

        // Get bytes (works for both web and mobile)
        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          bytes = await File(file.path!).readAsBytes();
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        ProfileRequest profile = new ProfileRequest(
          idUser: idUser,
          photo: bytes,
        );

        ProfileResponse response = await _profileUseCase.editProfileAvatar(
          profile,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile avatar updated successfully!')),
          );
          _loadProfileData();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to update profile avatar. Please try again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error during edit profile avatar: $e');
      // Show error message to user
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile avatar. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future _editProfilePrivacy(bool value) async {
    setState(() {
      isPrivate = value;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString('idUser');

      // Ensure idUser is not null
      if (idUser == null) throw Exception("User ID not found in preferences");

      ProfileRequest profile = new ProfileRequest(
        idUser: idUser,
        privacy: isPrivate,
      );

      ProfileResponse response = await _profileUseCase.editProfilePrivacy(
        profile,
      );

      // On success, clear the form or navigate away
      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile privacy edited successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit profile privacy. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during edit profile privacy: $e');
      // Show error message to user
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit profile privacy. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                          onPressed: () =>
                              context.go('/edit-profile', extra: dataUser!),
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
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundImage: dataUser!.photoURL != null
                                      ? NetworkImage(dataUser!.photoURL!)
                                      : (dataUser!.jenisKelamin == "L"
                                            ? AssetImage(
                                                'assets/images/male-avatar.png',
                                              )
                                            : AssetImage(
                                                'assets/images/female-avatar.png',
                                              )),
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
                                    onPressed: () => _editProfileAvatar(),
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
                child: Workexperience(
                  dataWork: dataWork,
                  onAddPressed: () => context.go('/add-experience'),
                  onEditPressed: (experience) =>
                      context.go('/edit-experience', extra: experience),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Organizational(
                  dataOrg: dataOrg,
                  onAddPressed: () => context.go('/add-organization'),
                  onEditPressed: (organization) =>
                      context.go('/edit-organization', extra: organization),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Education(
                  dataEdu: dataEdu,
                  onAddPressed: () => context.go('/add-education'),
                  onEditPressed: (education) =>
                      context.go('/edit-education', extra: education),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Certificate(
                  dataCertificates: dataCertificate,
                  onAddPressed: () => context.go('/add-certificate'),
                  onEditPressed: (certificate) =>
                      context.go('/edit-certificate', extra: certificate),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Skill(
                  dataSkills: dataSkill,
                  // onTabSelected: onTabSelected,
                ),
              ),
              ResponsiveRowColumnItem(
                child: CareerPreference(
                  dataPreferences: dataPreference,
                  onAddPressed: () => context.go('/add-preference'),
                  onEditPressed: (preference) =>
                      context.go('/edit-preference', extra: preference),
                ),
              ),
              ResponsiveRowColumnItem(
                child: Container(
                  height: 300,
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.lock),
                        title: Text("Private Profile"),
                        trailing: Switch(
                          trackColor: const WidgetStateProperty<Color?>.fromMap(
                            <WidgetState, Color>{
                              WidgetState.selected: Colors.lightBlue,
                            },
                          ),
                          value: isPrivate,
                          onChanged: (bool value) => _editProfilePrivacy(value),
                        ),
                      ),
                      Divider(height: 1, thickness: 1),
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
