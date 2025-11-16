import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/profile/data/models/profileCompanyRequest.dart';
import 'package:job_platform/features/components/profile/data/models/profileResponse.dart';
import 'package:job_platform/features/components/profile/domain/entities/ProfileCompanyData.dart';
import 'package:job_platform/features/components/profile/domain/usecases/profile_usecase.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/profile/data/repositories/auth_repository_impl.dart'
    as profileRepo;
import 'package:job_platform/features/components/profile/data/datasources/aut_remote_datasource.dart'
    as profileDataSource;
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/kota.dart';
import 'package:job_platform/features/components/signup/domain/entities/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:select2dot1/select2dot1.dart';

class Personalinfocompany extends StatefulWidget {
  Personalinfocompany({super.key});

  @override
  State<Personalinfocompany> createState() => _Personalinfocompany();
}

class _Personalinfocompany extends State<Personalinfocompany> {
  late ProfileCompanydata? dataCompany;
  List<ProvinsiModel> provinsi = [];
  List<KotaModel> kota = [];
  List<ProvinsiModel> provinsiLahir = [];
  List<KotaModel> kotaLahir = [];
  List<Country> countries = [];
  List<String> industries = [];
  SelectDataController? selectDataController;
  List<SingleCategoryModel> benefits = [];
  List<String> selectedBenefits = [];
  bool isLoading = true;
  bool isLoadingKota = false;
  bool isLoadingKotaLahir = false;
  bool isLoadingProvinsi = false;
  bool isLoadingProvinsiLahir = false;
  bool isLoadingIndstry = false;
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _industriController = TextEditingController();
  final _domainController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _twitterController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  ProvinsiModel? selectedProvinsi;
  KotaModel? selectedKota;
  ProvinsiModel? selectedProvinsiLahir;
  KotaModel? selectedKotaLahir;
  Country? selectedCountry;
  String? selectedIndustries = "";
  late SignupUseCase signupUseCase;
  late ProfileUsecase profileUsecase;
  String? errorMessage;

