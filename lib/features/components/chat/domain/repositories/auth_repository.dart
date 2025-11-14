import 'package:job_platform/features/components/chat/data/models/chatModel.dart';
import 'package:job_platform/features/components/chat/data/models/chatRequest.dart';
import 'package:job_platform/features/components/chat/data/models/chatResponse.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

abstract class AuthRepository {
  Future<List<PartnerModel>?> getChatList(String idUser);
  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2);
  Future<ChatResponse> markAsRead(ChatRequest request);
  Future<ChatResponse> markAsDelivered(ChatRequest request);
  Future<ChatResponse> deleteMessage(ChatRequest request);
}
