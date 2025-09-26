import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateRequest.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/models/skillModel.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:select2dot1/select2dot1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CertificateAdd extends StatefulWidget {
  const CertificateAdd({super.key});

  @override
  _CertificateAddState createState() => _CertificateAddState();
}

class _CertificateAddState extends State<CertificateAdd> {
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
  late SelectDataController _selectCertificateController;
  late SelectDataController _selectSkillController;

  // Helper variables
  bool _isLoading = false;
  DateTime? _selectedIssueDate;
  bool _hasExpiredDate = false;
  bool _showAddNewForm = false;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _initializeSelectController();
    _getAllCertification();
    _getAllSkill();
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

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _profileUseCase = ProfileUsecase(repository);
  }

  void _initializeSelectController() {
    _selectCertificateController = SelectDataController(
      data: [],
      isMultiSelect: false,
    );
    _selectSkillController = SelectDataController(data: []);
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

        // Certificate
        late CertificateModel certificate;
        if (_showAddNewForm) {
          certificate = CertificateModel(
            nama: _certificateNameController.text,
            publisher: _issuedByController.text,
          );
        } else {
          var selectedItem =
              _selectCertificateController.selectedList.first.value;

          if (selectedItem is CertificateModel) {
            certificate = selectedItem;
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

        CertificateRequest newCertificate = CertificateRequest(
          idUser: idUser,
          certificate: certificate,
          deskripsi: _descriptionController.text,
          skill: skill,
          publishDate: DateTime.parse(issueDate),
          expiredDate: _hasExpiredDate ? DateTime.parse(expiryDate) : null,
          code: _credentialIdController.text,
          codeURL: _credentialUrlController.text,
        );

        CertificateResponse response = await _profileUseCase.addCertificate(
          newCertificate,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate added successfully!')),
          );
          Navigator.pop(context, true); // Go back to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add certificate. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add certificate. Please try again.'),
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

  Future _getAllCertification({String? name = ""}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      var data = await _profileUseCase.getAllCertificate(name);
      if (!mounted) return;

      List<SingleItemCategoryModel> certificationItems = [];

      if (data != null && data.isNotEmpty) {
        certificationItems = data
            .map(
              (certification) => SingleItemCategoryModel(
                nameSingleItem: certification.nama,
                value: certification,
              ),
            )
            .toList();

        // Always add "Add new certification" option
        certificationItems.add(
          SingleItemCategoryModel(
            nameSingleItem: "+ Add new certification",
            value: "add_new_certification", // Special identifier
          ),
        );

        final certificateList = [
          SingleCategoryModel(singleItemCategoryList: certificationItems),
        ];

        setState(() {
          _selectCertificateController.data = certificateList;
        });
      }
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to get certification data. Please try again.'),
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

        if (actualValue == "add_new_certification") {
          setState(() {
            _showAddNewForm = true;
          });
        } else {
          setState(() {
            _showAddNewForm = false;
          });
          print("Selected certification: ${selectedItem.nameSingleItem}");
        }
      }
    } else {
      setState(() {
        _showAddNewForm = false;
      });
      print("No certification selected");
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          'Add Certificate',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      buildDropdownField(
                        'certificate-select',
                        'Certificate',
                        _selectCertificateController,
                        onChange: (selectedValue) =>
                            _onSelectionChanged(selectedValue),
                      ),
                      if (_showAddNewForm) ...[
                        buildTextField(
                          'Certificate Name',
                          _certificateNameController,
                          Icons.school,
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter issuer';
                            }
                            return null;
                          },
                        ),
                      ],
                      buildDropdownField(
                        'skill-select',
                        'Skill',
                        _selectSkillController,
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
                          } else if (!Uri.parse(value).isAbsolute) {
                            return 'Please enter a valid URL';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton.icon(
                              onPressed: _submitForm,
                              icon: Icon(Icons.check),
                              iconAlignment: IconAlignment.end,
                              label: Text('Submit'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
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
}
