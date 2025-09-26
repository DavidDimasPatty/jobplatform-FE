import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceModel.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceRequest.dart';
import 'package:job_platform/features/components/profile/data/models/workExperienceResponse.dart';
import 'package:job_platform/features/components/profile/domain/entities/WorkExperienceMV.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class ExperienceEdit extends StatefulWidget {
  final WorkexperienceMV experience;

  const ExperienceEdit({super.key, required this.experience});

  @override
  State<ExperienceEdit> createState() => _ExperienceEdit(data: experience);
}

class _ExperienceEdit extends State<ExperienceEdit> {
  final WorkexperienceMV data;

  _ExperienceEdit({required this.data});

  // Controllers
  final _namaController = TextEditingController();
  final _jabatanController = TextEditingController();
  final _divisiController = TextEditingController();
  final _sistemKerjaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _industriController = TextEditingController();
  final _tipeKaryawanController = TextEditingController();

  // Global key
  final _formKey = GlobalKey<FormState>();

  // Helper variables
  bool _isLoading = false;
  DateTime? startDate;
  DateTime? endDate;
  bool _stillActive = true;

  // Use case instance
  late ProfileUsecase _profileUseCase;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    _profileUseCase = ProfileUsecase(repository);
    _loadData();
  }

  void _loadData() {
    _namaController.text = data.experience.namaPerusahaan;
    _lokasiController.text = data.experience.lokasi;
    _industriController.text = data.experience.industri;
    _deskripsiController.text = data.deskripsi ?? '';
    _jabatanController.text = data.namaJabatan ?? '';
    _divisiController.text = data.bidang ?? '';
    _sistemKerjaController.text = data.sistemKerja ?? '';
    _tipeKaryawanController.text = data.tipeKaryawan ?? '';
    startDate = data.startDate;

    _stillActive = data.endDate == null;
    if (!_stillActive) {
      endDate = data.endDate;
    }
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

  Future _handleEditExperience() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? idUser = prefs.getString('idUser');

        // Ensure idUser is not null
        if (idUser == null) throw Exception("User ID not found in preferences");

        WorkExperienceRequest editedExperience = WorkExperienceRequest(
          idUser: idUser,
          idUserExperience: data.id,
          experience: data.experience,
          skill: data.skill,
          bidang: _divisiController.text,
          deskripsi: _deskripsiController.text,
          namaJabatan: _jabatanController.text,
          sistemKerja: _sistemKerjaController.text,
          tipeKaryawan: _tipeKaryawanController.text,
          isActive: _stillActive,
          startDate: startDate!,
          endDate: _stillActive ? null : endDate,
        );

        WorkExperienceResponse response = await _profileUseCase
            .editWorkExperience(editedExperience);

        // On success, clear the form or navigate away
        if (response.responseMessage == 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Work Experience edited successfully!')),
          );
          Navigator.pop(context, true); // Go back to the previous screen
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to edit work experience. Please try again.',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
        _formKey.currentState!.reset();
      } catch (e) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit work experience. Please try again.'),
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

  Future _handleDeleteExperience() async {
    setState(() {
      _isLoading = true;
    });

    try {
      WorkExperienceResponse response = await _profileUseCase
          .deleteWorkExperience(data.id);

      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Work Experience deleted successfully!')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to delete work experience. Please try again.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete work experience. Please try again.'),
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
                              "Edit Experience",
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
                                labelText: 'Nama Perusahaan',
                                hintText: 'Masukan Nama',
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
                              readOnly: true,
                              controller: _industriController,
                              decoration: InputDecoration(
                                labelText: 'Tipe Industri Perusahaan',
                                hintText: 'Masukan Industri',
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
                              readOnly: true,
                              controller: _lokasiController,
                              decoration: InputDecoration(
                                labelText: 'Lokasi Perusahaan',
                                hintText: 'Masukan Lokasi',
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
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _divisiController,
                              decoration: InputDecoration(
                                labelText: 'Divisi',
                                hintText: 'Masukan Divisi',
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
                                    controller: _tipeKaryawanController,
                                    decoration: InputDecoration(
                                      labelText: 'Tipe Karyawan',
                                      hintText: 'Masukan Tipe Karyawan',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.account_circle),
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
                                    controller: _sistemKerjaController,
                                    decoration: InputDecoration(
                                      labelText: 'Sistem Kerja',
                                      hintText: 'Masukan Sistem Kerja',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.account_circle),
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
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: _handleEditExperience,
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

  void _showSimpleDeleteConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Work Experience',
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
                  'Are you sure you want to delete this work experience?',
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
                              widget.experience.experience.namaPerusahaan,
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
                            child: Text('${widget.experience.namaJabatan}'),
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
                _handleDeleteExperience();
              },
              icon: Icon(Icons.delete, size: 16),
              label: Text('Delete'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
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
