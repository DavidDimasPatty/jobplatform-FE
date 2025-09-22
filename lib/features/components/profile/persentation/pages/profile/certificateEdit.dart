import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/certificateModel.dart';
import 'package:job_platform/features/components/profile/data/models/certificateResponse.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CertificateEdit extends StatefulWidget {
  final String? idUserCertificate;

  const CertificateEdit({super.key, this.idUserCertificate});

  @override
  _CertificateEditState createState() =>
      _CertificateEditState(idUserCertificate: idUserCertificate);
}

class _CertificateEditState extends State<CertificateEdit> {
  final String? idUserCertificate;

  _CertificateEditState({this.idUserCertificate});

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

  // Helper variables
  bool _isLoading = false;
  DateTime? _selectedIssueDate;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
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
        final expiryDate = DateFormat('yyyy-MM-dd').format(
          DateFormat('dd MMMM yyyy', 'en_US').parse(_expiryDateController.text),
        );

        CertificateModel newCertificate = CertificateModel(
          idUser: idUser,
          idUserCertificate: idUserCertificate,
          nama: _certificateNameController.text,
          deskripsi: _descriptionController.text,
          publisher: _issuedByController.text,
          // Assuming skills are handled elsewhere or not required here
          skill: [],
          publishDate: DateTime.parse(issueDate),
          expiredDate: DateTime.parse(expiryDate),
          code: _credentialIdController.text,
          codeURL: _credentialUrlController.text,
        );

        CertificateResponse response = await _profileUseCase.addCertificate(
          newCertificate,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Certificate edited successfully!')),
          );
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
    if (idUserCertificate == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      CertificateResponse response = await _profileUseCase.deleteCertificate(
        idUserCertificate!,
      );

      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Certificate deleted successfully!')),
        );
        // Navigator.of(context).pop(); // Navigate back after deletion
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter certificate name';
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
                      Row(
                        children: [
                          Expanded(
                            child: buildDateField(
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
                                      ? date.toLocal().toString().split(' ')[0]
                                      : '';
                                  if (_expiryDateController.text.isNotEmpty &&
                                      _selectedIssueDate != null &&
                                      DateTime.tryParse(
                                            _expiryDateController.text,
                                          ) !=
                                          null &&
                                      DateTime.parse(
                                        _expiryDateController.text,
                                      ).isBefore(_selectedIssueDate!)) {
                                    _expiryDateController.clear();
                                  }
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: buildDateField(
                              'Expiry Date',
                              _expiryDateController,
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter expiry date';
                                }
                                return null;
                              },
                              context,
                              enabled: _selectedIssueDate != null,
                              firstDate: _selectedIssueDate,
                            ),
                          ),
                        ],
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
                                  onPressed: _deleteCertificate,
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
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blue,
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
                  controller.text = pickedDate.toLocal().toString().split(
                    ' ',
                  )[0];
                  if (onDateSelected != null) onDateSelected(pickedDate);
                }
              }
            : null,
      ),
    );
  }
}
