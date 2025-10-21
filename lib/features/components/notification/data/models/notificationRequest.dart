class NotificationRequest {
  final List<String> idNotification;

  NotificationRequest({
    required this.idNotification,
  });

  factory NotificationRequest.fromJson(Map<String, dynamic> json) {
    return NotificationRequest(
      idNotification: List<String>.from(json['idNotification']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idNotification': idNotification,
    };
  }
}