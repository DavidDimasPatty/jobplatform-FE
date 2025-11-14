class ChatRequest {
  String? idSender;
  String? idReceiver;
  String? idChat;

  ChatRequest({
    this.idSender,
    this.idReceiver,
    this.idChat,
  });

  factory ChatRequest.fromJson(Map<String, dynamic> json) {
    return ChatRequest(
      idSender: json['idUserSender'],
      idReceiver: json['idUserReceiver'],
      idChat: json['idChat'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idUserSender': idSender,
      'idUserReceiver': idReceiver,
      'idChat': idChat,
    };
  }
}