import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';

import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class EducationalAdd extends StatefulWidget {
  const EducationalAdd({super.key});

  @override
  State<EducationalAdd> createState() => _EducationalAdd();
}

class _EducationalAdd extends State<EducationalAdd> {
  final _headLineController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late SignupUseCase signupUseCase;
  DateTime? startDate;
  DateTime? endDate;

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

  Future _handleAddEducation() async {
    // if (!(_formKey.currentState?.validate() ?? false)) return;

    // try {
    //   // print(_tanggalLahirController.selectedDates);
    //   // print(selectedProvinsi!.nama);
    //   // print(selectedKota!.nama);
    //   DateTime? tanggalLahir = _tanggalLahirController.selectedDate;
    //   SignupRequestModel data = SignupRequestModel(
    //     registerAs: "user",
    //     email: _emailController.text,
    //     nama: _namaController.text,
    //     domisili:
    //         selectedProvinsi!.nama +
    //         "," +
    //         selectedKota!.nama +
    //         "," +
    //         _alamatController.text,
    //     tanggalLahir: tanggalLahir!,
    //     noTelp: selectedCountry!.dialCode + _phoneController.text,
    //     jenisKelamin: gender,
    //     tempatLahir:
    //         selectedProvinsiLahir!.nama + "," + selectedKotaLahir!.nama,
    //   );
    //   SignupResponseModel dataRes = await signupUseCase.SignUpAction(data);

    //   // if (mounted) {
    //   //   Navigator.pushReplacement(
    //   //     context,
    //   //     MaterialPageRoute(builder: (context) => const Login()),
    //   //   );
    //   // }
    //   if (dataRes.responseMessages == "Sukses") {
    //     SharedPreferences prefs = await SharedPreferences.getInstance();
    //     await prefs.setString("loginAs", "user");
    //     await prefs.setString("idUser", dataRes.user!.id);
    //     await prefs.setString("nama", dataRes.user!.nama);
    //     await prefs.setString("email", dataRes.user!.email);
    //     await prefs.setString("noTelp", dataRes.user!.noTelp);
    //     return Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => Layout()),
    //     );
    //   } else {
    //     return ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text(dataRes.responseMessages),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   debugPrint('Error during signup: $e');
    //   // Show error message to user
    //   if (mounted) {
    //     return ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Signup failed. Please try again.'),
    //         backgroundColor: Colors.red,
    //       ),
    //     );
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    signupUseCase = SignupUseCase(repository);
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
                              "Add Education",
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
                                labelText: 'Nama Sekolah',
                                hintText: 'Masukan Nama Sekolah',
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
                              controller: _headLineController,
                              decoration: InputDecoration(
                                labelText: 'Tingkatan',
                                hintText: 'Masukan Tingkatan',
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
                              controller: _headLineController,
                              decoration: InputDecoration(
                                labelText: 'Penjurusan',
                                hintText: 'Masukan Penjurusan',
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
                                prefixIcon: Icon(Icons.location_pin),
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
                                      labelText: "Start Date",
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Text(
                                      startDate != null
                                          ? "${startDate!.day}-${startDate!.month}-${startDate!.year}"
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
                                      labelText: "End Date",
                                      border: OutlineInputBorder(),
                                    ),
                                    child: Text(
                                      endDate != null
                                          ? "${endDate!.day}-${endDate!.month}-${endDate!.year}"
                                          : "Pilih tanggal",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(height: 90),
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
                                    readOnly: true,
                                    controller: _namaController,
                                    decoration: InputDecoration(
                                      labelText: 'GPA',
                                      hintText: 'Masukan GPA',
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
                                textDirection: TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: _handleAddEducation,
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
