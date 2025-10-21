class NotificationModel {
  final String id;
  final String idUser;
  final String title;
  final String message;
  final String? route;
  final int jenis;
  final bool isRead;
  final String? idTambahan;
  final String? addId;
  final DateTime? addTime;

  NotificationModel({
    required this.id,
    required this.idUser,
    required this.title,
    required this.message,
    this.route,
    required this.jenis,
    required this.isRead,
    this.idTambahan,
    this.addId,
    this.addTime,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      idUser: json['idUser'],
      title: json['title'],
      message: json['messages'],
      route: json['route'],
      jenis: json['jenis'],
      isRead: json['isRead'] ?? false,
      idTambahan: json['idTambahan'],
      addId: json['addId'],
      addTime: json['addTime'] != null ? DateTime.parse(json['addTime']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'idUser': idUser,
      'title': title,
      'messages': message,
      'jenis': jenis,
      'route': route,
      'isRead': isRead,
      'idTambahan': idTambahan,
      'addId': addId,
      'addTime': addTime,
    };
  }
}