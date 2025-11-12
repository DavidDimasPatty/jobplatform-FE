import 'package:job_platform/features/components/chat/data/models/chatModel.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ChatModel>?> getConversation(String idUser1, String idUser2) async {
    final chatModel = await remoteDataSource.getConversation(idUser1, idUser2);
    return chatModel;
  }
}
