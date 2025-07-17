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
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(hintText: 'Email'),
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(hintText: 'Password'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: _handleLogin, child: Text('Login')),
            ElevatedButton(onPressed: _handleSignUp, child: Text('Sign Up')),
          ],
        ),
        SizedBox(height: 20),
        Text(_result),
      ],
    );
  }
}
