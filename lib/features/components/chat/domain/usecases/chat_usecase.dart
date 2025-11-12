import 'package:job_platform/features/components/chat/data/models/chatModel.dart';

import '../repositories/auth_repository.dart';

class ChatUseCase {
  final AuthRepository repository;

  ChatUseCase(this.repository);

  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2) {
    return repository.getConversation(idUser1, idUser2);
  }
}
