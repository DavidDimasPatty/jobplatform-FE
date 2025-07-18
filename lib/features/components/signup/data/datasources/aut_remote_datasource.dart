import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/signup.dart';

class AuthRemoteDatasource {
  Future<SignupModel> signup(String email, String password) async {
    await Future.delayed(Duration(seconds: 1));
    final response = {"status": "Ok", "responseMessages": "Success"};
    return SignupModel.fromJson(response);
  }
}
