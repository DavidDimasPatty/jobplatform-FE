import 'package:flutter/material.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/preferenceResponse.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/profile/domain/entities/PreferenceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Vacancyedit extends StatefulWidget {
  final PreferenceMV data;

  const Vacancyedit({super.key, required this.data});

  @override
  _Vacancyedit createState() => _Vacancyedit(data: data);
}

class _Vacancyedit extends State<Vacancyedit> {
  final PreferenceMV data;

  _Vacancyedit({required this.data});

  final _formKey = GlobalKey<FormState>();

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

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _loadData();
  }

  @override
  void dispose() {
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _positionController.dispose();
    _jobTypeController.dispose();
    _workSystemController.dispose();
    _locationController.dispose();
    _careerLevelController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _loadData() {
    _salaryMinController.text = data.gajiMin.toString();
    _salaryMaxController.text = data.gajiMax.toString();
    _positionController.text = data.posisi ?? '';
    _jobTypeController.text = data.tipePekerjaan ?? '';
    _workSystemController.text = data.sistemKerja ?? '';
    _locationController.text = data.lokasi ?? '';
    _careerLevelController.text = data.levelJabatan ?? '';
    _availabilityController.text = DateFormat(
      'dd MMMM yyyy',
    ).format(data.dateWork ?? DateTime.now());
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
        final workDate = DateFormat('yyyy-MM-dd').format(
          DateFormat(
            'dd MMMM yyyy',
            'en_US',
          ).parse(_availabilityController.text),
        );

        PreferenceRequest editPreference = PreferenceRequest(
          idUser: idUser,
          idPreference: data.id,
          gajiMin: int.parse(_salaryMinController.text),
          gajiMax: int.parse(_salaryMaxController.text),
          posisi: _positionController.text,
          tipePekerjaan: _jobTypeController.text,
          sistemKerja: _workSystemController.text,
          lokasi: _locationController.text,
          levelJabatan: _careerLevelController.text,
          dateWork: DateTime.parse(workDate),
        );

        PreferenceResponse response = await _profileUseCase.editPreference(
          editPreference,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Preference edited successfully!')),
          );
          Navigator.pop(context, true); // Go back to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to edit preference. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit preference. Please try again.'),
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
                          'Edit Vacancy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                        'Position',
                        _positionController,
                        Icons.business,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter position';
                          }
                          return null;
                        },
                      ),
                      buildTextField(
                        'Job Type',
                        _jobTypeController,
                        Icons.co_present,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter job type';
                          }
                          return null;
                        },
                      ),
                      buildTextField(
                        'Work System',
                        _workSystemController,
                        Icons.access_time,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter work system';
                          }
                          return null;
                        },
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
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
    String? Function(String?) validator,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.arrow_drop_down),
        ),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem<String>(value: item, child: Text(item)),
            )
            .toList(),
        onChanged: onChanged,
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
}
