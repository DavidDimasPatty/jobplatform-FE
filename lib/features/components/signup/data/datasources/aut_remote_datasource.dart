import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/signup/data/models/kota.dart';
import 'package:job_platform/features/components/signup/data/models/provinsi.dart';
import 'package:job_platform/features/components/signup/domain/entities/signUpRequest.dart';

import '../models/signupResponse.dart';

class AuthRemoteDatasource {
  Future<SignupResponseModel> signup(SignupRequestModel data) async {
    await dotenv.load(fileName: '.env');
    final url = Uri.parse(
      '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/register',
    );
    // print("registerAs: ${data.registerAs}");
    // print("email: ${data.email}");
    // print("nama: ${data.nama}");
    // print("alamat: ${data.alamat}");
    // print("noTelp: ${data.noTelp}");
    // print("tanggalLahir: ${data.tanggalLahir}");
    // print("jenisKelamin: ${data.jenisKelamin}");

    // print("JSON: ${jsonEncode(data.toJson())}");
    var jsonBody;
    final registerAs = data.registerAs;
    if (registerAs == 'company') {
      print("Using toJsonCompany");
      print("JSON Company: ${jsonEncode(data.toJsonCompany())}");
      jsonBody = jsonEncode(data.toJsonCompany());
    } else {
      print("Using toJson");
      print("JSON Pelamar: ${jsonEncode(data.toJson())}");
      jsonBody = jsonEncode(data.toJson());
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonBody,
    );
    print("Response body: ${response.body}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body);
      final signupResponse = SignupResponseModel.fromJson(json);
      print('Berhasil: ${signupResponse.toString()}');
      return signupResponse;
    } else {
      throw Exception(
        'Gagal signup: ${response.statusCode} - ${response.body}',
      );
    }
  }

  Future<List<ProvinsiModel>> getProvinsi() async {
    try {
      final proxyUrl =
          "https://www.emsifa.com/api-wilayah-indonesia/api/provinces.json";
      // final proxyUrl =
      //     'https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://wilayah.id/api/provinces.json')}';
      //final proxyUrl = " https://open-api.my.id/api/wilayah/provinces";
      final uri = Uri.parse(proxyUrl);

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
      final List<dynamic> data = jsonDecode(response.body);

      //final List<dynamic> data = response.body;
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
          "https://www.emsifa.com/api-wilayah-indonesia/api/regencies/$code.json";
      // final proxyUrl =
      //     'https://api.allorigins.win/raw?url=${Uri.encodeComponent('https://wilayah.id/api/regencies/$code.json')}';
      //final proxyUrl = " https://open-api.my.id/api/wilayah/provinces";
      final uri = Uri.parse(proxyUrl);

      final response = await http.get(uri);

      if (response.statusCode != 200) {
        throw Exception('Failed to load provinces: ${response.statusCode}');
      }
      final List<dynamic> data = jsonDecode(response.body);

      //final List<dynamic> data = jsonData["data"];
      //print(data);
      return data.map((e) => KotaModel.fromJson(e)).toList();
    } catch (e, st) {
      print('getProvinsi error: $e\n$st');
      // fallback agar UI tidak crash
      return <KotaModel>[];
    }
  }
}
