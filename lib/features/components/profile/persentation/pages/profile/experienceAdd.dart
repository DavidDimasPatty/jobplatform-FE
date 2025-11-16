import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ExperienceAdd extends StatefulWidget {
  const ExperienceAdd({super.key});

  @override
  State<ExperienceAdd> createState() => _ExperienceAdd();
}

class _ExperienceAdd extends State<ExperienceAdd> {
  // Controllers
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _divisiController = TextEditingController();
  final _sistemKerjaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _industriController = TextEditingController();
  final _tipeKaryawanController = TextEditingController();
  late SelectDataController _selectExperienceController;
  late SelectDataController _selectSkillController;

  // Global key
  final _formKey = GlobalKey<FormState>();

  // Helper variables
  bool _isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  bool _stillActive = true;
  bool _showAddNewForm = false;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _profileUseCase = ProfileUsecase(repository);
    _selectExperienceController = SelectDataController(
      data: [],
      isMultiSelect: false,
    );
    _selectSkillController = SelectDataController(data: []);
    _getAllExperience();
    _getAllSkill();
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
        // reset endDate kalau endDate < startDate
        if (endDate != null && endDate!.isBefore(startDate!)) {
          endDate = null;
        }
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? (startDate ?? DateTime.now()),
      firstDate: startDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  Future _handleAddExperience() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        late WorkExperienceModel experience;
        if (_showAddNewForm) {
          experience = WorkExperienceModel(
            namaPerusahaan: _namaController.text,
            industri: _industriController.text,
            lokasi: _lokasiController.text,
          );
        } else {
          var selectedItem =
              _selectExperienceController.selectedList.first.value;

          if (selectedItem is WorkExperienceModel) {
            experience = selectedItem;
          }
        }

        // Map selected skills to SkillModel list
        late List<SkillModel> skill;
        var selectedList = _selectSkillController.selectedList;
        if (selectedList.isNotEmpty) {
          skill = selectedList
              .where((item) => item.value is SkillModel)
              .map((item) => item.value as SkillModel)
              .toList();
        } else {
          skill = [];
        }

        WorkExperienceRequest newExperience = WorkExperienceRequest(
          idUser: idUser,
          experience: experience,
          skill: skill,
          bidang: _divisiController.text,
          deskripsi: _deskripsiController.text,
          namaJabatan: _jabatanController.text,
          sistemKerja: _sistemKerjaController.text,
          tipeKaryawan: _tipeKaryawanController.text,
          isActive: _stillActive,
          startDate: startDate!,
          endDate: _stillActive ? null : endDate,
        );

