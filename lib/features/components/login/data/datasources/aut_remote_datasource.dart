import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password) async {
    // Dummy API simulation
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
    await Future.delayed(Duration(seconds: 1)); // simulasi delay
    final response = {"id": "1", "name": "David Patty"};
    return UserModel.fromJson(response);
  }
}
