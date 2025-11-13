import 'package:job_platform/features/components/chat/data/models/chatModel.dart';
import 'package:job_platform/features/components/chat/data/models/chatRequest.dart';
import 'package:job_platform/features/components/chat/data/models/chatResponse.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

import '../repositories/auth_repository.dart';

class ChatUseCase {
  final AuthRepository repository;

  ChatUseCase(this.repository);

  Future<List<PartnerModel>?> getChatList(String idUser) {
    return repository.getChatList(idUser);
  }
  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2) {
    return repository.getConversation(idUser1, idUser2);
  }
  Future<ChatResponse> markAsRead(ChatRequest request) {
    return repository.markAsRead(request);
  }
  Future<ChatResponse> markAsDelivered(ChatRequest request) {
    return repository.markAsDelivered(request);
  }
  Future<ChatResponse> deleteMessage(ChatRequest request) {
    return repository.deleteMessage(request);
  }
}