  Future<void> _loadProfileData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany != null) {
        var profile = await profileUsecase.getProfileCompany(idCompany);
        if (!mounted) return;

        if (profile != null) {
          setState(() {
            dataCompany = profile;
            isLoading = false;
          });
        }
      } else {
        print("User ID not found in SharedPreferences");
      }
    } catch (e) {
      print("Error loading profile data: $e");
      if (!mounted) return;

      setState(() {
        errorMessage = "Error loading profile: $e";
        isLoading = false;
      });
    }
  }

  Future _handleEditProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? idCompany = prefs.getString('idCompany');

      if (idCompany == null)
        throw Exception("Company ID not found in preferences");

      ProfileCompanyRequest profile = new ProfileCompanyRequest(
        idCompany: idCompany,
        nama: _namaController.text,
        alamat:
            "${_alamatController.text}, ${selectedKota?.nama}, ${selectedProvinsi?.nama}",
        domain: _domainController.text,
        noTelp: "${selectedCountry!.dialCode}${_phoneController.text}",
        benefit: selectedBenefits,
        deskripsi: _deskripsiController.text,
        facebook: _facebookController.text,
        industri: selectedIndustries,
        instagram: _instagramController.text,
        linkedin: _linkedinController.text,
        tiktok: _tiktokController.text,
        twitter: _twitterController.text,
      );

      ProfileResponse response = await profileUsecase.editProfileCompany(
        profile,
      );
      if (response.responseMessage == 'Sukses') {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Profile edited successfully!')));
        context.go('/profileCompany');
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

  Future<List<ProvinsiModel>> fetchDataProvinsiFirst() async {
    final result = await signupUseCase.getProvinsi();
    setState(() {
      selectedProvinsi = result
          .where((e) => e.nama == dataCompany!.alamat!.split(', ')[2])
          .first;
      fetchDataKotaFirst(selectedProvinsi!.id);
    });
    return provinsi;
  }

  Future<List<KotaModel>> fetchDataKotaFirst(String provinceCode) async {
    setState(() {
      kota = [];
      isLoadingKota = true;
    });

    try {
      final result = await signupUseCase.getKota(provinceCode);
      setState(() {
        kota = result.cast<KotaModel>();
        isLoadingKota = false;
        selectedKota = result
            .where((e) => e.nama == dataCompany!.alamat!.split(', ')[1])
            .first;
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

  Future<List<String>> loadIndustries() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/core/constant/industries.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<String> jsonList = List<String>.from(data['industries']);

      setState(() {
        if (industries.isEmpty) {
          industries = jsonList;
          selectedIndustries = industries.firstWhere(
            (e) => e == dataCompany!.industri,
            orElse: () => industries.first,
          );
        } else {
          selectedIndustries = null;
        }
      });

      return industries;
    } catch (e) {
      debugPrint('Error load Industri: $e');
      return industries;
    }
  }

  Future<void> loadBenefits() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/core/constant/benefits.json',
      );
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<String> list = List<String>.from(data['benefits']);

      final items = list
          .map((b) => SingleItemCategoryModel(nameSingleItem: b, value: b))
          .toList();

      final singleCategory = SingleCategoryModel(
        nameCategory: null,
        singleItemCategoryList: items,
      );

      final selectedItems = items
          .where(
            (i) => dataCompany?.benefit!.contains(i.nameSingleItem) ?? false,
          )
          .toList();

      setState(() {
        selectedBenefits = selectedItems
            .map<String>((e) => (e.value ?? e.nameSingleItem).toString())
            .toList();

        selectDataController = SelectDataController(
          data: [singleCategory],
          isMultiSelect: true,
          initSelected: selectedItems,
        );
      });

      debugPrint("✅ Benefit loaded: ${items.length} items");
    } catch (e) {
      debugPrint('❌ Error loadBenefit: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }

  Future<void> _initialize() async {
    final remoteDataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(remoteDataSource);
    signupUseCase = SignupUseCase(repository);

    final profileSource = profileDataSource.AuthRemoteDataSource();
    final profileRepository = profileRepo.AuthRepositoryImpl(profileSource);
    profileUsecase = ProfileUsecase(profileRepository);

    await _loadProfileData();

    await Future.wait([
      fetchDataProvinsi(),
      fetchDataProvinsiFirst(),
      loadCountries(),
      loadIndustries(),
      loadBenefits(),
    ]);
    setState(() {
      _domainController.text = dataCompany?.domain ?? '';
      _facebookController.text = dataCompany?.facebook ?? '';
      _tiktokController.text = dataCompany?.tiktok ?? '';
      _twitterController.text = dataCompany?.twitter ?? '';
      _linkedinController.text = dataCompany?.linkedin ?? '';
      _instagramController.text = dataCompany?.instagram ?? '';
      _industriController.text = dataCompany?.industri ?? '';
      _namaController.text = dataCompany?.nama ?? '';
      _alamatController.text = dataCompany?.alamat?.split(', ').first ?? '';
      _phoneController.text = dataCompany?.noTelp?.substring(3) ?? '';
      _deskripsiController.text = dataCompany?.deskripsi ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading profile data...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 16),
            ElevatedButton(onPressed: _loadProfileData, child: Text('Retry')),
          ],
        ),
      );
    }

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
            layout: ResponsiveRowColumnType.COLUMN,
            rowSpacing: 100,
            columnSpacing: 20,
            children: [
              ResponsiveRowColumnItem(
                rowFlex: 2,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  margin: EdgeInsets.all(10),
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
                  child: Padding(
                    padding: EdgeInsets.all(20),
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
                                  "Company Info",
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
                                    labelText: 'Nama',
                                    hintText: 'Masukan Nama',
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

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                // height: 90,
                                child: TextFormField(
                                  controller: _deskripsiController,
                                  decoration: InputDecoration(
                                    labelText: 'Deskripsi Profile',
                                    hintText: 'Masukan Deskripsi Profile',
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
                                child: isLoadingIndstry
                                    ? CircularProgressIndicator(
                                        color: Colors.blue.shade400,
                                      )
                                    : DropdownButtonFormField<String>(
                                        isExpanded: true,
                                        initialValue: selectedIndustries,
                                        hint: Text("Pilih Industri"),
                                        items: industries.map((ind) {
                                          return DropdownMenuItem<String>(
                                            value: ind,
                                            child: Text(ind),
                                          );
                                        }).toList(),
                                        onChanged: (value) async {
                                          setState(() {
                                            selectedIndustries = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          prefixIcon: Icon(Icons.code),
                                        ),
                                      ),
                              ),

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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Flexible(
                                                  child: Text(
                                                    country.dialCode,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                        key: ValueKey(
                                          selectedCountry?.dialCode,
                                        ),
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          labelText: 'Nomor Telepon',
                                          hintText:
                                              'Masukkan nomor telepon Anda',
                                          border: const OutlineInputBorder(),
                                          prefixIcon: IntrinsicWidth(
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Text(
                                                selectedCountry?.dialCode ??
                                                    '+62',
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
                                            _phoneController.value =
                                                TextEditingValue(
                                                  text: newValue,
                                                  selection:
                                                      TextSelection.collapsed(
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

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsGeometry.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Text(
                                        "Lokasi",
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
                                                  initialValue:
                                                      selectedProvinsi,
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
                                                      await fetchDataKota(
                                                        value.id,
                                                      );
                                                    } else {
                                                      setState(() {
                                                        kota = [];
                                                        selectedKota = null;
                                                      });
                                                    }
                                                  },
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
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
                                              : DropdownButtonFormField<
                                                  KotaModel
                                                >(
                                                  isExpanded: true,
                                                  initialValue:
                                                      kota.contains(
                                                        selectedKota,
                                                      )
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
                                                    border:
                                                        OutlineInputBorder(),
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
                                      margin: EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
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
                                            return "Format alamat tidak valid";
                                          }

                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              selectDataController == null
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Benefit Perusahaan",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                letterSpacing: 2,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Select2dot1(
                                            selectDataController:
                                                selectDataController!,
                                            onChanged: (selected) {
                                              final values = selected
                                                  .map<String>(
                                                    (e) =>
                                                        (e.value ??
                                                                e.nameSingleItem)
                                                            .toString(),
                                                  )
                                                  .toList();

                                              setState(() {
                                                selectedBenefits = values;
                                              });
                                              debugPrint("Terpilih: $values");
                                            },
                                          ),
                                        ],
                                      ),
                                    ),

                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "Company Info",
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      letterSpacing: 2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _domainController,
                                  decoration: InputDecoration(
                                    labelText: 'Domain',
                                    hintText: 'Masukan Domain Perusahaan',
                                    prefixIcon: Icon(Icons.domain),
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
                                      return 'Format domain tidak valid';
                                    }

                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _linkedinController,
                                  decoration: InputDecoration(
                                    labelText: 'Linkedin',
                                    hintText: 'Masukan Nama Linkedin',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.linkedin,
                                        color: Colors.blue,
                                      ),
                                    ),
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
                                      r'^[a-zA-Z0-9\s\-\.,]+$',
                                    );
                                    if (!regex.hasMatch(value)) {
                                      return "Format username LinkedIn tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _facebookController,
                                  decoration: InputDecoration(
                                    labelText: 'Facebook',
                                    hintText: 'Masukan Nama Facebook',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: Icon(
                                        Icons.facebook,
                                        color: Colors.blue,
                                      ),
                                    ),
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
                                      r'^[a-zA-Z0-9\s\-\.,]+$',
                                    );
                                    if (!regex.hasMatch(value)) {
                                      return "Format username Facebook tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _twitterController,
                                  decoration: InputDecoration(
                                    labelText: 'Twitter',
                                    hintText: 'Masukan Username',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 5,
                                      ),
                                      child: FaIcon(FontAwesomeIcons.xTwitter),
                                    ),
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
                                      r'^[a-zA-Z0-9\s\-\.,]+$',
                                    );
                                    if (!regex.hasMatch(value)) {
                                      return "Format username Twitter tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _instagramController,
                                  decoration: InputDecoration(
                                    labelText: 'Instagram',
                                    hintText: 'Masukan Username',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.instagram,
                                        color: Colors.purpleAccent,
                                      ),
                                    ),
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
                                      r'^[a-zA-Z0-9\s\-\.,]+$',
                                    );
                                    if (!regex.hasMatch(value)) {
                                      return "Format username Instagram tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                child: TextFormField(
                                  controller: _tiktokController,
                                  decoration: InputDecoration(
                                    labelText: 'Tiktok',
                                    hintText: 'Masukan Username',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                        top: 10,
                                      ),
                                      child: FaIcon(
                                        FontAwesomeIcons.tiktok,
                                        size: 18,
                                      ),
                                    ),
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
                                      r'^[a-zA-Z0-9\s\-\.,]+$',
                                    );
                                    if (!regex.hasMatch(value)) {
                                      return "Format username TikTok tidak valid";
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                      ),
                                      onPressed: _handleEditProfile,
                                      icon: Icon(
                                        Icons.check,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
