class SignupModel {
  final String status;
  final String responseMessages;

  SignupModel({required this.status, required this.responseMessages});

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      status: json['status'],
      responseMessages: json['responseMessages'],
    );
  }
}
