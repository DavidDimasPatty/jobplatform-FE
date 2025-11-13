import 'package:job_platform/features/components/chat/data/models/chatModel.dart';
import 'package:job_platform/features/components/chat/data/models/chatRequest.dart';
import 'package:job_platform/features/components/chat/data/models/chatResponse.dart';
import 'package:job_platform/features/components/chat/data/models/partnerModel.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PartnerModel>?> getChatList(String idUser) async {
    final partnerModel = await remoteDataSource.getChatList(idUser);
    return partnerModel;
  }
  
  @override
  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2) async {
    final chatModel = await remoteDataSource.getConversation(idUser1, idUser2);
    return chatModel;
  }

  @override
  Future<ChatResponse> markAsRead(ChatRequest request) async {
    final chatResponse = await remoteDataSource.markAsRead(request);
    return chatResponse;
  }

  @override
  Future<ChatResponse> markAsDelivered(ChatRequest request) async {
    final chatResponse = await remoteDataSource.markAsDelivered(request);
    return chatResponse;
  }

  @override
  Future<ChatResponse> deleteMessage(ChatRequest request) async {
    final chatResponse = await remoteDataSource.deleteMessage(request);
    return chatResponse;
  }
}
