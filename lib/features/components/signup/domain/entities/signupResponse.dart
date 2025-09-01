import 'package:job_platform/features/components/signup/domain/entities/userData.dart';

class SignupResponseModel {
  final String responseCode;
  final String responseMessages;
  final UserData? user;

  SignupResponseModel({
    required this.responseCode,
    required this.responseMessages,
    this.user,
  });
}
