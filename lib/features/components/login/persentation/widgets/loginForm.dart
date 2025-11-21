import 'dart:async';
import 'package:job_platform/core/utils/providers/AuthProvider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:job_platform/core/network/websocket_client.dart';
import 'package:job_platform/core/utils/providers/ThemeProvider.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/login/persentation/pages/companyWaiting.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/aut_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  bool isLoading = false;
  final storage = StorageService();

  Future _handleLogin() async {
    AuthProvider authProviderLogIn = Provider.of<AuthProvider>(
      context,
      listen: false,
    );
    await Firebase.initializeApp();
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();
      authProvider.setCustomParameters({'prompt': 'select_account'});
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
      setState(() {
        isLoading = true;
      });
      try {
        final dataSource = AuthRemoteDataSource();
        final repository = AuthRepositoryImpl(dataSource);
        final usecase = LoginUseCase(repository);
        loginModel? data = await usecase.execute(user!.email!);
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        if (data!.exists != null) {
          if (data.exists != false) {
            if (data.collection == "users") {
              setState(() {
                isLoading = true;
              });
              try {
                await authProviderLogIn.login(user!.refreshToken!);
                // TOKEN + LOGIN TYPE
                await storage.save("loginAs", "user");
                await storage.save("idUser", data.user!.id!);
                await storage.save("nama", data.user!.nama!);
                await storage.save("email", data.user!.email!);
                await storage.save("noTelp", data.user!.noTelp!);
                await storage.save("urlAva", data.user?.photoURL ?? '');

                await storage.save(
                  "isPremium",
                  (data.user!.isPremium ?? false).toString(),
                );

                await storage.save(
                  "is2FA",
                  (data.user!.is2FA ?? false).toString(),
                );

                // FONT SIZE
                if (data.user!.fontSize == null) {
                  await storage.save("fontSizeHead", "18");
                  await storage.save("fontSizeSubHead", "16");
                  await storage.save("fontSizeBody", "14");
                  await storage.save("fontSizeIcon", "12");
                } else {
                  final arrFont = data.user!.fontSize!.split(',');
                  await storage.save("fontSizeHead", arrFont[0]);
                  await storage.save("fontSizeSubHead", arrFont[1]);
                  await storage.save("fontSizeBody", arrFont[2]);
                  await storage.save("fontSizeIcon", arrFont[3]);
                }

                // NOTIF SETTINGS
                await storage.save(
                  "isNotifInternal",
                  (data.user!.isNotifInternal ?? false).toString(),
                );

                await storage.save(
                  "isNotifExternal",
                  (data.user!.isNotifExternal ?? false).toString(),
                );

                // THEME
                await storage.save(
                  "isDarkMode",
                  (data.user!.isDarkMode ?? false).toString(),
                );

                // LANGUAGE
                await storage.save("language", data.user!.language ?? "IND");

                // HR COMPANY DATA
                if (data.hrCompanies != null) {
                  await storage.save("isHRD", "true");
                  await storage.save(
                    "hrCompanyName",
                    data.hrCompanies!.company.nama!,
                  );
                  await storage.save(
                    "hrCompanyId",
                    data.hrCompanies!.company.id!,
                  );
                }
              } catch (e, st) {
                print("SecureStorage error (DIABAIKAN): $e");
              }

              try {
                // WebSocket Connection
                final _webSocketClient = WebSocketClientImpl(
                  userId: data.user!.id!,
                  url: '${dotenv.env['WEBSOCKET_URL_DEV_CHAT']}',
                );
                _webSocketClient.connect();
              } catch (e) {
                print("WebSocket connection error (DIABAIKAN): $e");
              }

              String? result2FA;

              try {
                String? idUser2FA = data.user!.id!;
                String? email = data.user!.email!;
                result2FA = await usecase.login2FA(
                  idUser2FA!,
                  email!,
                  "user",
                  "login",
                );
                if (result2FA == "Sukses") {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (data.user!.isDarkMode == true) {
                      themeProvider.toggleTheme();
                    }

                    if (data.user!.language == "IND") {
                      context.setLocale(const Locale('id'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                    context.go(
                      "/Validate2fa",
                      extra: {
                        "email": email,
                        "userId": idUser2FA,
                        "loginAs": "user",
                      },
                    );
                  });
                }
              } catch (Ex) {
                setState(() {
                  isLoading = false;
                });
                throw Exception(Ex);
              }

              // return context.go("/home");
            } else if (data.collection == "companies") {
              await authProviderLogIn.login(user!.refreshToken!);
              setState(() {
                isLoading = true;
              });
              if (data.progress == null) {
                try {
                  // TIPE LOGIN
                  authProviderLogIn.login(user!.refreshToken!);
                  await storage.save("loginAs", "company");

                  // DATA COMPANY
                  await storage.save("idUser", data.company!.id!);
                  await storage.save("nama", data.company!.nama!);
                  await storage.save("domain", data.company!.email!);
                  await storage.save("noTelp", data.company!.noTelp!);
                  await storage.save("urlAva", data.company!.logo!);

                  // BOOLEAN SETTINGS
                  await storage.save(
                    "isPremium",
                    (data.company!.isPremium ?? false).toString(),
                  );

                  await storage.save(
                    "is2FA",
                    (data.company!.is2FA ?? false).toString(),
                  );

                  // FONT SIZE (int → string)
                  if (data.company!.fontSize == null) {
                    await storage.save("fontSizeHead", "18");
                    await storage.save("fontSizeSubHead", "16");
                    await storage.save("fontSizeBody", "14");
                    await storage.save("fontSizeIcon", "12");
                  } else {
                    List<String> arrFont = data.company!.fontSize!.split(',');
                    await storage.save("fontSizeHead", arrFont[0]);
                    await storage.save("fontSizeSubHead", arrFont[1]);
                    await storage.save("fontSizeBody", arrFont[2]);
                    await storage.save("fontSizeIcon", arrFont[3]);
                  }

                  // NOTIF
                  await storage.save(
                    "isNotifInternal",
                    (data.company!.isNotifInternal ?? false).toString(),
                  );

                  await storage.save(
                    "isNotifExternal",
                    (data.company!.isNotifExternal ?? false).toString(),
                  );

                  // DARK MODE
                  await storage.save(
                    "isDarkMode",
                    (data.company!.isDarkMode ?? false).toString(),
                  );

                  // LANGUAGE
                  await storage.save(
                    "language",
                    data.company!.language ?? "IND",
                  );
                } catch (e, st) {
                  print("SecureStorage error (DIABAIKAN): $e");
                }

                try {
                  // WebSocket Connection
                  final _webSocketClient = WebSocketClientImpl(
                    userId: data.company!.id!,
                    url: '${dotenv.env['WEBSOCKET_URL_DEV_CHAT']}',
                  );
                  _webSocketClient.connect();
                } catch (e) {
                  print("WebSocket connection error (DIABAIKAN): $e");
                }

                // LOGIN PROVIDER
                String? result2FA;
                try {
                  setState(() {
                    isLoading = true;
                  });
                  String? idUser2FA = data.company!.id!;
                  String? email = data.company!.email!;
                  result2FA = await usecase.login2FA(
                    idUser2FA!,
                    email!,
                    "company",
                    "login",
                  );
                  if (result2FA == "Sukses") {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (data.company!.isDarkMode == true) {
                        themeProvider.toggleTheme();
                      }

                      if (data.company!.language == "IND") {
                        context.setLocale(Locale('id'));
                      } else {
                        context.setLocale(Locale('en'));
                      }

                      context.go(
                        "/Validate2fa",
                        extra: {
                          "email": email,
                          "userId": idUser2FA,
                          "loginAs": "company",
                        },
                      );
                    });
                  }
                } catch (Ex) {
                  setState(() {
                    isLoading = false;
                  });
                  throw Exception(Ex);
                }

                //return context.go("/homeCompany");
              } else if (data.progress!.lastAdmin!.status ==
                  "Reject oleh Admin") {
                String? alasan = data.progress!.lastAdmin!.alasanReject;
                setState(() {
                  isLoading = false;
                });
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
                setState(() {
                  isLoading = false;
                });
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
              setState(() {
                isLoading = false;
              });
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
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }

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
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                      ),
                      label: Text(
                        'Login With Google',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
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
