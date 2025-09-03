import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      // print(_tanggalLahirController.selectedDates);
      // print(selectedProvinsi!.nama);
      // print(selectedKota!.nama);
      DateTime? tanggalLahir = _tanggalLahirController.selectedDate;
      SignupRequestModel data = SignupRequestModel(
        registerAs: "user",
        email: _emailController.text,
        nama: _namaController.text,
        alamat:
            selectedProvinsi!.nama +
            "," +
            selectedKota!.nama +
            "," +
            _alamatController.text,
        tanggalLahir: tanggalLahir!,
        noTelp: selectedCountry!.dialCode + _phoneController.text,
        jenisKelamin: gender,
      );
      SignupResponseModel dataRes = await signupUseCase.SignUpAction(data);

      // if (mounted) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Login()),
      //   );
      // }
      if (dataRes.responseMessages == "Sukses") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("loginAs", "user");
        await prefs.setString("idUser", dataRes.user!.id);
        await prefs.setString("nama", dataRes.user!.nama);
        await prefs.setString("email", dataRes.user!.email);
        await prefs.setString("noTelp", dataRes.user!.noTelp);
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(dataRes.responseMessages),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during signup: $e');
      // Show error message to user
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,

        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: ResponsiveRowColumn(
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowMainAxisAlignment: MainAxisAlignment.center,
          columnMainAxisAlignment: MainAxisAlignment.center,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          rowSpacing: 100,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(
              rowFlex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: MediaQuery.of(context).size.height + 200,
                width: double.infinity - 100,
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Set Your Initial Profile",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      'assets/images/BG_SignUpPelamar.png',
                      width: 500,
                      height: 500,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Isi data awalmu untuk melanjutkan registrasi.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

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
                            "Form Sign Up Pelamar",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),

                        Container(
                          // height: 90,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Masukan Email',
                              prefixIcon: Icon(Icons.email),
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

                        // SizedBox(width: 90),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                // height: 40,
                                child: DropdownButtonFormField<Country>(
                                  value: selectedCountry,
                                  isExpanded: true,
                                  hint: Text("Pilih Negara"),
                                  items: countries.map((country) {
                                    return DropdownMenuItem<Country>(
                                      value: country,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            country.flag,
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              country.code,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              country.dialCode,
                                              style: const TextStyle(
                                                fontSize: 14,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
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
                              SizedBox(width: 10),
                              Flexible(
                                flex: 2,
                                // height: 40,
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
                                    if (!RegExp(
                                      r'^[0-9]{8,13}$',
                                    ).hasMatch(value)) {
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
                                  controller: _namaController,
                                  decoration: InputDecoration(
                                    labelText: 'Nama Lengkap',
                                    hintText: 'Masukan Nama Lengkap',
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
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              bool isMobile = ResponsiveBreakpoints.of(
                                context,
                              ).smallerThan(TABLET);
                              return isMobile
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Pilih Jenis Kelamin ",
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () =>
                                                    _changeGender("L"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: gender == "L"
                                                      ? Colors.green
                                                      : Colors.blue,
                                                ),
                                                icon: const Icon(
                                                  Icons.boy,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Laki Laki',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: ElevatedButton.icon(
                                                onPressed: () =>
                                                    _changeGender("P"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: gender == "P"
                                                      ? Colors.pink
                                                      : Colors.blue,
                                                ),
                                                icon: const Icon(
                                                  Icons.girl,
                                                  color: Colors.white,
                                                ),
                                                label: const Text(
                                                  'Perempuan',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 20),
                                          child: Text(
                                            "Pilih Jenis Kelamin ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _changeGender("L"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: gender == "L"
                                                    ? Colors.green
                                                    : Colors.blue,
                                              ),
                                              icon: const Icon(
                                                Icons.boy,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Laki Laki',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 50),
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _changeGender("P"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: gender == "P"
                                                    ? Colors.pink
                                                    : Colors.blue,
                                              ),
                                              icon: const Icon(
                                                Icons.girl,
                                                color: Colors.white,
                                              ),
                                              label: const Text(
                                                'Perempuan',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            },
                          ),
                        ),

                        // SizedBox(height: 90, width: 300),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                            minWidth: 200,
                            maxHeight: 400,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Tanggal Lahir", // ini label
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SfDateRangePicker(
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                          todayTextStyle: TextStyle(
                                            color: Colors
                                                .black, // warna teks hari ini
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                    yearCellStyle: DateRangePickerYearCellStyle(
                                      todayTextStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    selectionTextStyle: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    startRangeSelectionColor: Colors.blue,
                                    selectionColor: Colors.white,
                                    todayHighlightColor: Colors.transparent,
                                    backgroundColor: Colors.blue.shade50,
                                    headerStyle: DateRangePickerHeaderStyle(
                                      textAlign: TextAlign.center,
                                      backgroundColor: Colors.blue.shade50,
                                      textStyle: TextStyle(
                                        backgroundColor: Colors.blue.shade50,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    controller: _tanggalLahirController,
                                    selectionMode:
                                        DateRangePickerSelectionMode.single,
                                    maxDate: DateTime.now(),
                                    view: DateRangePickerView.year,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          // height: 90,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "Tempat Lahir", // ini label
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: DropdownButtonFormField<ProvinsiModel>(
                                      isExpanded: true,
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
                                          await fetchDataKota(
                                            selectedProvinsi!.id,
                                          );
                                        } else {
                                          setState(() {
                                            kota = [];
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        // contentPadding: EdgeInsets.symmetric(
                                        //   horizontal: 12,
                                        //   vertical: 8,
                                        // ),
                                        prefixIcon: Icon(Icons.gps_fixed),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: DropdownButtonFormField<KotaModel>(
                                      isExpanded: true,
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
                                        // contentPadding: EdgeInsets.symmetric(
                                        //   horizontal: 12,
                                        //   vertical: 8,
                                        // ),
                                        prefixIcon: Icon(Icons.location_city),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // SizedBox(height: 90, width: 300),
                        Container(
                          // height: 90,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsGeometry.symmetric(
                                  vertical: 10,
                                ),
                                child: Text(
                                  "Domisili Sekarang", // ini label
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: DropdownButtonFormField<ProvinsiModel>(
                                      isExpanded: true,
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
                                          await fetchDataKota(
                                            selectedProvinsi!.id,
                                          );
                                        } else {
                                          setState(() {
                                            kota = [];
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        // contentPadding: EdgeInsets.symmetric(
                                        //   horizontal: 12,
                                        //   vertical: 8,
                                        // ),
                                        prefixIcon: Icon(Icons.gps_fixed),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: DropdownButtonFormField<KotaModel>(
                                      isExpanded: true,
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
                                        // contentPadding: EdgeInsets.symmetric(
                                        //   horizontal: 12,
                                        //   vertical: 8,
                                        // ),
                                        prefixIcon: Icon(Icons.location_city),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                // height: 90,
                                child: TextFormField(
                                  controller: _alamatController,
                                  decoration: InputDecoration(
                                    labelText: 'Alamat Lengkap',
                                    hintText: 'Masukan Alamat Lengkap',
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
                                onPressed: () {},
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
    );
  }
}
