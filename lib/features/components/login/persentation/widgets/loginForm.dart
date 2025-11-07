import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/login/persentation/pages/companyWaiting.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/aut_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final String _result = '';
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? uid;
  String? name;
  String? userEmail;
  String? imageUrl;
  String? token;
  // Fungsi ini dipanggil saat tombol ditekan
  Future _handleLogin() async {
    await Firebase.initializeApp();

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      try {
        final UserCredential userCredential = await _auth.signInWithPopup(
          authProvider,
        );
        user = userCredential.user;
        // print(user);
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        token = googleSignInAuthentication.accessToken;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential = await _auth
              .signInWithCredential(credential);
          user = userCredential.user;
        } catch (e) {
          print(e);
        }
      }
    }

    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final dataSource = AuthRemoteDataSource();
        final repository = AuthRepositoryImpl(dataSource);
        final usecase = LoginUseCase(repository);
        loginModel? data = await usecase.execute(user!.email!);

        if (data!.exists != null) {
          if (data.exists != false) {
            if (data.collection == "users") {
              await prefs.setString("loginAs", "user");
              await prefs.setString("idUser", data.user!.id!);
              await prefs.setString("nama", data.user!.nama!);
              await prefs.setString("email", data.user!.email!);
              await prefs.setString("noTelp", data.user!.noTelp!);
              await prefs.setString("urlAva", data.user!.photoURL!);
              await prefs.setBool("isPremium", data.user!.isPremium!);
              await prefs.setBool("is2FA", data.user!.is2FA!);

              if (data.user!.fontSize == null) {
                await prefs.setInt("fontSizeHead", 18);
                await prefs.setInt("fontSizeSubHead", 16);
                await prefs.setInt("fontSizeBody", 14);
                await prefs.setInt("fontSizeIcon", 12);
              } else {
                List<String> arrFont = data.user!.fontSize!.split(',');
                await prefs.setInt("fontSizeHead", int.parse(arrFont[0]));
                await prefs.setInt("fontSizeSubHead", int.parse(arrFont[1]));
                await prefs.setInt("fontSizeBody", int.parse(arrFont[2]));
                await prefs.setInt("fontSizeIcon", int.parse(arrFont[3]));
              }
              await prefs.setBool(
                "isNotifInternal",
                data.user!.isNotifInternal!,
              );
              await prefs.setBool(
                "isNotifExternal",
                data.user!.isNotifExternal!,
              );
              await prefs.setBool("isDarkMode", data.user!.isDarkMode!);
              await prefs.setString("language", data.user!.language!);
              if (data.hrCompanies != null) {
                await prefs.setString(
                  "hrCompanyName",
                  data.hrCompanies!.company.nama!,
                );
                await prefs.setString(
                  "hrCompanyId",
                  data.hrCompanies!.company.id!,
                );
              }
              return context.go("/home");
            } else if (data.collection == "companies") {
              if (data.progress == null) {
                await prefs.setString("loginAs", "company");
                await prefs.setString("idCompany", data.company!.id!);
                await prefs.setString("nama", data.company!.nama!);
                await prefs.setString("domain", data.company!.email!);
                await prefs.setString("noTelp", data.company!.noTelp!);
                await prefs.setString("urlAva", data.company!.logo!);
                await prefs.setBool("isPremium", data.company!.isPremium!);
                await prefs.setBool("is2FA", data.company!.is2FA!);

                if (data.company!.fontSize == null) {
                  await prefs.setInt("fontSizeHead", 18);
                  await prefs.setInt("fontSizeSubHead", 16);
                  await prefs.setInt("fontSizeBody", 14);
                  await prefs.setInt("fontSizeIcon", 12);
                } else {
                  List<String> arrFont = data.company!.fontSize!.split(',');
                  await prefs.setInt("fontSizeHead", int.parse(arrFont[0]));
                  await prefs.setInt("fontSizeSubHead", int.parse(arrFont[1]));
                  await prefs.setInt("fontSizeBody", int.parse(arrFont[2]));
                  await prefs.setInt("fontSizeIcon", int.parse(arrFont[3]));
                }
                await prefs.setBool(
                  "isNotifInternal",
                  data.company!.isNotifInternal!,
                );
                await prefs.setBool(
                  "isNotifExternal",
                  data.company!.isNotifExternal!,
                );
                await prefs.setBool("isDarkMode", data.company!.isDarkMode!);
                await prefs.setString("language", data.company!.language!);
                return context.go("/homeCompany");
              } else if (data.progress!.lastAdmin!.status ==
                  "Reject oleh Admin") {
                String? alasan = data.progress!.lastAdmin!.alasanReject;
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pendaftaran Perusahaan Gagal. Alasan: $alasan, Mohon Mencoba Pendaftaran Kembali Besok!',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else if (data.progress!.stage! == "Reject oleh Surveyer") {
                String? alasan = data.progress!.lastSurvey!.alasanReject;
                return ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pendaftaran Perusahaan Gagal. Alasan: $alasan, Mohon Mencoba Pendaftaran Kembali Besok!',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                return Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CompanyWaiting(
                      data.progress!.stage!,
                      data.company!.id!,
                      data.company!.nama!,
                    ),
                  ),
                );
              }
            } else {
              return ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Login failed. Admin Restrictions.'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          } else {
            uid = user!.uid;
            name = user!.displayName;
            userEmail = user!.email;
            imageUrl = user!.photoURL;
            return Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignUp(name, userEmail, imageUrl, token),
              ),
            );
          }
        } else {
          uid = user!.uid;
          name = user!.displayName;
          userEmail = user!.email;
          imageUrl = user!.photoURL;
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignUp(name, userEmail, imageUrl, token),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error during login: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Google failed. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          child: Column(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  bool isMobile = ResponsiveBreakpoints.of(
                    context,
                  ).smallerThan(DESKTOP);
                  return Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    child: Text(
                      isMobile ? "Welcome To \n Skillen" : "Welcome To Skillen",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dancingScript(
                        textStyle: TextStyle(
                          color: Colors.blue,
                          letterSpacing: 5,
                          fontSize: 60,
                        ),
                      ),
                    ),
                  );
                },
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  'assets/images/BG_Login.png',
                  width: 500,
                  height: 500,
                ),
              ),

              Container(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Login or Sign Up",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ptSerif(
                    textStyle: TextStyle(
                      color: Colors.blue,
                      letterSpacing: 2,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.input_sharp, color: Colors.white),
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      label: Text(
                        'Login With Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(_result),
            ],
          ),
        ),
      ],
    );
  }
}
