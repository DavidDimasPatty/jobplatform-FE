import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/progress/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/progress/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/progress/domain/usecases/progress_usecase.dart';
import 'package:job_platform/features/components/statusJob/data/models/CompanyVacancies.dart';
import 'package:job_platform/features/components/statusJob/data/models/UserVacancies.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class editVacancyCandidate extends StatefulWidget {
  final CompanyVacancies? dataVacancy;
  final UserVacancies? dataUserVacancy;
  editVacancyCandidate({super.key, this.dataVacancy, this.dataUserVacancy});

  @override
  State<editVacancyCandidate> createState() => _editVacancyCandidate();
}

class _editVacancyCandidate extends State<editVacancyCandidate> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  TextEditingController _salaryMinController = TextEditingController();
  TextEditingController _salaryMaxController = TextEditingController();
  late String? _jobTypeController;
  late String? _workSystemController;
  late List<String> jobType = [];
  late List<String> workSystem = [];

  // Helper variables
  bool _isLoading = false;
  int minSalary = 0;
  int maxSalary = 0;
  bool isDropdownReady = false;

  // Use case instance
  late ProgressUsecase _progressUsecase;

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
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      jobType = ["Tetap".tr(), "Kontrak".tr(), "Magang".tr()];
      workSystem = ["WFO".tr(), "WFH".tr(), "Hybrid".tr()];
      _salaryMinController.text =
          (widget.dataUserVacancy?.gajiMin != null
              ? widget.dataUserVacancy?.gajiMin!.toString()
              : widget.dataVacancy?.gajiMin != null
              ? widget.dataVacancy?.gajiMin!.toString()
              : "0") ??
          "0";
      _salaryMaxController.text =
          (widget.dataUserVacancy?.gajiMax != null
              ? widget.dataUserVacancy?.gajiMax!.toString()
              : widget.dataVacancy?.gajiMax != null
              ? widget.dataVacancy?.gajiMax!.toString()
              : "0") ??
          "0";
      final tempJobType =
          widget.dataUserVacancy?.tipeKerja ??
          widget.dataVacancy?.tipeKerja ??
          "";
      final tempWorkSystem =
          widget.dataUserVacancy?.sistemKerja ??
          widget.dataVacancy?.sistemKerja ??
          "";

      _jobTypeController = jobType.contains(tempJobType) ? tempJobType : null;
      _workSystemController = workSystem.contains(tempWorkSystem)
          ? tempWorkSystem
          : null;
      isDropdownReady = true;
    });
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    _progressUsecase = ProgressUsecase(repository);
  }

  Future<String?> konfirmasiEdit(BuildContext context) {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Konfirmasi Tahapan'.tr()),
          content: Text(
            'Apakah Anda yakin ingin mengubah detail vacancy untuk user ini?'
                .tr(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: Text('Batal'.tr(), style: TextStyle(color: Colors.blue)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop("CONFIRM"),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
              child: Text('Konfirmasi'.tr()),
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final storage = StorageService();
        String? idUser = await storage.get('idUser');

        if (idUser == null) throw Exception("User ID not found in preferences");

        if (double.tryParse(_salaryMinController.text) == null) {
          throw Exception("Invalid Salary Min Format".tr());
        }

        if (double.tryParse(_salaryMaxController.text) == null) {
          throw Exception("Invalid Salary Max Format".tr());
        }

        final result = await konfirmasiEdit(context);
        if (result == null) {
          return;
        }

        String? response = await _progressUsecase.editVacancyCandidate(
          widget.dataUserVacancy!.id!,
          idUser,
          _jobTypeController,
          _workSystemController,
          double.tryParse(_salaryMinController.text),
          double.tryParse(_salaryMaxController.text),
        );

        // On success, clear the form or navigate away
        if (response == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Vacancy edited successfully!'.tr())),
          );
          context.go(
            '/progressDetail',
            extra: {"data": widget.dataUserVacancy!.id},
          );
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
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
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
                            'Negotiation Vacancy'.tr(),
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

                        isDropdownReady == false
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Job Type'.tr(),
                                _jobTypeController,
                                jobType,
                                (value) => _jobTypeController = value,
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter job type'.tr();
                                  }
                                  return null;
                                },
                              ),

                        isDropdownReady == false
                            ? CircularProgressIndicator(
                                color: Colors.blue.shade400,
                              )
                            : buildDropdownField(
                                'Work System'.tr(),
                                _workSystemController,
                                workSystem,
                                (value) => _workSystemController = value,
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter work system'.tr();
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: value != null ? value : null,
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
      padding: EdgeInsets.symmetric(vertical: 8.0),
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
