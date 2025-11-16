import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/CertificateMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CertificateEdit extends StatefulWidget {
  final CertificateMV certificate;

  const CertificateEdit({super.key, required this.certificate});

  @override
  _CertificateEditState createState() =>
      _CertificateEditState(data: certificate);
}

class _CertificateEditState extends State<CertificateEdit> {
  final CertificateMV data;

  _CertificateEditState({required this.data});

  // Form key
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController _certificateNameController =
      TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _issuedByController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _credentialIdController = TextEditingController();
  final TextEditingController _credentialUrlController =
      TextEditingController();
  late SelectDataController _selectSkillController;

  // Helper variables
  bool _isLoading = false;
  DateTime? _selectedIssueDate;
  bool _hasExpiredDate = false;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _getAllSkill();
    _loadData();
  }

  @override
  void dispose() {
    _certificateNameController.dispose();
    _descriptionController.dispose();
    _issuedByController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    _credentialIdController.dispose();
    _credentialUrlController.dispose();
    super.dispose();
  }

  void _loadData() {
    _certificateNameController.text = data.certificate.nama;
    _issuedByController.text = data.certificate.publisher;
    _descriptionController.text = data.deskripsi ?? '';
    _issueDateController.text = DateFormat(
      'dd MMMM yyyy',
    ).format(data.publishDate);

    _hasExpiredDate = data.expiredDate != null;
    if (_hasExpiredDate) {
      _expiryDateController.text = DateFormat(
        'dd MMMM yyyy',
      ).format(data.expiredDate!);
    }
    _credentialIdController.text = data.code!;
    _credentialUrlController.text = data.codeURL!;
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _profileUseCase = ProfileUsecase(repository);
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

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        // Format dates to 'yyyy-MM-dd'
        final issueDate = DateFormat('yyyy-MM-dd').format(
          DateFormat('dd MMMM yyyy', 'en_US').parse(_issueDateController.text),
        );
        var expiryDate;
        if (_hasExpiredDate) {
          expiryDate = DateFormat('yyyy-MM-dd').format(
            DateFormat(
              'dd MMMM yyyy',
              'en_US',
            ).parse(_expiryDateController.text),
          );
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

        CertificateRequest editedCertificate = CertificateRequest(
          idUser: idUser,
          idUserCertificate: data.id,
          certificate: data.certificate,
          deskripsi: _descriptionController.text,
          skill: skill,
          publishDate: DateTime.parse(issueDate),
          expiredDate: _hasExpiredDate ? DateTime.parse(expiryDate) : null,
          code: _credentialIdController.text,
          codeURL: _credentialUrlController.text,
        );

        CertificateResponse response = await _profileUseCase.editCertificate(
          editedCertificate,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate edited successfully!')),
          );
          context.go('/profile');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to edit certificate. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit certificate. Please try again.'),
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

  Future<void> _deleteCertificate() async {
    setState(() {
      _isLoading = true;
    });

    try {
      CertificateResponse response = await _profileUseCase.deleteCertificate(
        data.id,
      );

      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Certificate deleted successfully!')),
        );
        context.go('/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete certificate. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete certificate. Please try again.'),
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
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading certificate...'),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
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
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          'Edit Certificate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildTextField(
                        'Certificate Name',
                        _certificateNameController,
                        Icons.school,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter certificate name';
                          }
                          return null;
                        },
                      ),
                      buildTextField(
                        'Issued By',
                        _issuedByController,
                        Icons.person,
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter issuer';
                          }
                          return null;
                        },
                      ),
                      buildTextField(
                        'Description',
                        _descriptionController,
                        Icons.description,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                      ),
                      buildDropdownField(
                        'skill-select',
                        'Skill',
                        _selectSkillController,
                      ),
                      buildDateField(
                        'Issue Date',
                        _issueDateController,
                        (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter issue date';
                          }
                          return null;
                        },
                        context,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedIssueDate = date;
                            _issueDateController.text = date != null
                                ? DateFormat('dd MMMM yyyy').format(date)
                                : '';
                            if (_expiryDateController.text.isNotEmpty &&
                                _selectedIssueDate != null &&
                                DateTime.tryParse(_expiryDateController.text) !=
                                    null &&
                                DateTime.parse(
                                  _expiryDateController.text,
                                ).isBefore(_selectedIssueDate!)) {
                              _expiryDateController.clear();
                            }
                          });
                        },
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: _hasExpiredDate,
                            onChanged: (checked) {
                              setState(() {
                                _hasExpiredDate = checked ?? false;
                                if (!_hasExpiredDate) {
                                  _expiryDateController.clear();
                                }
                              });
                            },
                          ),
                          Text('Has Expiry Date'),
                        ],
                      ),
                      if (_hasExpiredDate)
                        buildDateField(
                          'Expiry Date',
                          _expiryDateController,
                          (value) {
                            return null;
                          },
                          context,
                          firstDate: _selectedIssueDate,
                        ),
                      buildTextField(
                        'Credential ID',
                        _credentialIdController,
                        Icons.vpn_key,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter credential ID';
                          }
                          return null;
                        },
                      ),
                      buildTextField(
                        'Credential URL',
                        _credentialUrlController,
                        Icons.link,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter credential URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton.icon(
                                  onPressed: _showSimpleDeleteConfirmation,
                                  label: Text(
                                    'Delete',
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
                                ElevatedButton.icon(
                                  onPressed: _submitForm,
                                  icon: Icon(Icons.check),
                                  iconAlignment: IconAlignment.end,
                                  label: Text('Submit'),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
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

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData prefixIcon, {
    int maxLines = 1,
    bool readOnly = false,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: readOnly,
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

  Widget buildDropdownField(
    String key,
    String label,
    SelectDataController controller, {
    void Function(dynamic)? onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Select2dot1(
        key: ValueKey(key),
        pillboxTitleSettings: PillboxTitleSettings(title: label),
        selectDataController: controller,
        onChanged: onChange,
      ),
    );
  }

  Widget buildDateField(
    String label,
    TextEditingController controller,
    String? Function(String?) validator,
    BuildContext context, {
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

  void _showSimpleDeleteConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Certificate',
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
                  'Are you sure you want to delete this certificate?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                              widget.certificate.certificate.nama,
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
                            child: Text(
                              widget.certificate.certificate.publisher,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '⚠️ This action is permanent and cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
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
              label: Text('Cancel'),
              style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteCertificate();
              },
              icon: Icon(Icons.delete, size: 16),
              label: Text('Delete'),
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
