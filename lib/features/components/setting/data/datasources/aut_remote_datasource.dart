import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:job_platform/features/components/login/data/models/loginModel.dart';

class AuthRemoteDataSource {
  Future<String?> deleteAccount(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/deleteAccount',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeThemeMode(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeThemeMode',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> upgradePlan(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/upgradePlan',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeNotifApp(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeNotifApp',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeExternalNotifApp(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeExternalNotifApp',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"userId": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeEmailAccount(
    String userId,
    String loginAs,
    String oldEmail,
    String newEmail,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeEmailAccount',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "loginAs": loginAs,
          "oldEmail": oldEmail,
          "newEmail": newEmail,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> change2FA(
    String userId,
    String loginAs,
    String email,
    bool isActive,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/change2FA',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "loginAs": loginAs,
          "email": email,
          "isActive": isActive,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> validate2FA(
    String userId,
    String loginAs,
    String email,
    String otp,
    String desc,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/validate2FA',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "loginAs": loginAs,
          "email": email,
          "otp": otp,
          "desc": desc,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeLanguage(
    String userId,
    String loginAs,
    String language,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeLanguage',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "loginAs": loginAs,
          "language": language,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> changeFontSize(
    String userId,
    String loginAs,
    int fontSizeHead,
    int fontSizeSubHead,
    int fontSizeBody,
    int fontSizeIcon,
  ) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/setting/changeFontSize',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "userId": userId,
          "loginAs": loginAs,
          "fontSizeHead": fontSizeHead,
          "fontSizeSubHead": fontSizeSubHead,
          "fontSizeBody": fontSizeBody,
          "fontSizeIcon": fontSizeIcon,
        }),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }

  Future<String?> logOut(String userId, String loginAs) async {
    try {
      final url = Uri.parse(
        '${dotenv.env['BACKEND_URL_DEV']}/api/v1/account/logout',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"_id": userId, "loginAs": loginAs}),
      );
      print(response.body.toString());
      final Map<String, dynamic> jsonData;
      if (response.statusCode == 200 || response.statusCode == 201) {
        jsonData = jsonDecode(response.body);
        if (jsonData["responseCode"].toString()!.contains("200")) {
          return jsonData["responseMessage"].toString();
        } else {
          return "Gagal : ${jsonData["responseMessage"]}";
        }
      } else {
        jsonData = jsonDecode(response.body);
        print('Gagal : ${response.statusCode} ${jsonData}');
        return "Gagal : ${jsonData["ressponseMessage"]}";
      }
    } catch (e) {
      print('Error: $e');
      return "Gagal $e";
    }
  }
}
