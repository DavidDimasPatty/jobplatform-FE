import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/profile/data/models/organizationModel.dart';
import 'package:job_platform/features/components/profile/data/models/organizationRequest.dart';
import 'package:job_platform/features/components/profile/data/models/organizationResponse.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';

import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
  final _jabatanController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();

  // Global key
  final _formKey = GlobalKey<FormState>();

  // Helper variables
  bool _isLoading = false;
  DateTime? startDate;
  DateTime? endDate;

  // Usecase Instance
  late ProfileUsecase _profileUseCase;

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

        // Format dates to 'yyyy-MM-dd'
        final issueDate = DateFormat('yyyy-MM-dd').format(startDate!);
        final expiryDate = DateFormat('yyyy-MM-dd').format(endDate!);

        OrganizationModel organization = OrganizationModel(
          nama: _namaController.text,
          lokasi: 'PIK',
        );

        OrganizationRequest newOrganization = OrganizationRequest(
          idUser: idUser,
          organization: organization,
          skill: [],
          isActive: true,
          deskripsi: _deskripsiController.text,
          jabatan: _jabatanController.text,
          startDate: DateTime.parse(issueDate),
          endDate: DateTime.parse(expiryDate),
        );

        OrganizationResponse response = await _profileUseCase.addOrganization(
          newOrganization,
        );

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Organization added successfully!')),
          );
          Navigator.pop(context, true); // Go back to the previous screen
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

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _profileUseCase = ProfileUsecase(repository);
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

                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () => _pickStartDate(context),
                                  child: InputDecorator(
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_today),
                                      labelText: "Start Date",
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Text(
                                      startDate != null
                                          ? DateFormat('dd MMMM yyyy').format(startDate!)
                                          : "Pilih tanggal",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: InkWell(
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
                                          ? DateFormat('dd MMMM yyyy').format(endDate!)
                                          : "Pilih tanggal",
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