        WorkExperienceResponse response = await _profileUseCase
            .addWorkExperience(newExperience);

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Work Experience added successfully!')),
          );
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add work experience. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add work experience. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future _getAllExperience({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllExperience(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> experienceItems = [];

      if (data != null && data.isNotEmpty) {
        experienceItems = data
            .map(
              (experience) => SingleItemCategoryModel(
                nameSingleItem: experience.namaPerusahaan,
                value: experience,
              ),
            )
            .toList();

        // Always add "Add new experience" option
        experienceItems.add(
          SingleItemCategoryModel(
            nameSingleItem: "+ Add new experience",
            value: "add_new_experience", // Special identifier
          ),
        );

        final experienceList = [
          SingleCategoryModel(singleItemCategoryList: experienceItems),
        ];

        setState(() {
          _selectExperienceController.data = experienceList;
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get experience data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _getAllSkill({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllSkill(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> skillItem = [];

      if (data != null && data.isNotEmpty) {
        skillItem = data
            .map(
              (skill) => SingleItemCategoryModel(
                nameSingleItem: skill.nama,
                value: skill,
              ),
            )
            .toList();

        // Always add "Add new skill" option
        skillItem.add(
          SingleItemCategoryModel(
            nameSingleItem: "+ Add new skill",
            value: "add_new_skill", // Special identifier
          ),
        );

        final skillList = [
          SingleCategoryModel(singleItemCategoryList: skillItem),
        ];

        setState(() {
          _selectSkillController.data = skillList;
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get skill data. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSelectionChanged(dynamic selectedValue) {
    if (selectedValue is List && selectedValue.isNotEmpty) {
      var selectedItem = selectedValue.first;

      if (selectedItem is SingleItemCategoryModel) {
        var actualValue = selectedItem.value;

        if (actualValue == "add_new_experience") {
          setState(() {
            _showAddNewForm = true;
          });
        } else {
          setState(() {
            _showAddNewForm = false;
          });
          print("Selected experience: ${selectedItem.nameSingleItem}");
        }
      }
    } else {
      setState(() {
        _showAddNewForm = false;
      });
      print("No experience selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading experience...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Center(
        child: Container(
          width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
              ? double.infinity
              : MediaQuery.of(context).size.width * 0.45,
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            child: Text(
                              "Add Experience",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                letterSpacing: 2,
                                fontSize: 30,
                              ),
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Select2dot1(
                              key: ValueKey('experience_select'),
                              pillboxTitleSettings: const PillboxTitleSettings(
                                title: 'Experience',
                              ),
                              selectDataController: _selectExperienceController,
                              onChanged: (selectedValue) {
                                _onSelectionChanged(selectedValue);
                              },
                            ),
                          ),

                          if (_showAddNewForm) ...[
                            Container(
                              // height: 90,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextFormField(
                                controller: _namaController,
                                decoration: InputDecoration(
                                  labelText: 'Nama Perusahaan',
                                  hintText: 'Masukan Nama',
                                  prefixIcon: Icon(Icons.text_fields),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 11,
                                  ),
                                ),
                                // initialValue: email,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                              ),
                            ),

                            Container(
                              // height: 90,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextFormField(
                                controller: _industriController,
                                decoration: InputDecoration(
                                  labelText: 'Tipe Industri Perusahaan',
                                  hintText: 'Masukan Industri',
                                  prefixIcon: Icon(Icons.text_fields),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 11,
                                  ),
                                ),
                                // initialValue: email,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                              ),
                            ),

                            Container(
                              // height: 90,
                              margin: EdgeInsets.symmetric(vertical: 20),
                              child: TextFormField(
                                controller: _lokasiController,
                                decoration: InputDecoration(
                                  labelText: 'Lokasi Perusahaan',
                                  hintText: 'Masukan Lokasi',
                                  prefixIcon: Icon(Icons.location_on),
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 11,
                                  ),
                                ),
                                // initialValue: email,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? 'Wajib diisi'
                                    : null,
                              ),
                            ),
                          ],

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _jabatanController,
                              decoration: InputDecoration(
                                labelText: 'Jabatan',
                                hintText: 'Masukan Jabatan',
                                prefixIcon: Icon(Icons.info),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 11,
                                ),
                              ),
                              // initialValue: email,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _divisiController,
                              decoration: InputDecoration(
                                labelText: 'Divisi',
                                hintText: 'Masukan Divisi',
                                prefixIcon: Icon(Icons.info),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 11,
                                ),
                              ),
                              // initialValue: email,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  // height: 90,
                                  //width: 300,
                                  child: TextFormField(
                                    controller: _tipeKaryawanController,
                                    decoration: InputDecoration(
                                      labelText: 'Tipe Karyawan',
                                      hintText: 'Masukan Tipe Karyawan',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.account_circle),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 11,
                                      ),
                                    ),
                                    // initialValue: name,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Wajib diisi'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  // height: 90,
                                  //width: 300,
                                  child: TextFormField(
                                    controller: _sistemKerjaController,
                                    decoration: InputDecoration(
                                      labelText: 'Sistem Kerja',
                                      hintText: 'Masukan Sistem Kerja',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.account_circle),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 11,
                                      ),
                                    ),
                                    // initialValue: name,
                                    validator: (value) =>
                                        value == null || value.isEmpty
                                        ? 'Wajib diisi'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            // height: 90,
                            child: TextFormField(
                              controller: _deskripsiController,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi Pekerjaan',
                                hintText: 'Masukan Deskripsi Pekerjaan',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.description),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 11,
                                ),
                              ),
                              keyboardType: TextInputType.multiline,
                              minLines: 3,
                              maxLines: 5,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Wajib diisi'
                                  : null,
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Select2dot1(
                              key: ValueKey('skill_select'),
                              pillboxTitleSettings: const PillboxTitleSettings(
                                title: 'Skill',
                              ),
                              selectDataController: _selectSkillController,
                            ),
                          ),

                          InkWell(
                            onTap: () => _pickStartDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: "Start Date",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                startDate != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(startDate!)
                                    : "Pilih tanggal",
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: _stillActive,
                                onChanged: (checked) {
                                  setState(() {
                                    _stillActive = checked ?? true;
                                    if (_stillActive) {
                                      endDate = null;
                                    }
                                  });
                                },
                              ),
                              Text('Still Active?'),
                            ],
                          ),
                          if (!_stillActive)
                            InkWell(
                              onTap: startDate == null
                                  ? null
                                  : () => _pickEndDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.calendar_today),
                                  labelText: "End Date",
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  endDate != null
                                      ? DateFormat(
                                          'dd MMMM yyyy',
                                        ).format(endDate!)
                                      : "Pilih tanggal",
                                ),
                              ),
                            ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // ElevatedButton(
                              //   onPressed: _handleSignUp,
                              //   child: Text(
                              //     'Daftar',
                              //     style: TextStyle(color: Colors.black),
                              //   ),
                              // ),
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  onPressed: _handleAddExperience,
                                  icon: Icon(
                                    Icons.check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  label: const Text(
                                    'Submit',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
