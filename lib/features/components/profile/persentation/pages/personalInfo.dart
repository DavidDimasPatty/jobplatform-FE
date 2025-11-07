import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/models/profileRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileData.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart'
    as profileRepo;
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart'
    as profileDataSource;
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Personalinfo extends StatefulWidget {
  final Profiledata userProfile;

  const Personalinfo({super.key, required this.userProfile});

  @override
  State<Personalinfo> createState() => _Personalinfo(data: userProfile);
}

class _Personalinfo extends State<Personalinfo> {
  final Profiledata data;

  _Personalinfo({required this.data});

  List<ProvinsiModel> provinsi = [];
  List<KotaModel> kota = [];
  List<ProvinsiModel> provinsiLahir = [];
  List<KotaModel> kotaLahir = [];
  List<Country> countries = [];
  bool isLoadingKota = false;
  bool isLoadingKotaLahir = false;
  bool isLoadingProvinsi = false;
  bool isLoadingProvinsiLahir = false;

  // Global Key
  final _formKey = GlobalKey<FormState>();

  // Controller
  final _headLineController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _linkPortofolioController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();

  // Helper variable
  ProvinsiModel? selectedProvinsi;
  KotaModel? selectedKota;
  ProvinsiModel? selectedProvinsiLahir;
  KotaModel? selectedKotaLahir;
  Country? selectedCountry;
  String gender = "";
  DateTime? birthDate;
  bool isVisible = false;
  Uint8List? cvBytes;
  String? cvFileName;
  Uint8List? avatarBytes;
  String? avatarFileName;

  // Usecase Instance
  late SignupUseCase signupUseCase;
  late ProfileUsecase profileUsecase;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    signupUseCase = SignupUseCase(repository);

    final profileSource = profileDataSource.AuthRemoteDataSource();
    final profileRepository = profileRepo.AuthRepositoryImpl(profileSource);
    profileUsecase = ProfileUsecase(profileRepository);

    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.wait([
      fetchDataProvinsi(),
      fetchDataProvinsiLahir(),
      // loadCountries(),
    ]);

