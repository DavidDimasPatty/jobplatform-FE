class SignupResponseModel {
  final String status;
  final String responseMessages;

  SignupResponseModel({required this.status, required this.responseMessages});

  factory SignupResponseModel.fromJson(Map<String, dynamic> json) {
    return SignupResponseModel(
      status: json['status'],
      responseMessages: json['responseMessages'],
    );
  }
}
