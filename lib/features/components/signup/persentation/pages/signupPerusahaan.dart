import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
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
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _domainController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> _handleSignUp() async {
    final dataSource = AuthRemoteDatasource();
    final repository = AuthRepositoryImpl(dataSource);
    final usecase = SignupUseCase(repository);

    final result = await usecase.SignUpAction(
      _nameController.text,
      _addressController.text,
    );

    setState(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: Responsive.isMobile(context)
          ? const BoxConstraints(maxWidth: 400)
          : const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Sign Up Perusahaan",
              style: Responsive.isMobile(context)
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextFormField(
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
            ),
            _gap(),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                hintText: 'Masukkan alamat perusahaan Anda',
                prefixIcon: Icon(Icons.room),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            _gap(),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.phone),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                  child: const Text("+62", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
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
                    onChanged: (value) {
                      // Remove leading zeros as user types
                      if (value.startsWith('0')) {
                        final newValue = value.replaceFirst(RegExp(r'^0+'), '');
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
            _gap(),
            TextFormField(
              controller: _domainController,
              decoration: const InputDecoration(
                labelText: 'Domain',
                hintText: 'Masukkan domain perusahaan Anda',
                prefixIcon: Icon(Icons.public),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Domain tidak boleh kosong';
                }
                if (!RegExp(
                  r'^[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)+$',
                ).hasMatch(value)) {
                  return 'Masukkan domain yang valid';
                }
                return null;
              },
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _handleSignUp();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
