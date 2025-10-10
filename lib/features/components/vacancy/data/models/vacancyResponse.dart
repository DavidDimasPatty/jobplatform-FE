class VacancyResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  VacancyResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory VacancyResponse.fromJson(Map<String, dynamic> json) {
    return VacancyResponse(
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
