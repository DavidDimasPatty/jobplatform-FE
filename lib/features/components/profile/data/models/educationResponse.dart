class EducationResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  EducationResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory EducationResponse.fromJson(Map<String, dynamic> json) {
    return EducationResponse(
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