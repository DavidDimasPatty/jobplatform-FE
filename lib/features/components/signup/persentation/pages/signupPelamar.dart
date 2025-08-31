import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

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
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  _SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
  List<ProvinsiModel> provinsi = [];
  List<KotaModel> kota = [];
  List<Country> countries = [];
  bool isLoadingKota = false;
  int _kotaRequestId = 0;
  bool isLoadingProvinsi = false;
  int _ProvinsiRequestId = 0;
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tanggalLahirController = DateRangePickerController();
  final _formKey = GlobalKey<FormState>();
  ProvinsiModel? selectedProvinsi = null;
  KotaModel? selectedKota = null;
  Country? selectedCountry = null;
  String gender = "";
  Uint8List? _photoBytes;
  late SignupUseCase signupUseCase;
  //bool _loadingPhoto = false;
  ////////////////////////////////////////////////////////////

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final dataSource = AuthRemoteDatasource();
      final repository = AuthRepositoryImpl(dataSource);
      final usecase = SignupUseCase(repository);
      SignupRequestModel data = SignupRequestModel(
        registerAs: "user",
        email: _emailController.text,
        nama: _namaController.text,
        alamat: _alamatController.text,
        tanggalLahir: _tanggalLahirController.selectedDates!.first,
        noTelp: _phoneController.text,
        jenisKelamin: gender,
      );
      await usecase.SignUpAction(data);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      }
    } catch (e) {
      debugPrint('Error during signup: $e');
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _changeGender(String genderSelect) {
    setState(() {
      gender = genderSelect;
    });
  }

  Future<List<ProvinsiModel>> fetchDataProvinsi() async {
    final result = await signupUseCase.getProvinsi();
    setState(() {
      provinsi = result;
    });
    return provinsi;
  }

  Future<List<KotaModel>> fetchDataKota(String provinceCode) async {
    setState(() {
      kota = [];
      isLoadingKota = true;
    });

    try {
      final result = await signupUseCase.getKota(provinceCode);
      setState(() {
        kota = result;
      });
      return kota;
    } catch (e, st) {
      debugPrint('Error fetchDataKota: $e\n$st');
      return kota;
    }
  }

  Future<List<Country>> loadCountries() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/core/constant/phoneNumber.json',
      );
      print("masuk");
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final loaded = jsonList
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        if (!countries.isNotEmpty) {
          countries = loaded;
          selectedCountry = countries.firstWhere(
            (c) => c.code.toUpperCase() == 'ID' || c.dialCode == '+62',
            orElse: () => countries.first,
          );
          print(selectedCountry!.dialCode);
        } else {
          selectedCountry = null;
        }
      });
      return countries;
    } catch (e) {
      debugPrint('Error load countries: $e');
      return countries;
    }
  }

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    signupUseCase = SignupUseCase(repository);
    fetchDataProvinsi();
    loadCountries();
    _emailController.text = email!;
    _namaController.text = name!;
    _phoneController.text = "";
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
      body: SingleChildScrollView(
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
                      ],
                    ),

                    SizedBox(width: 90),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        SizedBox(
                          width: 120,
                          height: 40,
                          child: DropdownButtonFormField<Country>(
                            value: selectedCountry,
                            isExpanded: true,
                            hint: Text("Pilih Negara"),
                            items: countries.map((country) {
                              return DropdownMenuItem<Country>(
                                value: country,
                                child: Text(
                                  country.name.trim(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value;
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
                        SizedBox(width: 20),
                        SizedBox(
                          width: 250,
                          height: 40,
                          child: TextFormField(
                            key: ValueKey(selectedCountry?.dialCode),
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Nomor Telepon',
                              hintText: 'Masukkan nomor telepon Anda',
                              border: const OutlineInputBorder(),
                              prefixIcon: IntrinsicWidth(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    selectedCountry?.dialCode ?? '+62',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
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
                    SizedBox(height: 90),

                    // Row(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       height: 90,
                    //       width: 300,
                    //       child: TextFormField(
                    //         key: ValueKey(selectedCountry?.dialCode),
                    //         controller: _phoneController,
                    //         keyboardType: TextInputType.phone,
                    //         decoration: InputDecoration(
                    //           labelText: 'Nomor Telepon',
                    //           hintText: 'Masukkan nomor telepon Anda',
                    //           border: const OutlineInputBorder(),
                    //           prefixIcon: IntrinsicWidth(
                    //             child: Container(
                    //               alignment: Alignment.center,
                    //               padding: const EdgeInsets.symmetric(
                    //                 horizontal: 8,
                    //               ),
                    //               child: Text(
                    //                 selectedCountry?.dialCode ?? '+62',
                    //                 style: const TextStyle(
                    //                   fontWeight: FontWeight.bold,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ),
                    //         validator: (value) {
                    //           if (value == null || value.isEmpty) {
                    //             return 'Nomor telepon tidak boleh kosong';
                    //           }
                    //           if (!RegExp(r'^[0-9]{8,13}$').hasMatch(value)) {
                    //             return 'Masukkan nomor telepon yang valid';
                    //           }
                    //           return null;
                    //         },
                    //         onChanged: (value) {
                    //           // Remove leading zeros as user types
                    //           if (value.startsWith('0')) {
                    //             final newValue = value.replaceFirst(
                    //               RegExp(r'^0+'),
                    //               '',
                    //             );
                    //             _phoneController.value = TextEditingValue(
                    //               text: newValue,
                    //               selection: TextSelection.collapsed(
                    //                 offset: newValue.length,
                    //               ),
                    //             );
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
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
                      ],
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
                        SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () => _changeGender("L"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gender == "L"
                                    ? Colors.blue
                                    : Colors.grey[300],
                              ),
                              child: const Text(
                                'Laki Laki',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            SizedBox(width: 50),
                            ElevatedButton(
                              onPressed: () => _changeGender("P"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gender == "P"
                                    ? Colors.pink
                                    : Colors.grey[300],
                              ),
                              child: const Text(
                                'Perempuan',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 90, width: 300),

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
                            onChanged: (value) async {
                              setState(() {
                                kota = [];
                                selectedKota = null;
                                selectedProvinsi = value;
                              });

                              if (value != null) {
                                await fetchDataKota(selectedProvinsi!.code);
                              } else {
                                setState(() {
                                  kota = [];
                                });
                              }
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

                    SizedBox(
                      height: 90,
                      width: 700,
                      child: TextFormField(
                        controller: _alamatController,
                        decoration: InputDecoration(
                          labelText: 'Alamat Lengkap',
                          hintText: 'Masukan Alamat Lengkap',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 11,
                          ),
                        ),
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: 5,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Wajib diisi'
                            : null,
                      ),
                    ),

                    SizedBox(height: 40),
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
