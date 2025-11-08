import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Settingemail extends StatefulWidget {
  final Future<String> Function(String oldEmail, String newEmail)?
  changeEmailAccount;
  const Settingemail({super.key, this.changeEmailAccount});

  @override
  State<Settingemail> createState() => _Settingemail();
}

class _Settingemail extends State<Settingemail> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? oldUser;
  User? newUser;
  String? token;
  bool _isWaiting = false;
  String _statusMessage = "Verifikasi akun lama...";

  Future _handleValidateEmail() async {
    await Firebase.initializeApp();
    setState(() {
      _isWaiting = true;
      _statusMessage = "Verifikasi akun lama (mohon masukan email exist)";
    });

    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.disconnect();
    } catch (_) {}
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    if (kIsWeb) {
      try {
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        authProvider.setCustomParameters({'prompt': 'select_account'});

        final userCredential = await FirebaseAuth.instance.signInWithPopup(
          authProvider,
        );
        oldUser = userCredential.user;
      } catch (e) {
        setState(() {
          _isWaiting = false;
        });
        print("Error step 1 web: $e");
        return;
      }
    } else {
      try {
        final googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount == null) return;

        final googleAuth = await googleSignInAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        oldUser = userCredential.user;
      } catch (e) {
        setState(() {
          _isWaiting = false;
        });
        print("Error step 1 mobile: $e");
        return;
      }
    }
    try {
      await googleSignIn.disconnect();
    } catch (_) {}
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();

    setState(() {
      _statusMessage = "Mohon masukkan email baru...";
    });

    await Future.delayed(Duration(seconds: 3));

    if (kIsWeb) {
      try {
        final GoogleAuthProvider authProvider = GoogleAuthProvider();
        authProvider.setCustomParameters({'prompt': 'select_account'});

        final userCredential = await FirebaseAuth.instance.signInWithPopup(
          authProvider,
        );
        newUser = userCredential.user;
      } catch (e) {
        setState(() {
          _isWaiting = false;
        });
        print("Error step 2 web: $e");
        return;
      }
    } else {
      try {
        final googleSignInAccount = await googleSignIn.signIn();
        if (googleSignInAccount == null) return;

        final googleAuth = await googleSignInAccount.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final userCredential = await FirebaseAuth.instance.signInWithCredential(
          credential,
        );
        newUser = userCredential.user;
      } catch (e) {
        print("Error step 2 mobile: $e");
        return;
      }
    }
    try {
      String res = await widget.changeEmailAccount!(
        oldUser!.email!,
        newUser!.email!,
      );
      if (res == "Sukses") {
        setState(() {
          _statusMessage =
              "Email Berhasil Diganti! \n Anda Akan Diarahkan ke Halaman Login";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Success ganti email"),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          _isWaiting = false;
        });
        context.go("/");
      } else {
        setState(() {
          _statusMessage = res;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res), backgroundColor: Colors.red),
        );
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          _isWaiting = false;
        });
      }
    } catch (e) {
      setState(() {
        _isWaiting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Center(
        child: Center(
          child: Container(
            constraints: BoxConstraints(minHeight: 400),
            decoration: BoxDecoration(
              color: Colors.white,
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
            width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                ? double.infinity
                : MediaQuery.of(context).size.width * 0.45,
            child: _isWaiting
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.blue),
                      SizedBox(height: 16),
                      Text(
                        _statusMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : ResponsiveRowColumn(
                    columnCrossAxisAlignment: CrossAxisAlignment.center,
                    rowMainAxisAlignment: MainAxisAlignment.center,
                    columnMainAxisAlignment: MainAxisAlignment.center,
                    rowCrossAxisAlignment: CrossAxisAlignment.center,
                    layout: ResponsiveRowColumnType.COLUMN,
                    rowSpacing: 100,
                    columnSpacing: 20,
                    children: [
                      ResponsiveRowColumnItem(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.input_sharp, color: Colors.white),
                          onPressed: _handleValidateEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          label: Text(
                            'Validate change email',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
