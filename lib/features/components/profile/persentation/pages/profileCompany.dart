import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/profileCompanyRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/EducationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileCompanyData.dart';
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
  ProfileCompanydata? dataCompany;
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
      String? idCompany = prefs.getString('idCompany');

      if (idCompany != null) {
        var profile = await _profileUseCase.getProfileCompany(idCompany);
        if (!mounted) return;

        if (profile != null) {
          setState(() {
            dataCompany = profile;
            isLoading = false;
            // isPrivate = profile.user!.privacy ?? false;
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
        String? idUser = prefs.getString('idCompany');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        ProfileCompanyRequest profile = new ProfileCompanyRequest(
          idCompany: idUser,
          logo: bytes,
        );

        ProfileResponse response = await _profileUseCase
            .editProfileAvatarCompany(profile);

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
      String? idUser = prefs.getString('idCompany');

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
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundImage: dataCompany!.logo != null
                                      ? NetworkImage(dataCompany!.logo!)
                                      : AssetImage(
                                          'assets/images/female-avatar.png',
                                        ),
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
                            dataCompany?.nama ?? "",
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
                            dataCompany?.alamat ?? "",
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
                            dataCompany?.industri ?? "",
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
                            dataCompany?.deskripsi ?? "",
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
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: dataCompany?.benefit!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
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
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.white60,
                                        width: 1,
                                      ),
                                      color: Colors.blueAccent,
                                    ),
                                    child: Center(
                                      child: Text(
                                        (index + 1).toString(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
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
                                        dataCompany!.benefit![index],
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
                            );
                          },
                          padding: EdgeInsets.zero,
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
                                dataCompany?.alamat ?? "",
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
                              dataCompany?.noTelp ?? "",
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
                              dataCompany?.email ?? "",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        if (dataCompany?.domain?.isNotEmpty ?? false)
                          Row(
                            children: [
                              const Icon(Icons.public, color: Colors.blueGrey),
                              const SizedBox(width: 10),
                              Text(
                                dataCompany?.domain ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        if (dataCompany?.facebook?.isNotEmpty ?? false)
                          Row(
                            children: [
                              Icon(Icons.facebook, color: Colors.blue),
                              SizedBox(width: 10),
                              Text(
                                dataCompany?.facebook ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        if (dataCompany?.twitter?.isNotEmpty ?? false)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.xTwitter),
                              SizedBox(width: 10),
                              Text(
                                dataCompany?.twitter ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        if (dataCompany?.instagram?.isNotEmpty ?? false)
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.instagram,
                                color: Colors.purpleAccent,
                              ),
                              SizedBox(width: 10),
                              Text(
                                dataCompany?.instagram ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        if (dataCompany?.linkedin?.isNotEmpty ?? false)
                          Row(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.linkedin,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 10),
                              Text(
                                dataCompany?.linkedin ?? "",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),

                        if (dataCompany?.tiktok?.isNotEmpty ?? false)
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.tiktok),
                              SizedBox(width: 10),
                              Text(
                                dataCompany?.tiktok ?? "",
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
