class WorkExperienceResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  WorkExperienceResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory WorkExperienceResponse.fromJson(Map<String, dynamic> json) {
    return WorkExperienceResponse(
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