import 'package:flutter/material.dart';
import 'package:job_platform/features/components/login/persentation/pages/login.dart';
import 'package:job_platform/features/components/signup/data/datasources/aut_remote_datasource.dart';
import 'package:job_platform/features/components/signup/data/repositories/auth_repository_impl.dart';
import 'package:job_platform/features/components/signup/domain/usecases/signup_usercase.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPelamar.dart';
import 'package:job_platform/features/components/signup/persentation/pages/signupPerusahaan.dart';

class SignUp extends StatefulWidget {
  final String? name;
  final String? email;
  final String? photoUrl;

  SignUp(this.name, this.email, this.photoUrl);
  @override
  State<SignUp> createState() => _SignUp(this.name, this.email, this.photoUrl);
}

class _SignUp extends State<SignUp> {
  final String? name;
  final String? email;
  final String? photoUrl;
  _SignUp(this.name, this.email, this.photoUrl);
  final _emailController = TextEditingController();
  final _namaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? selectedValue;
  final List<String> options = ['Pelamar', 'Perusahaan'];
  void _handleLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

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
    print(selectedValue);
    if (_formKey.currentState!.validate()) {
      if (selectedValue == "Pelamar") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPelamar()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPerusahaan()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Harap lengkapi semua field!'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 600,
                  child: Text(
                    "Sign Up",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 300,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(photoUrl!),
                  ),
                ),
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
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    value: selectedValue == '' ? null : selectedValue,
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Wajib diisi' : null,
                    hint: Text('Pilih Role'),
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 14,
                      ),
                    ),
                    items: options.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                  ),
                ),
                // TextField(
                //   controller: _passwordController,
                //   decoration: InputDecoration(hintText: "Password"),
                //   obscureText: true,
                // ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _handleSignUp,
                      child: Text(
                        'Next',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
