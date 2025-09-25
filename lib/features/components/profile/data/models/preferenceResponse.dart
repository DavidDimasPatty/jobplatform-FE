class PreferenceResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  PreferenceResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory PreferenceResponse.fromJson(Map<String, dynamic> json) {
    return PreferenceResponse(
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
