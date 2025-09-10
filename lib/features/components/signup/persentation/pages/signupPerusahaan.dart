import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/country.dart';
import 'package:job_platform/features/components/signup/data/models/kota.dart';
import 'package:job_platform/features/components/signup/data/models/provinsi.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';
import 'package:job_platform/features/components/signup/domain/entities/signupResponse.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPerusahaan extends StatelessWidget {
  final String? email;

  const SignUpPerusahaan(this.email, {super.key});

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
        padding: const EdgeInsets.all(20.0),
        child: ResponsiveRowColumn(
          layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
              ? ResponsiveRowColumnType.COLUMN
              : ResponsiveRowColumnType.ROW,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowMainAxisAlignment: MainAxisAlignment.center,
          columnMainAxisAlignment: MainAxisAlignment.center,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          rowSpacing: 100,
          columnSpacing: 20,
          children: [
            ResponsiveRowColumnItem(rowFlex: 3, child: _Logo()),
            ResponsiveRowColumnItem(rowFlex: 2, child: _FormContent(email)),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Image.asset('assets/images/BG_HRD.png', width: 500, height: 500),
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
    );
  }
}

class _FormContent extends StatefulWidget {
  final String? email;

  const _FormContent(this.email);

  @override
  State<_FormContent> createState() => __FormContentState(this.email);
}

class __FormContentState extends State<_FormContent> {
  final String? email;

  __FormContentState(this.email);

  // Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Use cases and repositories
  late SignupUseCase _signupUseCase;

