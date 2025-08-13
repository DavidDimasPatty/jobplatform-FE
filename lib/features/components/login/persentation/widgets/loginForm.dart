import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _result = '';
  final _formKey = GlobalKey<FormState>();
  String? clientId = dotenv.env['WEB_CLIENT_ID_DEV'];
  String? serverClientId = dotenv.env['WEB_CLIENT_ID_DEV'];
  GoogleSignInAccount? _currentUser;
  bool _isAuthorized = false; // has granted permissions?
  String _contactText = '';
  String _errorMessage = '';
  String _serverAuthCode = '';
  List<String> scopes = <String>[
    'https://www.googleapis.com/auth/contacts.readonly',
  ];

  @override
  void initState() {
    super.initState();

    // #docregion Setup
    final GoogleSignIn signIn = GoogleSignIn.instance;
    unawaited(
      signIn.initialize(clientId: clientId, serverClientId: serverClientId).then((
        _,
      ) {
        signIn.authenticationEvents
            .listen(_handleAuthenticationEvent)
            .onError(_handleAuthenticationError);

        /// This example always uses the stream-based approach to determining
        /// which UI state to show, rather than using the future returned here,
        /// if any, to conditionally skip directly to the signed-in state.
        signIn.attemptLightweightAuthentication();
      }),
    );
    // #enddocregion Setup
  }

  Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    // #docregion CheckAuthorization
    final GoogleSignInAccount? user = // ...
        // #enddocregion CheckAuthorization
        switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };

    // Check for existing authorization.
    // #docregion CheckAuthorization
    final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(scopes);
    // #enddocregion CheckAuthorization

    setState(() {
      _currentUser = user;
      _isAuthorized = authorization != null;
      _errorMessage = '';
    });

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      unawaited(_handleGetContact(user));
    }
  }

  Future<void> _handleAuthenticationError(Object e) async {
    setState(() {
      _currentUser = null;
      _isAuthorized = false;
      _errorMessage = e is GoogleSignInException
          ? _errorMessageFromSignInException(e)
          : 'Unknown error: $e';
    });
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final Map<String, String>? headers = await user.authorizationClient
        .authorizationHeaders(scopes);
    if (headers == null) {
      setState(() {
        _contactText = '';
        _errorMessage = 'Failed to construct authorization headers.';
      });
      return;
    }
    final http.Response response = await http.get(
      Uri.parse(
        'https://people.googleapis.com/v1/people/me/connections'
        '?requestMask.includeField=person.names',
      ),
      headers: headers,
    );
    if (response.statusCode != 200) {
      if (response.statusCode == 401 || response.statusCode == 403) {
        setState(() {
          _isAuthorized = false;
          _errorMessage =
              'People API gave a ${response.statusCode} response. '
              'Please re-authorize access.';
        });
      } else {
        print('People API ${response.statusCode} response: ${response.body}');
        setState(() {
          _contactText =
              'People API gave a ${response.statusCode} '
              'response. Check logs for details.';
        });
      }
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact =
        connections?.firstWhere(
              (dynamic contact) =>
                  (contact as Map<Object?, dynamic>)['names'] != null,
              orElse: () => null,
            )
            as Map<String, dynamic>?;
    if (contact != null) {
      final List<dynamic> names = contact['names'] as List<dynamic>;
      final Map<String, dynamic>? name =
          names.firstWhere(
                (dynamic name) =>
                    (name as Map<Object?, dynamic>)['displayName'] != null,
                orElse: () => null,
              )
              as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  String _errorMessageFromSignInException(GoogleSignInException e) {
    // In practice, an application should likely have specific handling for most
    // or all of the, but for simplicity this just handles cancel, and reports
    // the rest as generic errors.
    return switch (e.code) {
      GoogleSignInExceptionCode.canceled => 'Sign in canceled',
      _ => 'GoogleSignInException ${e.code}: ${e.description}',
    };
  }

  Future _handleLogin() async {
    // if (!_formKey.currentState!.validate()) {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Harap lengkapi semua field!'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
    // final dataSource = AuthRemoteDataSource();
    // final repository = AuthRepositoryImpl(dataSource);
    // final usecase = LoginUseCase(repository);

    // final user = await usecase.execute(
    //   _emailController.text,
    //   _passwordController.text,
    // );
    // //print(user);
    // if (user != null) {
    //   setState(() {
    //     _result = 'Welcome ${user!.nama}!';
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => HomePage()),
    //     );
    //   });
    // } else {
    //   return ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Username/ Password Salah'),
    //       backgroundColor: Colors.red,
    //     ),
    //   );
    // }
  }

  void _handleSignUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 70,
                width: 600,
                child: Text(
                  "Welcome To Yuk Kerja",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              // SizedBox(
              //   height: 70,
              //   width: 300,
              //   child: TextFormField(
              //     validator: (value) =>
              //         value == null || value.isEmpty ? 'Wajib diisi' : null,
              //     controller: _emailController,
              //     decoration: InputDecoration(
              //       hintText: 'Email/ Username',
              //       border: OutlineInputBorder(),
              //       contentPadding: EdgeInsets.symmetric(
              //         vertical: 8,
              //         horizontal: 11,
              //       ),
              //       suffixIcon: Icon(Icons.email),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 70,
              //   width: 300,
              //   child: TextFormField(
              //     validator: (value) =>
              //         value == null || value.isEmpty ? 'Wajib diisi' : null,
              //     obscureText: true,
              //     controller: _passwordController,
              //     decoration: InputDecoration(
              //       hintText: 'Password',
              //       border: OutlineInputBorder(),
              //       contentPadding: EdgeInsets.symmetric(
              //         vertical: 8,
              //         horizontal: 11,
              //       ),
              //       suffixIcon: Icon(Icons.lock),
              //     ),
              //   ),
              // ),
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
                  // SizedBox(width: 15),
                  // ElevatedButton(
                  //   onPressed: _handleSignUp,
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white70,
                  //   ),
                  //   child: Text(
                  //     'Sign Up',
                  //     style: TextStyle(color: Colors.black),
                  //   ),
                  // ),
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
