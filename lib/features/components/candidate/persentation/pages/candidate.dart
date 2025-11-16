import 'package:flutter/material.dart';
import 'package:job_platform/features/components/candidate/domain/entities/candidate.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateBody.dart';
import 'package:job_platform/features/components/candidate/persentation/widget/candidate/candidateHeader.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:intl/intl.dart';

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
  // Controllers for form fields
  final TextEditingController _salaryMinController = TextEditingController();
  final TextEditingController _salaryMaxController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _jobTypeController = TextEditingController();
  final TextEditingController _workSystemController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _careerLevelController = TextEditingController();
  final TextEditingController _availabilityController = TextEditingController();

  // Helper variables
  bool _isLoading = false;
  int minSalary = 0;
  int maxSalary = 0;

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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData prefixIcon, {
    int maxLines = 1,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        maxLines: maxLines,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildDateField(
    String label,
    TextEditingController controller,
    BuildContext context, {
    required String? Function(String?) validator,
    bool enabled = true,
    DateTime? firstDate,
    void Function(DateTime?)? onDateSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.calendar_today),
        ),
        validator: validator,
        onTap: enabled
            ? () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: firstDate ?? DateTime.now(),
                  firstDate: firstDate ?? DateTime(1900),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  controller.text = DateFormat(
                    'dd MMMM yyyy',
                  ).format(pickedDate);
                  if (onDateSelected != null) onDateSelected(pickedDate);
                }
              }
            : null,
      ),
    );
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      context: context,
      builder: (context) {
        String? tempSelectedRole = selectedRole;
        String? ValueEndRole = "";
        return StatefulBuilder(
          builder: (context, setStateSheet) => Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Position
                  Column(
                    children: [
                      Text(
                        "Filter by Position",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                    ],
                  ),
                  //Sistem Kerja
                  Column(
                    children: [
                      Text(
                        "Sistem Kerja",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                        title: const Text("WFH"),
                        value: "WFH",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Hybrid"),
                        value: "Hybrid",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("WFO"),
                        value: "WFO",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                    ],
                  ),
                  //Tipe Kerja
                  Column(
                    children: [
                      Text(
                        "Tipe Kerja",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                        title: const Text("Kontrak"),
                        value: "Kontrak",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Magang"),
                        value: "Magang",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text("Full Time"),
                        value: "Full Time",
                        groupValue: tempSelectedRole,
                        onChanged: (value) {
                          setStateSheet(() => tempSelectedRole = value);
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Range Gaji",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          'Min Salary Expectation',
                          _salaryMinController,
                          Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter minimum salary';
                            } else if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            minSalary = int.parse(value);
                            if (minSalary < 0) {
                              return 'Salary cannot be negative';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Text('-'),
                      SizedBox(width: 10),
                      Expanded(
                        child: buildTextField(
                          'Max Salary Expectation',
                          _salaryMaxController,
                          Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter maximum salary';
                            } else if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            maxSalary = int.parse(value);
                            if (maxSalary < 0) {
                              return 'Salary cannot be negative';
                            } else if (maxSalary < minSalary) {
                              return 'Max salary must be greater than min salary';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  buildTextField(
                    'Location',
                    _locationController,
                    Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location';
                      }
                      return null;
                    },
                  ),
                  buildTextField(
                    'Career Level',
                    _careerLevelController,
                    Icons.trending_up,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter career level';
                      }
                      return null;
                    },
                  ),
                  buildDateField(
                    'Availability',
                    _availabilityController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter availability';
                      }
                      return null;
                    },
                    context,
                    onDateSelected: (date) {
                      _availabilityController.text = date != null
                          ? DateFormat('dd MMMM yyyy').format(date)
                          : '';
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text("Apply"),
                    icon: const Icon(Icons.filter),
                    onPressed: () {
                      ValueEndRole = tempSelectedRole;
                      Navigator.pop(context, ValueEndRole);
                    },
                  ),
                ],
              ),
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
            color: Theme.of(context).colorScheme.primary,
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
