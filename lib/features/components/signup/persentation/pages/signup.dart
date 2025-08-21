import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPelamar.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SignUp extends StatefulWidget {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;

  SignUp(this.name, this.email, this.photoUrl, this.token);
  @override
  State<SignUp> createState() =>
      _SignUp(this.name, this.email, this.photoUrl, this.token);
}

class _SignUp extends State<SignUp> {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;
  _SignUp(this.name, this.email, this.photoUrl, this.token);
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Uint8List? _photoBytes;
  bool _loadingPhoto = false;
  Future<void> fetchPhoto(String url, String accessToken) async {
    if (_loadingPhoto || _photoBytes != null) return;
    _loadingPhoto = true;
    try {
      final resp = await http.get(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print('status: ${resp.statusCode}');
      if (resp.statusCode == 200) {
        setState(() => _photoBytes = resp.bodyBytes);
      } else {
        print('photo fetch failed: ${resp.statusCode} ${resp.body}');
      }
    } catch (e) {
      print('fetch error: $e');
    } finally {
      _loadingPhoto = false;
    }
  }

  void _handleSignUpPelamar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPelamar(name, email, photoUrl, token),
      ),
    );
  }

  void _handleSignUpPerusahaan() {
    //  Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => SignUpPelamar(name, email, photoUrl, token),
    //       ),
    //     );
  }

  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 600,
                child: Text(
                  "Sign Up Sebagai",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              ElevatedButton(
                onPressed: _handleSignUpPelamar,
                child: Text(
                  'Sign Up Pelamar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _handleSignUpPerusahaan,
                child: Text(
                  'Sign Up Perusahaan',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