  // State variables
  List<Country> _countryList = [];
  List<ProvinsiModel> _provinsiList = [];
  List<KotaModel> _kotaList = [];
  Country? _selectedCountry;
  ProvinsiModel? _selectedProvinsi;
  KotaModel? _selectedKota;
  bool _isLoadingKota = false;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _fetchProvinsiData();
    _fetchCountryData();
    _emailController.text = email!;
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _domainController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(dataSource);
    _signupUseCase = SignupUseCase(repository);
  }

  Future<void> _fetchCountryData() async {
    try {
      final jsonString = await rootBundle.loadString(
        'lib/core/constant/phoneNumber.json',
      );
      final List<dynamic> jsonList = jsonDecode(jsonString);

      if (mounted) {
        _countryList = jsonList
            .map((e) => Country.fromJson(e as Map<String, dynamic>))
            .toList();

        // Set Indonesia as default, or first country if Indonesia not found
        _selectedCountry = _countryList.firstWhere(
          (c) => c.code.toUpperCase() == 'ID' || c.dialCode == '+62',
          orElse: () => _countryList.first,
        );
      }
    } catch (e) {
      debugPrint('Error load countries: $e');
      if (mounted) {
        setState(() {
          _countryList = [];
          _selectedCountry = null;
        });

        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load country data'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _fetchProvinsiData() async {
    try {
      final result = await _signupUseCase.getProvinsi();
      if (mounted) {
        setState(() {
          _provinsiList = result
              .map((e) => ProvinsiModel(id: e.id, nama: e.nama))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching provinsi: $e');
      if (mounted) {
        setState(() {
          _provinsiList = [];
          _selectedProvinsi = null;
        });

        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load provinsi data'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  Future<void> _fetchKotaData(String provinceCode) async {
    setState(() {
      _kotaList = [];
      _isLoadingKota = true;
      _selectedKota = null; // Reset selected kota
    });

    try {
      final result = await _signupUseCase.getKota(provinceCode);
      if (mounted) {
        setState(() {
          _kotaList = result
              .map((e) => KotaModel(id: e.id, nama: e.nama))
              .toList();
          _isLoadingKota = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching kota: $e');
      if (mounted) {
        setState(() {
          _kotaList = [];
          _selectedKota = null;
          _isLoadingKota = false;
        });
      }

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load kota data'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _onCountryChanged(Country? value) {
    setState(() {
      _selectedCountry = value;
    });
  }

  void _onProvinsiChanged(ProvinsiModel? value) {
    setState(() {
      _selectedProvinsi = value;
      _selectedKota = null;
    });

    if (value != null) {
      _fetchKotaData(value.id);
    } else {
      setState(() {
        _kotaList = [];
      });
    }
  }

  void _onKotaChanged(KotaModel? value) {
    setState(() {
      _selectedKota = value;
    });
  }

  String _formatPhoneNumber(String value) {
    // Remove leading zeros
    return value.replaceFirst(RegExp(r'^0+'), '');
  }

  void _onPhoneChanged(String value) {
    if (value.startsWith('0')) {
      final newValue = _formatPhoneNumber(value);
      _phoneController.value = TextEditingValue(
        text: newValue,
        selection: TextSelection.collapsed(offset: newValue.length),
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      SignupRequestModel data = SignupRequestModel(
        registerAs: "company",
        email: _emailController.text,
        nama: _nameController.text,
        alamat:
            "${_addressController.text}, ${_selectedKota!.nama}, ${_selectedProvinsi!.nama}",
        noTelp: _selectedCountry!.dialCode + _phoneController.text,
        domainPerusahaan: _domainController.text,
      );

      SignupResponseModel response = await _signupUseCase.SignUpAction(data);

      if (response.responseMessages == "Sukses") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("loginAs", "company");
        await prefs.setString("idCompany", response.company!.id);
        await prefs.setString("nama", response.company!.nama);
        await prefs.setString("email", response.company!.email);
        await prefs.setString("noTelp", response.company!.noTelp);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.responseMessages),
            backgroundColor: Colors.red,
          ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTitle(),
              _buildGap(),
              _buildNameField(),
              _buildGap(),
              _buildLocationDropdowns(),
              _buildGap(),
              _buildAddressField(),
              _buildGap(),
              _buildPhoneField(),
              _buildGap(),
              _buildEmailField(),
              _buildGap(),
              _buildDomainField(),
              _buildGap(),
              _buildSignUpButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Text(
      "Sign Up Perusahaan",
      textAlign: TextAlign.center,
      style: GoogleFonts.dancingScript(
        textStyle: TextStyle(
          color: Colors.blue,
          letterSpacing: 2,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Nama',
        hintText: 'Masukkan nama perusahaan Anda',
        prefixIcon: Icon(Icons.business),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildLocationDropdowns() {
    return Row(
      children: [
        Expanded(child: _buildProvinsiDropdown()),
        const SizedBox(width: 12),
        Expanded(child: _buildKotaDropdown()),
      ],
    );
  }

  Widget _buildProvinsiDropdown() {
    return DropdownButtonFormField<ProvinsiModel>(
      value: _selectedProvinsi,
      decoration: const InputDecoration(
        labelText: 'Provinsi',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.map),
      ),
      items: _provinsiList.map((provinsi) {
        return DropdownMenuItem(value: provinsi, child: Text(provinsi.nama));
      }).toList(),
      onChanged: _onProvinsiChanged,
      validator: (value) {
        if (value == null) {
          return 'Provinsi tidak boleh kosong';
        }
        return null;
      },
      isExpanded: true,
    );
  }

  Widget _buildKotaDropdown() {
    return DropdownButtonFormField<KotaModel>(
      value: _selectedKota,
      decoration: InputDecoration(
        labelText: 'Kota',
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.location_city),
        suffixIcon: _isLoadingKota
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
      ),
      items: _kotaList.map((kota) {
        return DropdownMenuItem(value: kota, child: Text(kota.nama));
      }).toList(),
      onChanged: _kotaList.isNotEmpty && !_isLoadingKota
          ? _onKotaChanged
          : null,
      validator: (value) {
        if (_selectedProvinsi != null &&
            _kotaList.isNotEmpty &&
            value == null) {
          return 'Kota tidak boleh kosong';
        }
        return null;
      },
      disabledHint: Text(
        _selectedProvinsi == null
            ? 'Pilih provinsi dulu'
            : _isLoadingKota
            ? 'Memuat kota...'
            : 'Tidak ada kota tersedia',
      ),
      isExpanded: true,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: const InputDecoration(
        labelText: 'Alamat',
        hintText: 'Masukkan alamat perusahaan Anda',
        prefixIcon: Icon(Icons.location_on),
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Alamat tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      readOnly: true,
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Masukkan email perusahaan Anda',
        prefixIcon: Icon(Icons.mail),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email perusahaan tidak boleh kosong';
        }
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Format email tidak valid!';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Country Code Dropdown
        Container(
          width: 150,
          child: DropdownButtonFormField<Country>(
            initialValue: _selectedCountry,
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            items: _countryList.map((country) {
              return DropdownMenuItem(
                value: country,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(country.flag, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        country.code,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        country.dialCode,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: _onCountryChanged,
            validator: (value) {
              if (value == null) {
                return 'Required';
              }
              return null;
            },
            isExpanded: true,
            isDense: true,
          ),
        ),
        // Phone Number Field
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Nomor Telepon',
              hintText: 'Masukkan nomor telepon',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nomor telepon tidak boleh kosong';
              }
              if (!RegExp(r'^[0-9]{7,15}$').hasMatch(value)) {
                return 'Masukkan nomor telepon yang valid';
              }
              return null;
            },
            onChanged: _onPhoneChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDomainField() {
    return TextFormField(
      controller: _domainController,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
        labelText: 'Domain',
        hintText: 'contoh.com',
        prefixIcon: Icon(Icons.language),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Domain tidak boleh kosong';
        }
        if (!RegExp(r'^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$').hasMatch(value)) {
          return 'Masukkan domain yang valid (contoh: perusahaan.com)';
        }
        return null;
      },
    );
  }

  Widget _buildSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Directionality(
          textDirection: TextDirection.rtl,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            onPressed: _handleSignUp,
            icon: const Icon(Icons.check, color: Colors.white),
            label: const Text('Sign Up', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildGap() => const SizedBox(height: 16);
}
