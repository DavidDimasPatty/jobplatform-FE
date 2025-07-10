import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    // Dummy API simulation
    await Future.delayed(Duration(seconds: 1)); // simulasi delay
    final response = {"id": "1", "name": "David Patty"};
    return UserModel.fromJson(response);
  }
}
