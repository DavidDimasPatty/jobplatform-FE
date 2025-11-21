import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late final enc.Key _key = enc.Key.fromUtf8(dotenv.env['AES_KEY']!);

  late final enc.IV _iv = enc.IV.fromUtf8(dotenv.env['AES_IV']!);

  late final enc.Encrypter _encrypter = enc.Encrypter(
    enc.AES(_key, mode: enc.AESMode.cbc),
  );

  String encrypt(String text) {
    return _encrypter.encrypt(text, iv: _iv).base64;
  }

  String decrypt(String encrypted) {
    return _encrypter.decrypt64(encrypted, iv: _iv);
  }

  Future<void> save(String key, String value) async {
    final encrypted = encrypt(value);

    if (kIsWeb) {
      html.window.localStorage[key] = encrypted;
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(key, encrypted);
    }
  }

  Future<String?> get(String key) async {
    String? encrypted;

    if (kIsWeb) {
      encrypted = html.window.localStorage[key];
    } else {
      final prefs = await SharedPreferences.getInstance();
      encrypted = prefs.getString(key);
    }

    if (encrypted == null) return null;

    try {
      return decrypt(encrypted);
    } catch (e) {
      print("Decrypt failed: $e");
      return null;
    }
  }

  Future<void> delete(String key) async {
    if (kIsWeb) {
      html.window.localStorage.remove(key);
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  Future<void> clear() async {
    if (kIsWeb) {
      html.window.localStorage.clear();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
