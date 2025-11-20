import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionGuard {
  Future<bool> CheckSession() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    String token = await storage.read(key: 'token') ?? "";
    return token.isNotEmpty;
  }
}
