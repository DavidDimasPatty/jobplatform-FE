import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/notification/data/models/notificationModel.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';

class AuthRemoteDataSource {
  Future<List<NotificationModel>?> notificationGet(String id) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/notification/get-notification',
      ).replace(queryParameters: {'id': id});
      List<NotificationModel>? data;
      final response = await http.get(url);
      // print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        data = (jsonData['data'] as List)
            .map((item) => NotificationModel.fromJson(item))
            .toList();
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

  Future<NotificationResponse> notificationRead(NotificationRequest notification) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/notification/read-notification',
      );
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(notification.toJson()),
      );
      // print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        NotificationResponse notificationResponse = NotificationResponse.fromJson(jsonData);
        return notificationResponse;
      } else {
        final Map<String, dynamic> dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return NotificationResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during edit vacancy: $e');
      return NotificationResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
