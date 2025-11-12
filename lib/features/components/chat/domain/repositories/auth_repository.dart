import 'package:job_platform/features/components/chat/data/models/chatModel.dart';

abstract class AuthRepository {
  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2);
}
