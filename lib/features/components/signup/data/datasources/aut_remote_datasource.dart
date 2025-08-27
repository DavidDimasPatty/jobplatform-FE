import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/signup/data/models/kota.dart';
import 'package:job_platform/features/components/signup/data/models/provinsi.dart';

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

  Future<List<ProvinsiModel>> getProvinsi() async {
    try {
      final proxyUrl =
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://wilayah.id/api/provinces.json')}';
      final uri = Uri.parse(proxyUrl);

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      final List<dynamic> data = jsonData["data"];
      //print(data);
      return data.map((e) => ProvinsiModel.fromJson(e)).toList();
    } catch (e, st) {
      print('getProvinsi error: $e\n$st');
      // fallback agar UI tidak crash
      return <ProvinsiModel>[];
    }
  }

  Future<List<KotaModel>> getKota(String code) async {
    try {
      final proxyUrl =
          'https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://wilayah.id/api/regencies/$code.json')}';
      final uri = Uri.parse(proxyUrl);

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      final List<dynamic> data = jsonData["data"];
      //print(data);
      return data.map((e) => KotaModel.fromJson(e)).toList();
    } catch (e, st) {
      print('getProvinsi error: $e\n$st');
      // fallback agar UI tidak crash
      return <KotaModel>[];
    }
  }
}
