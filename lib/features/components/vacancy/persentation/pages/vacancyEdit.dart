import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/vacancy/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyRequest.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';
import 'package:job_platform/features/components/vacancy/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/vacancy/domain/entities/vacancyData.dart';
import 'package:job_platform/features/components/vacancy/domain/usecases/vacancy_usecase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Vacancyedit extends StatefulWidget {
  final VacancyData data;

  const Vacancyedit({super.key, required this.data});

  @override
  _Vacancyedit createState() => _Vacancyedit(data: data);
}

class _Vacancyedit extends State<Vacancyedit> {
  final VacancyData data;

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

  // Helper variables
  bool _isLoading = false;
  int minSalary = 0;
  int maxSalary = 0;

  // Use case instance
  late VacancyUseCase _vacancyUseCase;

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
    super.dispose();
  }

  void _loadData() {
    _salaryMinController.text = data.gajiMin.toString();
    _salaryMaxController.text = data.gajiMax.toString();
    _positionController.text = data.namaPosisi ?? '';
    _jobTypeController.text = data.tipeKerja ?? '';
    _workSystemController.text = data.sistemKerja ?? '';
    _locationController.text = data.lokasi ?? '';
    _careerLevelController.text = data.jabatan ?? '';
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _vacancyUseCase = VacancyUseCase(repository);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final storage = StorageService();
        String? idCompany = await storage.get('idCompany');

        // Ensure idCompany is not null
        if (idCompany == null)
          throw Exception("Company ID not found in preferences".tr());

        VacancyRequest editVacancy = VacancyRequest(
          idCompany: idCompany,
          idCompanyVacancy: data.id,
          gajiMin: int.parse(_salaryMinController.text),
          gajiMax: int.parse(_salaryMaxController.text),
          namaPosisi: _positionController.text,
          tipeKerja: _jobTypeController.text,
          sistemKerja: _workSystemController.text,
          lokasi: _locationController.text,
          jabatan: _careerLevelController.text,
        );

        VacancyResponse response = await _vacancyUseCase.vacancyEdit(
          editVacancy,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vacancy edited successfully!'.tr())),
          );
          context.go('/vacancy');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to edit vacancy. Please try again.'.tr()),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit vacancy. Please try again.'.tr()),
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
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            'Edit Vacancy'.tr(),
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
                                'Min Salary Expectation'.tr(),
                                _salaryMinController,
                                Icons.attach_money,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter minimum salary'.tr();
                                  } else if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number'.tr();
                                  }
                                  minSalary = int.parse(value);
                                  if (minSalary < 0) {
                                    return 'Salary cannot be negative'.tr();
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
                                'Max Salary Expectation'.tr(),
                                _salaryMaxController,
                                Icons.attach_money,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter maximum salary'.tr();
                                  } else if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number'.tr();
                                  }
                                  maxSalary = int.parse(value);
                                  if (maxSalary < 0) {
                                    return 'Salary cannot be negative'.tr();
                                  } else if (maxSalary < minSalary) {
                                    return 'Max salary must be greater than min salary'
                                        .tr();
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        buildTextField(
                          'Position'.tr(),
                          _positionController,
                          Icons.business,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter position'.tr();
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          'Job Type'.tr(),
                          _jobTypeController,
                          Icons.co_present,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter job type'.tr();
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          'Work System'.tr(),
                          _workSystemController,
                          Icons.access_time,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter work system'.tr();
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          'Location'.tr(),
                          _locationController,
                          Icons.location_on,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter location'.tr();
                            }
                            return null;
                          },
                        ),
                        buildTextField(
                          'Career Level'.tr(),
                          _careerLevelController,
                          Icons.trending_up,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter career level'.tr();
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
                                label: Text('Submit'.tr()),
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
        initialValue: value,
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
