class ChatModel {
  final String id;
  final String idUser;
  final String message;
  final String addId;
  final DateTime addTime;
  DateTime? isRead;
  DateTime? isDelivered;
  DateTime? isDelete;

  ChatModel({
    required this.id,
    required this.idUser,
    required this.message,
    required this.addId,
    required this.addTime,
    this.isRead,
    this.isDelivered,
    this.isDelete,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      idUser: json['idUser'],
      message: json['messages'],
      addId: json['addId'],
      addTime: DateTime.parse(json['addTime']),
      isRead: json['isRead'] != null ? DateTime.parse(json['isRead']) : null,
      isDelivered: json['isDelivered'] != null ? DateTime.parse(json['isDelivered']) : null,
      isDelete: json['isDelete'] != null ? DateTime.parse(json['isDelete']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'idUser': idUser,
      'message': message,
      'addId': addId,
      'addTime': addTime.toIso8601String(),
      'isRead': isRead?.toIso8601String(),
      'isDelivered': isDelivered?.toIso8601String(),
      'isDelete': isDelete?.toIso8601String(),
    };
  }
}
