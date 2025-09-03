import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/login/domain/entities/loginData.dart'
    hide User;
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/aut_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String _result = '';
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

        if (data!.exists != false) {
          if (data!.collection == "users") {
            await prefs.setString("loginAs", "user");
            await prefs.setString("idUser", data!.user!.id);
            await prefs.setString("nama", data!.user!.nama);
            await prefs.setString("email", data!.user!.email);
            await prefs.setString("noTelp", data!.user!.noTelp);
            return Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (data!.collection == "companies") {
            await prefs.setString("loginAs", "company");
            await prefs.setString("idCompany", data!.company!.id);
            await prefs.setString("nama", data!.company!.nama);
            await prefs.setString("domain", data!.company!.email);
            await prefs.setString("noTelp", data!.company!.noTelp);
            return Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
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

        // SharedPreferences prefs = await SharedPreferences.getInstance();
        // prefs.setBool("auth", true);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => SignUp(name, userEmail, imageUrl, token),
        //   ),
        // );
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
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
              SizedBox(
                height: 70,
                width: 600,
                child: Text(
                  "Welcome To Skillen",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white70,
                    ),
                    child: Text(
                      'Login With Google',
                      style: TextStyle(color: Colors.black),
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
