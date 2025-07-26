import 'package:flutter/material.dart';
import 'package:job_platform/features/components/home/persentation/pages/home_page.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signup.dart';
import '../../data/datasources/aut_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_usecase.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _result = '';

  Future<void> _handleLogin() async {
    final dataSource = AuthRemoteDataSource();
    final repository = AuthRepositoryImpl(dataSource);
    final usecase = LoginUseCase(repository);

    final user = await usecase.execute(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _result = 'Welcome ${user.name}!';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  void _handleSignUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        SizedBox(
          height: 70,
          width: 300,
          child: TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
              suffixIcon: Icon(Icons.email),
            ),
          ),
        ),
        SizedBox(
          height: 70,
          width: 300,
          child: TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              hintText: 'Password',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
              suffixIcon: Icon(Icons.lock),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _handleLogin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              child: Text('Login', style: TextStyle(color: Colors.black)),
            ),
            SizedBox(width: 15),
            ElevatedButton(
              onPressed: _handleSignUp,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
              child: Text('Sign Up', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(_result),
      ],
    );
  }
}
