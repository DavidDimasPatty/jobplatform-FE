import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/domain/entities/OrganizationMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:intl/intl.dart';

class OrganizationEdit extends StatefulWidget {
  final OrganizationMV organization;

  const OrganizationEdit({super.key, required this.organization});

  @override
  State<OrganizationEdit> createState() =>
      _OrganizationEdit(data: organization);
}

class _OrganizationEdit extends State<OrganizationEdit> {
  final OrganizationMV data;

  _OrganizationEdit({required this.data});

  // Controllers
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  late SelectDataController _selectSkillController;

  // Global key
  final _formKey = GlobalKey<FormState>();

  // Helper variables
  bool _isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  bool _stillActive = true;
  double? header, subHeader, body, icon;

  // Usecase Instance
  late ProfileUsecase _profileUseCase;

  // Service
  final storage = StorageService();

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _profileUseCase = ProfileUsecase(repository);
    _initializeFontSize();
    _getAllSkill();
    _loadData();
  }

  void _loadData() {
    _namaController.text = data.organization.nama;
    _jabatanController.text = data.jabatan ?? '';
    _deskripsiController.text = data.deskripsi ?? '';
    startDate = data.startDate;

    _stillActive = data.endDate == null;
    if (!_stillActive) {
      endDate = data.endDate;
    }
  }

  Future<void> _initializeFontSize() async {
    header = await storage.get("fontSizeHead") as double;
    subHeader = await storage.get("fontSizeSubHead") as double;
    body = await storage.get("fontSizeBody") as double;
    icon = await storage.get("fontSizeIcon") as double;
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
            nameSingleItem: "+ Add new skill".tr(),
            value: "add_new_skill", // Special identifier
          ),
        );

        final skillList = [
          SingleCategoryModel(singleItemCategoryList: skillItem),
        ];

        // Find matching items by comparing a unique property
        var initSelectedItems = this.data.skill.map((userSkill) {
          return skillItem.firstWhere(
            (skillItem) => skillItem.value.idSkill == userSkill.idSkill,
            orElse: () => SingleItemCategoryModel(
              nameSingleItem: userSkill.nama,
              value: userSkill,
            ),
          );
        }).toList();

        setState(() {
          _selectSkillController = SelectDataController(
            data: skillList,
            initSelected: initSelectedItems,
          );
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get skill data. Please try again.'.tr()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _handleEditOrganization() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        var storage = StorageService();
        String? idUser = await storage.get('idUser');

        // Ensure idUser is not null
        if (idUser == null)
          throw Exception("User ID not found in preferences".tr());

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

        OrganizationRequest editedOrganization = OrganizationRequest(
          idUser: idUser,
          idUserOrganization: data.id,
          organization: data.organization,
          skill: skill,
          isActive: _stillActive,
          deskripsi: _deskripsiController.text,
          jabatan: _jabatanController.text,
          startDate: startDate!,
          endDate: _stillActive ? null : endDate,
        );

        OrganizationResponse response = await _profileUseCase.editOrganization(
          editedOrganization,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Organization editted successfully!'.tr())),
          );
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to edit organization. Please try again.'.tr(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        print(e);
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to edit organization. Please try again.'.tr(),
            ),
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

  Future _handleDeleteOrganization() async {
    setState(() {
      _isLoading = true;
    });

    try {
      OrganizationResponse response = await _profileUseCase.deleteOrganization(
        data.id,
      );

      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Organization deleted successfully!'.tr())),
        );
        context.go('/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete organization. Please try again.'.tr(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to delete organization. Please try again.'.tr(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading organization...'.tr()),
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
                              "Edit Organization".tr(),
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
                            child: TextFormField(
                              readOnly: true,
                              controller: _namaController,
                              decoration: InputDecoration(
                                labelText: 'Nama Organisasi'.tr(),
                                hintText: 'Masukan Nama Organisasi'.tr(),
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
                                  ? 'Wajib diisi'.tr()
                                  : null,
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _jabatanController,
                              decoration: InputDecoration(
                                labelText: 'Jabatan'.tr(),
                                hintText: 'Masukan Jabatan'.tr(),
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
                                  ? 'Wajib diisi'.tr()
                                  : null,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            // height: 90,
                            child: TextFormField(
                              controller: _deskripsiController,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi Pekerjaan'.tr(),
                                hintText: 'Masukan Deskripsi Pekerjaan'.tr(),
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
                                  ? 'Wajib diisi'.tr()
                                  : null,
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Select2dot1(
                              key: ValueKey('skill_select'),
                              pillboxTitleSettings: PillboxTitleSettings(
                                title: 'Skill'.tr(),
                              ),
                              selectDataController: _selectSkillController,
                            ),
                          ),

                          InkWell(
                            onTap: () => _pickStartDate(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: "Start Date".tr(),
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                startDate != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(startDate!)
                                    : "Pilih tanggal".tr(),
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
                              Text('Still Active?'.tr()),
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
                                  labelText: "End Date".tr(),
                                  border: OutlineInputBorder(),
                                ),
                                child: Text(
                                  endDate != null
                                      ? DateFormat(
                                          'dd MMMM yyyy',
                                        ).format(endDate!)
                                      : "Pilih tanggal".tr(),
                                ),
                              ),
                            ),

                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: _showSimpleDeleteConfirmation,
                                label: Text(
                                  'Delete'.tr(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor: Colors.grey,
                                  shadowColor: Colors.transparent,
                                  surfaceTintColor: Colors.transparent,
                                ),
                              ),
                              SizedBox(width: 20),
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                  onPressed: _handleEditOrganization,
                                  icon: Icon(
                                    Icons.check,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                  label: Text(
                                    'Submit'.tr(),
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

  void _showSimpleDeleteConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Organization'.tr(),
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning icon
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Are you sure you want to delete this organization?'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: subHeader, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.title, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.organization.organization.nama,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.business, size: 16, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('${widget.organization.jabatan}'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '⚠️ This action is permanent and cannot be undone.'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: body,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.close, size: 16),
              label: Text('Cancel'.tr()),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _handleDeleteOrganization();
              },
              icon: Icon(Icons.delete, size: 16),
              label: Text('Delete'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
