import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
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
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  _SignUpPelamar(this.name, this.email, this.photoUrl, this.token);
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Uint8List? _photoBytes;
  bool _loadingPhoto = false;

  Future<void> _handleSignUp() async {
    // final dataSource = AuthRemoteDatasource();
    // final repository = AuthRepositoryImpl(dataSource);
    // final usecase = SignupUseCase(repository);

    // final result = await usecase.SignUpAction(
    //   _emailController.text,
    //   _passwordController.text,
    // );

    // setState(() {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => Login()),
    //   );
    // });
    // print(selectedValue);
    // if (_formKey.currentState!.validate()) {
    //   if (selectedValue == "Pelamar") {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => SignUpPelamar()),
    //     );
    //   } else {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => SignUpPerusahaan()),
    //     );
    //   }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Harap lengkapi semua field!'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
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
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _photoBytes != null
                            ? MemoryImage(_photoBytes!)
                            : null,
                        child: _photoBytes == null ? Icon(Icons.person) : null,
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        height: 90,
                        width: 300,
                        child: TextFormField(
                          //controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 11,
                            ),
                          ),
                          initialValue: email,
                          // validator: (value) =>
                          //     value == null || value.isEmpty ? 'Wajib diisi' : null,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        width: 300,
                        child: TextFormField(
                          //controller: _namaController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 11,
                            ),
                          ),
                          initialValue: name,
                          validator: (value) => value == null || value.isEmpty
                              ? 'Wajib diisi'
                              : null,
                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
