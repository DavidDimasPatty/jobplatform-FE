import 'package:job_platform/features/components/notification/data/models/notificationModel.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationModel>?> notificationGet(String id) async {
    final notificationModel = await remoteDataSource.notificationGet(id);
    return notificationModel;
  }

  @override
  Future<NotificationResponse> notificationRead(NotificationRequest notification) async {
    final notificationResponse = await remoteDataSource.notificationRead(notification);
    return notificationResponse;
  }
}