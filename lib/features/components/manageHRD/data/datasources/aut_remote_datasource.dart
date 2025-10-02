import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';

class AuthRemoteDataSource {
  Future<loginModel?> getCartData(String email) async {
    try {
      // Dummy API simulation
      final url = Uri.parse(
        'https://localhost:7104/api/v1/account/login',
      ).replace(queryParameters: {'email': email});
      loginModel? data;
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
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during login: $e');
      return null;
    }
  }
}
