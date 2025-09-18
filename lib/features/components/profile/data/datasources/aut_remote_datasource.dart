import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

class AuthRemoteDataSource {
  Future<ProfileModel?> profileGet(String id) async {
    try {
      // Dummy API simulation
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_USER']}/api/v1/profile-management/detail',
      ).replace(queryParameters: {'id': id});
      ProfileModel? data;
      final response = await http.get(url);
      print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        // print('Berhasil: $jsonData');

        data = ProfileModel.fromJson(jsonData);
        // print(data.certificates);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during get profile: $e');
      return null;
    }
  }
}
