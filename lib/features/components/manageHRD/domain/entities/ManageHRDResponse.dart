class ManageHRDResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  ManageHRDResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory ManageHRDResponse.fromJson(Map<String, dynamic> json) {
    return ManageHRDResponse(
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
