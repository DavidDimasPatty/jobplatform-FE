class SkillResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  SkillResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory SkillResponse.fromJson(Map<String, dynamic> json) {
    return SkillResponse(
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
