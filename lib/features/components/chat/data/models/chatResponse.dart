class ChatResponse {
  final String responseCode;
  final String responseMessage;
  final dynamic data;

  ChatResponse({
    required this.responseCode,
    required this.responseMessage,
    this.data,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
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
