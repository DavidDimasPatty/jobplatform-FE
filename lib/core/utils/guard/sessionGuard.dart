import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionGuard {
  Future<bool> CheckSession() async {
    StorageService authProviderLogIn = StorageService();
    String? token = await authProviderLogIn.get("token");
    return token?.isNotEmpty ?? false;
  }
}
