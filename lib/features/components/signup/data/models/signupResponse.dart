import 'package:job_platform/features/components/signup/data/models/userModel.dart';

class SignupResponseModel {
  final String responseCode;
  final String responseMessages;
  final UserModel? user;

  SignupResponseModel({
    required this.responseCode,
    required this.responseMessages,
    this.user,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      user: json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
      responseCode: json['responseCode'],
      responseMessages: json['responseMessage'],
    );
  }
}
