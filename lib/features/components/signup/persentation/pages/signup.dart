import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPelamar.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignUp extends StatefulWidget {
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;

  const SignUp(this.name, this.email, this.photoUrl, this.token, {super.key});
  @override
  State<SignUp> createState() => _SignUp(name, email, photoUrl, token);
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpPerusahaan(email)),
    );
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
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = ResponsiveBreakpoints.of(
            context,
          ).smallerThan(DESKTOP);
          // return !isMobile
          //     ? Center(
          //         child: Padding(
          //           padding: const EdgeInsets.all(16.0),
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             children: [
          //               Container(
          //                 padding: EdgeInsets.all(20),
          //                 child: Text(
          //                   "Sign Up Sebagai",
          //                   textAlign: TextAlign.center,
          //                   style: TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 20,
          //                   ),
          //                 ),
          //               ),
          //               ElevatedButton(
          //                 onPressed: _handleSignUpPelamar,
          //                 child: Text(
          //                   'Sign Up Pelamar',
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //               ),
          //               SizedBox(height: 50),
          //               ElevatedButton(
          //                 onPressed: _handleSignUpPerusahaan,
          //                 child: Text(
          //                   'Sign Up Perusahaan',
          //                   style: TextStyle(color: Colors.black),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       )
          //     :
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dancingScript(
                      textStyle: TextStyle(
                        color: Colors.blue,
                        letterSpacing: 5,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: _handleSignUpPelamar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            shape: StadiumBorder(),
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  'assets/images/BG_Pelamar.png',
                                  width: 500,
                                  height: 500,
                                ),
                              ),
                              SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Signup Pelamar',
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: 20,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height - 200,
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Container(
                        child: ElevatedButton(
                          onPressed: _handleSignUpPerusahaan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            shape: StadiumBorder(),
                            shadowColor: Colors.transparent,
                            overlayColor: Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.only(bottom: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Image.asset(
                                  'assets/images/BG_HRD.png',
                                  width: 500,
                                  height: 500,
                                ),
                              ),
                              SizedBox(height: 10),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Signup Perusahaan',
                                  style: GoogleFonts.figtree(
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontSize: 20,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
