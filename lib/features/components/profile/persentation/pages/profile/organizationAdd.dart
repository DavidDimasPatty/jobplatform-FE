import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/organizationModel.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';

import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class OrganizationAdd extends StatefulWidget {
  const OrganizationAdd({super.key});

  @override
  State<OrganizationAdd> createState() => _OrganizationAdd();
}

class _OrganizationAdd extends State<OrganizationAdd> {
  // Controllers
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _locationController = TextEditingController();
  late SelectDataController _selectOrganizationController;
  late SelectDataController _selectSkillController;

  // Global key
  final _formKey = GlobalKey<FormState>();

  // Helper variables
  bool _isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  bool _stillActive = true;
  bool _showAddNewForm = false;

  // Usecase Instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _profileUseCase = ProfileUsecase(repository);
    _selectOrganizationController = SelectDataController(
      data: [],
      isMultiSelect: false,
    );
    _selectSkillController = SelectDataController(data: []);
    _getAllOrganization();
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

  Future _handleAddOrganization() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        late OrganizationModel organization;
        if (_showAddNewForm) {
          organization = OrganizationModel(
            nama: _namaController.text,
            lokasi: _locationController.text,
          );
        } else {
          var selectedItem =
              _selectOrganizationController.selectedList.first.value;

          if (selectedItem is OrganizationModel) {
            organization = selectedItem;
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

        OrganizationRequest newOrganization = OrganizationRequest(
          idUser: idUser,
          organization: organization,
          skill: skill,
          isActive: _stillActive,
          deskripsi: _deskripsiController.text,
          jabatan: _jabatanController.text,
          startDate: startDate!,
          endDate: _stillActive ? null : endDate,
        );

        OrganizationResponse response = await _profileUseCase.addOrganization(
          newOrganization,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Organization added successfully!')),
          );
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add organization. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add organization. Please try again.'),
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

  Future _getAllOrganization({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllOrganization(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> organizationItems = [];

      if (data != null && data.isNotEmpty) {
        organizationItems = data
            .map(
              (organization) => SingleItemCategoryModel(
                nameSingleItem: organization.nama,
                value: organization,
              ),
            )
            .toList();

        // Always add "Add new organization" option
        organizationItems.add(
          SingleItemCategoryModel(
            nameSingleItem: "+ Add new organization",
            value: "add_new_organization", // Special identifier
          ),
        );

        final organizationList = [
          SingleCategoryModel(singleItemCategoryList: organizationItems),
        ];

        setState(() {
          _selectOrganizationController.data = organizationList;
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get organization data. Please try again.'),
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

        // Always add "Add new organization" option
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

        if (actualValue == "add_new_organization") {
          setState(() {
            _showAddNewForm = true;
          });
        } else {
          setState(() {
            _showAddNewForm = false;
          });
          print("Selected organization: ${selectedItem.nameSingleItem}");
        }
      }
    } else {
      setState(() {
        _showAddNewForm = false;
      });
      print("No organization selected");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              "Add Organization",
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
                              key: ValueKey('organization_select'),
                              pillboxTitleSettings: const PillboxTitleSettings(
                                title: 'Organization',
                              ),
                              selectDataController:
                                  _selectOrganizationController,
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
                                  labelText: 'Nama Organisasi',
                                  hintText: 'Masukan Nama Organisasi',
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
                                controller: _locationController,
                                decoration: InputDecoration(
                                  labelText: 'Lokasi Organisasi',
                                  hintText: 'Masukan Lokasi Organisasi',
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
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: _handleAddOrganization,
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.white,
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
