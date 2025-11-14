import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/chat/data/models/chatModel.dart';
import 'package:job_platform/features/components/chat/data/models/chatRequest.dart';
import 'package:job_platform/features/components/chat/data/models/chatResponse.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

class AuthRemoteDataSource {
  Future<List<PartnerModel>?> getChatList(String idUser) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/get-chat-list',
      ).replace(queryParameters: {'idUser': idUser});
      List<PartnerModel>? data;
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> partnerData = jsonData["data"];
        data = partnerData
            .map<PartnerModel>((item) => PartnerModel.fromJson(item))
            .toList();
        return data;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return null;
      }
    } catch (e) {
      print('Error during getChatList: $e');
      return null;
    }
  }

  Future<List<ChatModel>?> getConversation(
    String idUser1, // Sender
    String idUser2, // Receiver
  ) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/get-conversation',
      ).replace(queryParameters: {'idUser1': idUser1, 'idUser2': idUser2});
      List<ChatModel>? data;
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final List<dynamic> chatData = jsonData["data"];
        data = chatData
            .map<ChatModel>((item) => ChatModel.fromJson(item))
            .toList();
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

  Future<ChatResponse> markAsRead(ChatRequest request) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/mark-as-read',
      );

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final ChatResponse dataRes = ChatResponse.fromJson(jsonData);
        return dataRes;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ChatResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during markAsRead: $e');
      return ChatResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<ChatResponse> markAsDelivered(ChatRequest request) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/mark-as-delivered',
      );

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final ChatResponse dataRes = ChatResponse.fromJson(jsonData);
        return dataRes;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ChatResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during markAsDelivered: $e');
      return ChatResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }

  Future<ChatResponse> deleteMessage(ChatRequest request) async {
    try {
      await dotenv.load(fileName: '.env');
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV_CHAT']}/api/v1/chat/delete-message',
      );

      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        final ChatResponse dataRes = ChatResponse.fromJson(jsonData);
        return dataRes;
      } else {
        final dataFailed = jsonDecode(response.body);
        print('Gagal: ${response.statusCode} $dataFailed');
        return ChatResponse.fromJson(dataFailed);
      }
    } catch (e) {
      print('Error during deleteMessage: $e');
      return ChatResponse(
        responseCode: '500',
        responseMessage: 'Failed',
        data: null,
      );
    }
  }
}
