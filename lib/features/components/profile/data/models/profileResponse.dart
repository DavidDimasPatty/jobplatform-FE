class ProfileResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  ProfileResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      responseCode: json['responseCode'],
      responseMessage: json['responseMessage'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'responseCode': responseCode,
      'responseMessage': responseMessage,
      'data': data,
    };
  }
}
