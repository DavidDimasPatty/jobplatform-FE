import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/models/kota.dart';
import 'package:job_platform/features/components/signup/data/models/provinsi.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/responsive.dart';

class SignUpPerusahaan extends StatelessWidget {
  const SignUpPerusahaan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Responsive.isMobile(context)
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [_Logo(), _FormContent()],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 1200),
                child: const Row(
                  children: [
                    Expanded(child: _Logo()),
                    Expanded(child: Center(child: _FormContent())),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FlutterLogo(size: Responsive.isMobile(context) ? 100 : 200),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Yuk Kerja!",
            textAlign: TextAlign.center,
            style: Responsive.isMobile(context)
                ? Theme.of(context).textTheme.titleMedium
                : Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  // Controllers
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domainController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Use cases and repositories
  late SignupUseCase _signupUseCase;

  // State variables
  List<ProvinsiModel> _provinsiList = [];
  List<KotaModel> _kotaList = [];
  ProvinsiModel? _selectedProvinsi;
  KotaModel? _selectedKota;
  bool _isLoadingKota = false;

  @override
  void initState() {
    super.initState();
    _initializeUseCase();
    _fetchProvinsiData();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  void _initializeUseCase() {
    final dataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(dataSource);
    _signupUseCase = SignupUseCase(repository);
  }

  Future<void> _fetchProvinsiData() async {
    try {
      final result = await _signupUseCase.getProvinsi();
      if (mounted) {
        setState(() {
          _provinsiList = result
              .map((e) => ProvinsiModel(code: e.code, nama: e.nama))
              .toList();
        });
      }
    } catch (e) {
      debugPrint('Error fetching provinsi: $e');
      // You might want to show a snackbar or error message here
      if (mounted) {
        setState(() {
          _provinsiList = [];
        });
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
              .map((e) => KotaModel(code: e.code, nama: e.nama))
              .toList();
          _isLoadingKota = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching kota: $e');
      if (mounted) {
        setState(() {
          _isLoadingKota = false;
        });
      }
    }
  }

  void _onProvinsiChanged(ProvinsiModel? value) {
    setState(() {
      _selectedProvinsi = value;
      _selectedKota = null;
    });

    if (value != null) {
      _fetchKotaData(value.code);
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

  // void _navigateToLogin() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (context) => const HomePage()),
  //   );
  // }

  Future<void> _handleSignUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    try {
      final dataSource = AuthRemoteDatasource();
      final repository = AuthRepositoryImpl(dataSource);
      final usecase = SignupUseCase(repository);

      await usecase.SignUpAction(
        _nameController.text,
        _addressController.text,
      );

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

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      constraints: BoxConstraints(maxWidth: isMobile ? 400 : 800),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(isMobile),
            _buildGap(),
            _buildNameField(),
            _buildGap(),
            _buildLocationDropdowns(),
            _buildGap(),
            _buildAddressField(),
            _buildGap(),
            _buildPhoneField(),
            _buildGap(),
            _buildDomainField(),
            _buildGap(),
            _buildSignUpButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return Text(
      "Sign Up Perusahaan",
      style: isMobile
          ? Theme.of(context).textTheme.titleMedium
          : Theme.of(context).textTheme.titleLarge,
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

  Widget _buildPhoneField() {
    return TextFormField(
        controller: _phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: IntrinsicWidth(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.phone),
                  const SizedBox(width: 8),
                  const Text(
                    '+62',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          labelText: 'Nomor Telepon',
          hintText: 'Masukkan nomor telepon perusahaan Anda',
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
        onChanged: _onPhoneChanged,
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: _handleSignUp,
        child: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildGap() => const SizedBox(height: 16);
}
