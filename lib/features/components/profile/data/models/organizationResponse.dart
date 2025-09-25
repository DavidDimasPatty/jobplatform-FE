class OrganizationResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  OrganizationResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory OrganizationResponse.fromJson(Map<String, dynamic> json) {
    return OrganizationResponse(
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
