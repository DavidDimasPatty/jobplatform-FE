import 'package:job_platform/features/components/notification/data/models/notificationModel.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';

import '../repositories/auth_repository.dart';

class NotificationUsecase {
  final AuthRepository repository;

  NotificationUsecase(this.repository);

  Future<List<NotificationModel>?> getNotification(String id) {
    return repository.notificationGet(id);
  }

  Future<NotificationResponse> readNotification(NotificationRequest notification) {
    return repository.notificationRead(notification);
  }
}