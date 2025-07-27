import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel?> login(String email, String password) async {
    // Dummy API simulation
    final url = Uri.parse('https://jobplatform-be.vercel.app/api/login');
    UserModel? data = null;
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'username': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      //print(response.body);
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      //print('Berhasil: $jsonData');

      final dataRes = UserModel.fromJson(jsonData);
      //print(dataRes.id);
      return dataRes;
    } else {
      final dataFailed = jsonDecode(response.body);
      print('Gagal: ${response.statusCode} ${dataFailed}');
      return null;
    }
  }
}
