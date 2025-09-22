class CertificateResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  CertificateResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory CertificateResponse.fromJson(Map<String, dynamic> json) {
    return CertificateResponse(
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