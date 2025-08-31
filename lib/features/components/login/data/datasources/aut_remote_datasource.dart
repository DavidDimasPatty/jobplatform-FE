import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import '../models/user.dart';

class AuthRemoteDataSource {
  Future<loginModel?> login(String email) async {
    // Dummy API simulation
    final url = Uri.parse('https://localhost:7104/api/v1/account/login');
    loginModel? data = null;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': email}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      //print(response.body);
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      //print('Berhasil: $jsonData');

      data = loginModel.fromJson(jsonData);
      //print(dataRes.id);
      return data;
    } else {
      final dataFailed = jsonDecode(response.body);
      print('Gagal: ${response.statusCode} ${dataFailed}');
      return null;
    }
  }
}
