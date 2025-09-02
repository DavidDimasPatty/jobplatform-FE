import 'package:job_platform/features/components/signup/data/models/companyModel.dart';
import 'package:job_platform/features/components/signup/data/models/userModel.dart';

class SignupResponseModel {
  final String responseCode;
  final String responseMessages;
  final UserModel? user;
  final CompanyModel? company;

  SignupResponseModel({
    required this.responseCode,
    required this.responseMessages,
    this.user,
    this.company,
  });

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      user: json['data']['user'] != null
          ? UserModel.fromJson(json['data']['user'])
          : null,
      company: json['data']['company'] != null
          ? CompanyModel.fromJson(json['data']['company'])
          : null,
      responseCode: json['responseCode'],
      responseMessages: json['responseMessage'],
    );
  }
}
