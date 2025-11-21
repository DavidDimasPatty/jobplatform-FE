import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:job_platform/core/utils/storage/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final storage = StorageService();

  String? _token;
  bool _loading = true;

  String? get token => _token;
  bool get loading => _loading;

  Future<void> _loadToken() async {
    _token = await storage.get("token");
    _loading = false;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await storage.save("token", token);
    _token = token;
    notifyListeners();
  }

  Future<void> logout() async {
    await storage.delete("token");

    _token = null;
    notifyListeners();
  }
}
