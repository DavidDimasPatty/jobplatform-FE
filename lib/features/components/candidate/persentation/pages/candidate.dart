import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateBody.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateHeader.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatBody.dart';
import 'package:job_platform/features/components/chat/persentasion/widget/chat/chatItems.dart';
import 'package:job_platform/features/components/login/persentation/widgets/loginForm.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/bodySetting.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/settingGroup.dart'
    show SettingsGroup;
import 'package:job_platform/features/components/setting/persentation/widgets/settingItem.dart';
import 'package:job_platform/features/components/setting/persentation/widgets/topSetting.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Candidate extends StatefulWidget {
  Candidate({super.key});

  @override
  State<Candidate> createState() => _Candidate();
}

class _Candidate extends State<Candidate> {
  List<CandidateItems> dataCandidate = [];
  List<CandidateItems> dumpCandidate = [];
  String searchQuery = "";
  String? selectedRole;
  final searchController = TextEditingController();
  // Loading state
  bool isLoading = true;
  String? errorMessage;
  Future<void> _loadProfileData() async {
    try {
      // setState(() {
      //   isLoading = true;
      //   errorMessage = null;
      // });
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('idUser');

      // if (userId != null) {
      //   var profile = await _profileUseCase.getProfile(userId);
      //   if (profile != null) {
      //     setState(() {
      //       dataUser = profile.user;
      //       dataEdu = profile.educations ?? [];
      //       dataOrg = profile.organizations ?? [];
      //       dataWork = profile.experiences ?? [];
      //       dataCertificate = profile.certificates ?? [];
      //       dataSkill = profile.skills ?? [];
      //       dataPreference = profile.preferences ?? [];
      //       isLoading = false;
      //     });
      //   }
      // } else {
      //   print("User ID not found in SharedPreferences");
      // }
      setState(() {
        isLoading = false;
        errorMessage = null;
        dataCandidate = [
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "David Dimas Patty",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Developer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Nando",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Designer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Daniel",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Designer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Krisna",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Designer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Rulof",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Developer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Ronald",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Developer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Yuan",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Developer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Inez",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Designer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Angel",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Developer",
          ),
          CandidateItems(
            id: "1",
            domisili: "Bandung, Jawa Barat",
            nama: "Dimas",
            photoUrl: "assets/images/BG_Pelamar.png",
            score: "90",
            umur: "24",
            role: "Designer",
          ),
        ];
        dumpCandidate = List.from(dataCandidate);
      });
    } catch (e) {
      print("Error loading profile data: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = "Error loading profile: $e";
        });
      }
    }
  }

  void _applyFilter() {
    setState(() {
      if ((searchQuery.isEmpty || searchQuery.trim().isEmpty) &&
          selectedRole == null) {
        dumpCandidate = List.from(dataCandidate);
        return;
      }

      dumpCandidate = dataCandidate.where((candidate) {
        final matchSearch =
            candidate.nama?.toLowerCase().contains(searchQuery.toLowerCase()) ??
            false;
        final matchRole =
            selectedRole == null || candidate.role == selectedRole;
        return matchSearch && matchRole;
      }).toList();
    });
  }

  void _onSearchChanged(String value) {
    searchQuery = value;
    _applyFilter();
  }

  void _openFilterPopup() async {
    final result = await showModalBottomSheet<String?>(
      context: context,
      builder: (context) {
        String? tempSelectedRole = selectedRole;
        String? ValueEndRole = "";
        return StatefulBuilder(
          builder: (context, setStateSheet) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Filter by Role",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                RadioListTile<String>(
                  title: const Text("All"),
                  value: "",
                  groupValue: tempSelectedRole ?? "",
                  onChanged: (value) {
                    setStateSheet(
                      () => tempSelectedRole = value == "" ? null : value,
                    );
                  },
                ),
                RadioListTile<String>(
                  title: const Text("Developer"),
                  value: "Developer",
                  groupValue: tempSelectedRole,
                  onChanged: (value) {
                    setStateSheet(() => tempSelectedRole = value);
                  },
                ),
                RadioListTile<String>(
                  title: const Text("Designer"),
                  value: "Designer",
                  groupValue: tempSelectedRole,
                  onChanged: (value) {
                    setStateSheet(() => tempSelectedRole = value);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ValueEndRole = tempSelectedRole;
                    Navigator.pop(context, ValueEndRole);
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      selectedRole = result;
      _applyFilter();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
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
            Text('Loading Setting data...'),
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
            // ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height * 0.8,
          ),
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
                child: Candidateheader(
                  searchController: searchController,
                  onSearchChanged: _onSearchChanged,
                  onFilterTap: _openFilterPopup,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Candidatebody(items: dumpCandidate),
              ),
              // ResponsiveRowColumnItem(rowFlex: 2, child: bodySetting()),
            ],
          ),
        ),
      ),
    );
  }
}
