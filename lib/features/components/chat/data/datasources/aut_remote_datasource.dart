import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/chat/data/models/chatModel.dart';

class AuthRemoteDataSource {
  Future<List<ChatModel>?> getConversation(
    String idUser1,
    String idUser2,
  ) async {
    try {
      // Dummy API simulation
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/get-conversation',
      ).replace(queryParameters: {'idUser1': idUser1, 'idUser2': idUser2});
      List<ChatModel>? data;
      final response = await http.get(url);
      // print(response.body.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.body);
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        //print('Berhasil: $jsonData');

        final List<dynamic> chatData = jsonData["data"];
        data = chatData
            .map<ChatModel>((item) => ChatModel.fromJson(item))
            .toList();
        //print(dataRes.id);
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during getConversation: $e');
      return null;
    }
  }
}