    _loadData();
  }

  void _loadData() {
    _namaController.text = data.nama;
    gender = data.jenisKelamin;
    _headLineController.text = data.headline ?? '';
    _deskripsiController.text = data.ringkasan ?? '';
    _linkPortofolioController.text = data.linkPorto!.join(',');
    birthDate = data.tanggalLahir;

    var [dataProv, dataKota, dataAlamat] = data.domisili!.split(',');
    selectedProvinsi = provinsi.firstWhere((p) => p.nama == dataProv);
    if (selectedProvinsi != null) {
      fetchDataKota(selectedProvinsi!.id).then((_) {
        setState(() {
          selectedKota = kota.firstWhere((k) => k.nama == dataKota);
        });
      });
    }
    _alamatController.text = dataAlamat;

    var [dataProvLahir, dataKotaLahir] = data.tempatLahir.split(',');
    selectedProvinsiLahir = provinsiLahir.firstWhere(
      (p) => p.nama == dataProvLahir,
    );
    if (selectedProvinsiLahir != null) {
      fetchDataKotaLahir(selectedProvinsiLahir!.id).then((_) {
        setState(() {
          selectedKotaLahir = kotaLahir.firstWhere(
            (k) => k.nama == dataKotaLahir,
          );
        });
      });
    }

    isVisible = data.isVisible ?? false;

    if (data.cv != null) {
      cvFileName = data.cv!.split('/').last;
    }
  }

  Future _handleEditProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idUser = prefs.getString('idUser');

      // Ensure idUser is not null
      if (idUser == null) throw Exception("User ID not found in preferences");

      List<String> portofolioList = _linkPortofolioController.text.split(',');

      ProfileRequest profile = new ProfileRequest(
        idUser: idUser,
        nama: _namaController.text,
        tanggalLahir: birthDate,
        tempatLahir:
            "${selectedProvinsiLahir?.nama},${selectedKotaLahir?.nama}",
        jenisKelamin: gender,
        domisili:
            "${selectedProvinsi?.nama},${selectedKota?.nama},${_alamatController.text}",
        cv: cvBytes,
        headline: _headLineController.text,
        ringkasan: _deskripsiController.text,
        visibility: isVisible,
        seekStatus: 1,
        linkPorto: portofolioList,
      );

      if (avatarBytes != null) {
        ProfileRequest avatarUpdate = new ProfileRequest(
          idUser: idUser,
          photo: avatarBytes,
        );

        ProfileResponse responseAvatar = await profileUsecase.editProfileAvatar(
          avatarUpdate,
        );

        if (responseAvatar.responseMessage != 'Sukses') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseAvatar.responseMessage),
              backgroundColor: Colors.red,
            ),
          );

          return;
        }
      }

      ProfileResponse response = await profileUsecase.editProfile(profile);
      // On success, clear the form or navigate away
      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile edited successfully!')));
        context.go('/profile');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to edit profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _formKey.currentState!.reset();
    } catch (e) {
      debugPrint('Error during edit profile: $e');
      // Show error message to user
      if (mounted) {
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Edit profile failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickTanggalLahir(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        birthDate = picked;
      });
    }
  }

  void _changeGender(String genderSelect) {
    setState(() {
      gender = genderSelect;
    });
  }

  Future<void> _pickCVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        Uint8List? bytes;

        // Get bytes (works for both web and mobile)
        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          bytes = await File(file.path!).readAsBytes();
        }

        if (file.path != null) {
          setState(() {
            cvBytes = bytes;
            cvFileName = file.name;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        Uint8List? bytes;

        // Get bytes (works for both web and mobile)
        if (file.bytes != null) {
          bytes = file.bytes;
        } else if (file.path != null) {
          bytes = await File(file.path!).readAsBytes();
        }

        if (file.path != null) {
          setState(() {
            avatarBytes = bytes;
            avatarFileName = file.name;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking file: $e')));
    }
  }

  Future<List<ProvinsiModel>> fetchDataProvinsi() async {
    final result = await signupUseCase.getProvinsi();
    setState(() {
      provinsi = result.cast<ProvinsiModel>();
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
        kota = result.cast<KotaModel>();
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
      final List<dynamic> jsonList = jsonDecode(jsonString);
      final loaded = jsonList
          .map((e) => Country.fromJson(e as Map<String, dynamic>))
          .toList();

      String fullNumber = data.noTelp;
      if (!fullNumber.startsWith('+')) {
        fullNumber = '+' + fullNumber;
      }

      Country? foundCountry;
      for (Country country
          in loaded
            ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length))) {
        if (fullNumber.startsWith(country.dialCode)) {
          foundCountry = country;
          _phoneController.text = fullNumber.substring(country.dialCode.length);
          break;
        }
      }

      setState(() {
        countries = loaded;
        selectedCountry =
            foundCountry ??
            loaded.firstWhere(
              (c) => c.dialCode == '+62',
              orElse: () => loaded.first,
            );
      });

      return countries;
    } catch (e) {
      debugPrint('Error load countries: $e');
      return countries;
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
                              "Personal Info",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.blue,
                                letterSpacing: 2,
                                fontSize: 30,
                              ),
                            ),
                          ),

                          Center(
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 46,
                                    backgroundImage: avatarBytes == null
                                        ? (data.photoURL != null
                                              ? NetworkImage(data.photoURL!)
                                              : (data.jenisKelamin == "L"
                                                    ? AssetImage(
                                                        'assets/images/male-avatar.png',
                                                      )
                                                    : AssetImage(
                                                        'assets/images/female-avatar.png',
                                                      )))
                                        : MemoryImage(avatarBytes!),
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                ),

                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: _pickProfileImage,
                                    ),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Nama Tidak Boleh Kosong";
                                      }
                                      final regex = RegExp(
                                        r'^[a-zA-Z0-9\s\-\.,]+$',
                                      );
                                      if (!regex.hasMatch(value)) {
                                        return "Format nama tidak valid";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _headLineController,
                              decoration: InputDecoration(
                                labelText: 'Headline',
                                hintText: 'Masukan Headline',
                                prefixIcon: Icon(Icons.info),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 11,
                                ),
                              ),
                              // initialValue: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                final regex = RegExp(
                                  r'^[a-zA-Z0-9\s\-\.,\/\\]+$',
                                );
                                if (!regex.hasMatch(value)) {
                                  return "Format Headline tidak valid";
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            // height: 90,
                            child: TextFormField(
                              controller: _deskripsiController,
                              decoration: InputDecoration(
                                labelText: 'Deskripsi Profile',
                                hintText: 'Masukan Deskripsi Profile',
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }
                                final regex = RegExp(
                                  r'^[a-zA-Z0-9\s\-\.,\/\\]+$',
                                );
                                if (!regex.hasMatch(value)) {
                                  return "Format deskripsi tidak valid";
                                }
                                return null;
                              },
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: _linkPortofolioController,
                              decoration: InputDecoration(
                                labelText: 'Link Portofolio',
                                hintText: 'Masukan Link portofolio',
                                prefixIcon: Icon(Icons.link),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 11,
                                ),
                              ),
                              // initialValue: email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return null;
                                }

                                final regex = RegExp(
                                  r'^(https?:\/\/)?(www\.)?[a-zA-Z0-9\-]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?$',
                                );

                                if (!regex.hasMatch(value)) {
                                  return 'Format portofolio tidak valid';
                                }

                                return null;
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 8,
                              children: [
                                Text(
                                  "Jenis Kelamin",
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Wrap(
                                  spacing: 10,
                                  children: [
                                    InputChip(
                                      label: Text('Laki - Laki'),
                                      selected: gender == 'L',
                                      onSelected: (selected) =>
                                          _changeGender('L'),
                                      selectedColor: Colors.lightBlue.shade300,
                                      backgroundColor: Colors.lightBlue.shade50,
                                      checkmarkColor: Colors.white,
                                    ),
                                    InputChip(
                                      label: Text('Perempuan'),
                                      selected: gender == 'P',
                                      onSelected: (selected) =>
                                          _changeGender('P'),
                                      selectedColor: Colors.lightBlue.shade300,
                                      backgroundColor: Colors.lightBlue.shade50,
                                      checkmarkColor: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          InkWell(
                            onTap: () => _pickTanggalLahir(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.calendar_today),
                                labelText: "Tanggal Lahir",
                                border: OutlineInputBorder(),
                              ),
                              child: Text(
                                birthDate != null
                                    ? DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(birthDate!)
                                    : "Pilih tanggal",
                              ),
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
                                              initialValue:
                                                  selectedProvinsiLahir,
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
                                                prefixIcon: Icon(
                                                  Icons.gps_fixed,
                                                ),
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
                                                prefixIcon: Icon(
                                                  Icons.gps_fixed,
                                                ),
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
                              ],
                            ),
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Alamat Tidak Boleh Kosong";
                                }

                                final regex = RegExp(
                                  r'^[a-zA-Z0-9\s\-\.,\/\\]+$',
                                );
                                if (!regex.hasMatch(value)) {
                                  return "Format alamat domisili tidak valid";
                                }

                                return null;
                              },
                            ),
                          ),

                          Container(
                            // height: 90,
                            margin: EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Upload CV",
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
                                InkWell(
                                  onTap: _pickCVFile,
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.upload_file),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            cvFileName ??
                                                'Click to select file',
                                            style: TextStyle(
                                              color: cvFileName != null
                                                  ? Colors.black
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                        if (cvFileName != null)
                                          IconButton(
                                            icon: Icon(
                                              Icons.close,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                cvBytes = null;
                                                cvFileName = null;
                                              });
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              Switch(
                                trackColor:
                                    const WidgetStateProperty<Color?>.fromMap(
                                      <WidgetState, Color>{
                                        WidgetState.selected: Colors.lightBlue,
                                      },
                                    ),
                                value: isVisible,
                                onChanged: (bool value) {
                                  setState(() {
                                    isVisible = value;
                                  });
                                },
                              ),
                              Text('Visible from HR'),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: _handleEditProfile,
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
