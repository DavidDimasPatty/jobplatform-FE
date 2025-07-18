import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/signup.dart';

class AuthRemoteDatasource {
  Future<SignupModel> signup(String email, String password) async {
    //    final response = await http.get(
    //   Uri.parse('https://api.example.com/products'),
    // );

    // final List<dynamic> data = jsonDecode(response.body);
    //   final url = Uri.parse('https://api.example.com/products');

    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Accept': 'application/json',
    //   },
    //   body: jsonEncode({
    //     'name': 'Produk Baru',
    //     'price': 12000,
    //   }),
    // );

    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   final data = jsonDecode(response.body);
    //   print('Berhasil: $data');
    // } else {
    //   print('Gagal: ${response.statusCode}');
    // }
    await Future.delayed(Duration(seconds: 1));
    final response = {"status": "Ok", "responseMessages": "Success"};
    return SignupModel.fromJson(response);
  }
}
