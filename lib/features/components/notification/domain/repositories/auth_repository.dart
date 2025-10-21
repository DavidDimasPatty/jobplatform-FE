import 'package:job_platform/features/components/notification/data/models/notificationModel.dart';
import 'package:job_platform/features/components/notification/data/models/notificationRequest.dart';
import 'package:job_platform/features/components/notification/data/models/notificationResponse.dart';

abstract class AuthRepository {
  Future<List<NotificationModel>?> notificationGet(String id);
  Future<NotificationResponse> notificationRead(NotificationRequest notification);
}
