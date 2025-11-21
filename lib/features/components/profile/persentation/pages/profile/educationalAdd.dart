import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'dart:ui' as ui;
import 'package:job_platform/features/components/profile/data/models/educationModel.dart';
import 'package:job_platform/features/components/profile/data/models/educationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/educationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EducationalAdd extends StatefulWidget {
  const EducationalAdd({super.key});

  @override
  State<EducationalAdd> createState() => _EducationalAdd();
}

class _EducationalAdd extends State<EducationalAdd> {
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _penjurusanController = TextEditingController();
  final _tingkatController = TextEditingController();
  final _gpaController = TextEditingController();
  final _namaController = TextEditingController();
  late SelectDataController _selectEducationController;
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
    _selectEducationController = SelectDataController(
      data: [],
      isMultiSelect: false,
    );
    _selectSkillController = SelectDataController(data: []);
    _getAllEducation();
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

  Future _handleAddEducation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var storage = StorageService();
        String? idUser = await storage.get('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        late EducationModel education;
        if (_showAddNewForm) {
          education = EducationModel(
            nama: _namaController.text,
            lokasi: _lokasiController.text,
          );
        } else {
          var selectedItem =
              _selectEducationController.selectedList.first.value;

          if (selectedItem is EducationModel) {
            education = selectedItem;
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

        EducationRequest newEducation = EducationRequest(
          idUser: idUser,
          education: education,
          skill: skill,
          deskripsi: _deskripsiController.text,
          tingkat: _tingkatController.text,
          penjurusan: _penjurusanController.text,
          gpa: _gpaController.text,
          isActive: _stillActive,
          startDate: startDate!,
          endDate: _stillActive ? null : endDate,
        );

        EducationResponse response = await _profileUseCase.addEducation(
          newEducation,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Education added successfully!')),
          );
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add education. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add education. Please try again.'),
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

  Future _getAllEducation({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllEducation(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> educationItems = [];

      if (data != null && data.isNotEmpty) {
        educationItems = data
            .map(
              (education) => SingleItemCategoryModel(
                nameSingleItem: education.nama,
                value: education,
              ),
            )
            .toList();

        // Always add "Add new education" option
        educationItems.add(
          SingleItemCategoryModel(
            nameSingleItem: "+ Add new education",
            value: "add_new_education", // Special identifier
          ),
        );

        final educationList = [
          SingleCategoryModel(singleItemCategoryList: educationItems),
        ];

        setState(() {
          _selectEducationController.data = educationList;
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get education data. Please try again.'),
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

        if (actualValue == "add_new_education") {
          setState(() {
            _showAddNewForm = true;
          });
        } else {
          setState(() {
            _showAddNewForm = false;
          });
          print("Selected education: ${selectedItem.nameSingleItem}");
        }
      }
    } else {
      setState(() {
        _showAddNewForm = false;
      });
      print("No education selected");
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
            Text('Loading education...'),
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
                              "Add Education",
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
                              key: ValueKey('education_select'),
                              pillboxTitleSettings: const PillboxTitleSettings(
                                title: 'Education',
                              ),
                              selectDataController: _selectEducationController,
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
                                  labelText: 'Nama Sekolah',
                                  hintText: 'Masukan Nama Sekolah',
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
                                  labelText: 'Lokasi Sekolah',
                                  hintText: 'Masukan Lokasi Sekolah',
                                  prefixIcon: Icon(Icons.location_pin),
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
                              controller: _tingkatController,
                              decoration: InputDecoration(
                                labelText: 'Tingkatan',
                                hintText: 'Masukan Tingkatan',
                                prefixIcon: Icon(Icons.school),
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
                              controller: _penjurusanController,
                              decoration: InputDecoration(
                                labelText: 'Penjurusan',
                                hintText: 'Masukan Penjurusan',
                                prefixIcon: Icon(Icons.local_library),
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
                                    controller: _gpaController,
                                    decoration: InputDecoration(
                                      labelText: 'GPA',
                                      hintText: 'Masukan GPA',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.bar_chart),
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

                          SizedBox(height: 20),
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
                                  onPressed: _handleAddEducation,
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
