import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:typed_data';

class SignUpPelamar extends StatefulWidget {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
  @override
  State<SignUpPelamar> createState() =>
      _SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
}

class _SignUpPelamar extends State<SignUpPelamar> {
  List<ProvinsiModel> provinsi = [];
  List<KotaModel> kota = [];
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  _SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = DateRangePickerController();
  final _formKey = GlobalKey<FormState>();
  ProvinsiModel? selectedProvinsi = null;
  KotaModel? selectedKota = null;
  Uint8List? _photoBytes;
  late SignupUseCase signupUseCase;
  //bool _loadingPhoto = false;
  ////////////////////////////////////////////////////////////

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap lengkapi semua field!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void fetchDataProvinsi() async {
    final result = await signupUseCase.getProvinsi();
    setState(() {
      provinsi = result;
    });
  }

  void fetchDataKota() async {
    kota.clear();
    final result = await signupUseCase.getKota(selectedProvinsi!.code);
    setState(() {
      kota = result;
    });
  }

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    signupUseCase = SignupUseCase(repository);
    fetchDataProvinsi();
    _emailController.text = email!;
    _namaController.text = name!;
    _phoneController.text = "+62";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 70,
                      width: 600,
                      child: Text(
                        "Form Sign Up Pelamar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    // CircleAvatar(
                    //   radius: 40,
                    //   backgroundImage: _photoBytes != null
                    //       ? MemoryImage(_photoBytes!)
                    //       : null,
                    //   child: _photoBytes == null ? Icon(Icons.person) : null,
                    // ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 300,
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Masukan Email',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 11,
                              ),
                            ),
                            // initialValue: email,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Wajib diisi'
                                : null,
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          width: 300,
                          child: TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              labelText: 'Nomor Telepon',
                              hintText: 'Masukkan nomor telepon Anda',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon tidak boleh kosong';
                              }
                              if (!RegExp(r'^[0-9]{8,13}$').hasMatch(value)) {
                                return 'Masukkan nomor telepon yang valid';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              // Remove leading zeros as user types
                              if (value.startsWith('0')) {
                                final newValue = value.replaceFirst(
                                  RegExp(r'^0+'),
                                  '',
                                );
                                _phoneController.value = TextEditingValue(
                                  text: newValue,
                                  selection: TextSelection.collapsed(
                                    offset: newValue.length,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 300,
                          child: TextFormField(
                            controller: _namaController,
                            decoration: InputDecoration(
                              labelText: 'Nama Lengkap',
                              hintText: 'Masukan Nama Lengkap',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 11,
                              ),
                            ),
                            // initialValue: name,
                            validator: (value) => value == null || value.isEmpty
                                ? 'Wajib diisi'
                                : null,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Jenis Kelamin", // ini label
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: _handleSignUp,
                                  child: Text(
                                    'Laki Laki',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                SizedBox(width: 50),
                                ElevatedButton(
                                  onPressed: _handleSignUp,
                                  child: Text(
                                    'Perempuan',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 250,
                      width: 300,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tanggal Lahir", // ini label
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Expanded(
                            child: SfDateRangePicker(
                              controller: _tanggalLahirController,
                              maxDate: DateTime.now(),
                              view: DateRangePickerView.year,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // SizedBox(
                    //   height: 90,
                    //   width: 300,
                    //   child: TextFormField(
                    //     controller: _tempatLahirController,
                    //     decoration: InputDecoration(
                    //       labelText: 'Tempat Lahir',
                    //       hintText: 'Masukan Tempat Lahir',
                    //       border: OutlineInputBorder(),
                    //       contentPadding: EdgeInsets.symmetric(
                    //         vertical: 8,
                    //         horizontal: 11,
                    //       ),
                    //     ),
                    //     // initialValue: name,
                    //     validator: (value) => value == null || value.isEmpty
                    //         ? 'Wajib diisi'
                    //         : null,
                    //   ),
                    // ),
                    SizedBox(height: 90, width: 300),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 90,
                          width: 300,
                          child: DropdownButtonFormField<ProvinsiModel>(
                            value: selectedProvinsi,
                            hint: Text("Pilih Provinsi"),
                            items: provinsi.map((prov) {
                              return DropdownMenuItem<ProvinsiModel>(
                                value: prov,
                                child: Text(prov.nama),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedProvinsi = value;
                                fetchDataKota();
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 90,
                          width: 300,
                          child: DropdownButtonFormField<KotaModel>(
                            value: selectedKota,
                            hint: Text("Pilih Kota"),
                            items: kota.map((kota) {
                              return DropdownMenuItem<KotaModel>(
                                value: kota,
                                child: Text(kota.nama),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedKota = value;
                              });
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _handleSignUp,
                          child: Text(
                            'Daftar',
                            style: TextStyle(color: Colors.black),
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
      ),
    );
  }
}
