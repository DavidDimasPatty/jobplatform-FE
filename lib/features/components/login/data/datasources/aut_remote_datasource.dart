import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';

class AuthRemoteDataSource {
  Future<loginModel?> login(String email) async {
    try {
      // Dummy API simulation
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/login',
      ).replace(queryParameters: {'email': email});
      loginModel? data = null;
      final response = await http.get(url);
      print(response.body.toString());

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
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
