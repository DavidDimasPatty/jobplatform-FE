import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/home/persentation/pages/homePage.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/shared/layout.dart';
import 'package:job_platform/routes/router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SignUpPelamar extends StatefulWidget {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  const SignUpPelamar(
    this.name,
    this.email,
    this.photoUrl,
    this.token, {
    super.key,
  });
  @override
  State<SignUpPelamar> createState() =>
      _SignUpPelamar(name, email, photoUrl, token);
}

class _SignUpPelamar extends State<SignUpPelamar> {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  _SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
  List<ProvinsiModel> provinsi = [];
  List<KotaModel> kota = [];
  List<ProvinsiModel> provinsiLahir = [];
  List<KotaModel> kotaLahir = [];
  List<Country> countries = [];
  bool isLoadingKota = false;
  bool isLoadingKotaLahir = false;
  bool isLoadingProvinsi = false;
  bool isLoadingProvinsiLahir = false;
  final _alamatController = TextEditingController();
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _tanggalLahirController = DateRangePickerController();
  final _formKey = GlobalKey<FormState>();
  ProvinsiModel? selectedProvinsi;
  KotaModel? selectedKota;
  ProvinsiModel? selectedProvinsiLahir;
  KotaModel? selectedKotaLahir;
  Country? selectedCountry;
  String gender = "";
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
        domisili:
            "${selectedProvinsi!.nama},${selectedKota!.nama},${_alamatController.text}",
        tanggalLahir: tanggalLahir!,
        noTelp: selectedCountry!.dialCode + _phoneController.text,
        jenisKelamin: gender,
        tempatLahir:
            "${selectedProvinsiLahir!.nama},${selectedKotaLahir!.nama}",
      );
      SignupResponseModel dataRes = await signupUseCase.SignUpAction(data);

      // if (mounted) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => const Login()),
      //   );
      // }
      if (dataRes.responseMessages == "Sukses") {
        final storageFlutter = FlutterSecureStorage();
        await storageFlutter.write(key: "loginAs", value: "user");
        await storageFlutter.write(key: "idUser", value: dataRes.user!.id);
        await storageFlutter.write(key: "nama", value: dataRes.user!.nama);
        await storageFlutter.write(key: "email", value: dataRes.user!.email);
        await storageFlutter.write(key: "noTelp", value: dataRes.user!.noTelp);
        return context.go("/home");
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
      isLoadingProvinsi = false;
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
        isLoadingKota = false;
      });
      return kota;
    } catch (e, st) {
      debugPrint('Error fetchDataKota: $e\n$st');
      return kota;
    }
  }

  Future<List<ProvinsiModel>> fetchDataProvinsiLahir() async {
    final result = await signupUseCase.getProvinsi();
    setState(() {
      provinsiLahir = result;
      isLoadingProvinsiLahir = false;
    });
    return provinsiLahir;
  }

  Future<List<KotaModel>> fetchDataKotaLahir(String provinceCode) async {
    setState(() {
      kotaLahir = [];
      isLoadingKotaLahir = true;
    });

    try {
      final result = await signupUseCase.getKota(provinceCode);
      setState(() {
        kotaLahir = result;
        isLoadingKotaLahir = false;
      });
      return kotaLahir;
    } catch (e, st) {
      debugPrint('Error fetchDataKota: $e\n$st');
      return kotaLahir;
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
    fetchDataProvinsiLahir();
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
                      "Lengkapi Form Pendaftaran",
                      style: GoogleFonts.figtree(
                        textStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Image.asset(
                      'assets/images/BG_Pelamar.png',
                      width: 500,
                      height: 500,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Isi data awalmu untuk melanjutkan registrasi.",
                      style: GoogleFonts.figtree(
                        textStyle: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
                            style: GoogleFonts.dancingScript(
                              textStyle: TextStyle(
                                color: Colors.blue,
                                letterSpacing: 2,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),

                        Container(
                          // height: 90,
                          margin: EdgeInsets.symmetric(vertical: 20),
                          child: TextFormField(
                            readOnly: true,
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
                                  initialValue: selectedCountry,
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
                                  readOnly: true,
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
                              ).smallerThan(DESKTOP);
                              return isMobile
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          child: Text(
                                            "Pilih Jenis Kelamin ",
                                            style: GoogleFonts.figtree(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontSize: 16,
                                              ),
                                            ),
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
                                                icon: Icon(
                                                  Icons.boy,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                                label: Text(
                                                  'Laki Laki',
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
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
                                                icon: Icon(
                                                  Icons.girl,
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                                label: Text(
                                                  'Perempuan',
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
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
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text(
                                            "Pilih Jenis Kelamin ",
                                            style: GoogleFonts.figtree(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontSize: 16,
                                              ),
                                            ),
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
                                              icon: Icon(
                                                Icons.boy,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                              label: Text(
                                                'Laki Laki',
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            ElevatedButton.icon(
                                              onPressed: () =>
                                                  _changeGender("P"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: gender == "P"
                                                    ? Colors.pink
                                                    : Colors.blue,
                                              ),
                                              icon: Icon(
                                                Icons.girl,
                                                color: Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                              ),
                                              label: Text(
                                                'Perempuan',
                                                style: TextStyle(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
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
                                "Tanggal Lahir",
                                style: GoogleFonts.figtree(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    letterSpacing: 2,
                                    fontSize: 16,
                                  ),
                                ),
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
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    headerStyle: DateRangePickerHeaderStyle(
                                      textAlign: TextAlign.center,
                                      backgroundColor: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      textStyle: TextStyle(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
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
                                  "Tempat Lahir",
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: isLoadingProvinsiLahir
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : DropdownButtonFormField<
                                            ProvinsiModel
                                          >(
                                            isExpanded: true,
                                            initialValue: selectedProvinsiLahir,
                                            hint: Text("Pilih Provinsi"),
                                            items: provinsiLahir.map((prov) {
                                              return DropdownMenuItem<
                                                ProvinsiModel
                                              >(
                                                value: prov,
                                                child: Text(prov.nama),
                                              );
                                            }).toList(),
                                            onChanged: (value) async {
                                              setState(() {
                                                kotaLahir = [];
                                                selectedKotaLahir = null;
                                                selectedProvinsiLahir = value;
                                              });

                                              if (value != null) {
                                                await fetchDataKotaLahir(
                                                  value.id,
                                                );
                                              } else {
                                                setState(() {
                                                  kotaLahir = [];
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
                                    child: isLoadingKotaLahir
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : DropdownButtonFormField<KotaModel>(
                                            isExpanded: true,
                                            initialValue: selectedKotaLahir,
                                            hint: Text("Pilih Kota"),

                                            items: kotaLahir.map((kota) {
                                              return DropdownMenuItem<
                                                KotaModel
                                              >(
                                                value: kota,
                                                child: Text(kota.nama),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                selectedKotaLahir = value;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              // contentPadding: EdgeInsets.symmetric(
                                              //   horizontal: 12,
                                              //   vertical: 8,
                                              // ),
                                              prefixIcon: Icon(
                                                Icons.location_city,
                                              ),
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
                                  "Domisili Sekarang",
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    // height: 90,
                                    flex: 1,
                                    child: isLoadingProvinsi
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : DropdownButtonFormField<
                                            ProvinsiModel
                                          >(
                                            isExpanded: true,
                                            initialValue: selectedProvinsi,
                                            hint: Text("Pilih Provinsi"),
                                            items: provinsi.map((prov) {
                                              return DropdownMenuItem<
                                                ProvinsiModel
                                              >(
                                                value: prov,
                                                child: Text(prov.nama),
                                              );
                                            }).toList(),
                                            onChanged: (value) async {
                                              setState(() {
                                                isLoadingKota = true;
                                                kota = [];
                                                selectedKota = null;
                                                selectedProvinsi = value;
                                              });

                                              if (value != null) {
                                                await fetchDataKota(value.id);
                                              } else {
                                                setState(() {
                                                  kota = [];
                                                  selectedKota = null;
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
                                    child: isLoadingKota
                                        ? CircularProgressIndicator(
                                            color: Colors.blue.shade400,
                                          )
                                        : DropdownButtonFormField<KotaModel>(
                                            isExpanded: true,
                                            initialValue:
                                                kota.contains(selectedKota)
                                                ? selectedKota
                                                : null,
                                            hint: Text("Pilih Kota"),

                                            items: kota.map((kota) {
                                              return DropdownMenuItem<
                                                KotaModel
                                              >(
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
                                              prefixIcon: Icon(
                                                Icons.location_city,
                                              ),
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
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                                onPressed: _handleSignUp,
                                icon: Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
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
