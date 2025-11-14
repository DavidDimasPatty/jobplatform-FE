class PartnerModel {
  final String partnerId;
  final String partnerName;
  final String partnerPhotoUrl;
  final String lastMessage;
  final DateTime lastMessageTime;
  int unreadCount;
  String lastMessageStatus;

  PartnerModel({
    required this.partnerId,
    required this.partnerName,
    required this.partnerPhotoUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.lastMessageStatus,
  });

  factory PartnerModel.fromJson(Map<String, dynamic> json) {
    return PartnerModel(
      partnerId: json['partnerId'],
      partnerName: json['partnerName'],
      partnerPhotoUrl: json['partnerPhotoUrl'],
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      unreadCount: json['unreadCount'],
      lastMessageStatus: json['lastMessageStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partnerId': partnerId,
      'partnerName': partnerName,
      'partnerPhotoUrl': partnerPhotoUrl,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'unreadCount': unreadCount,
      'lastMessageStatus': lastMessageStatus,
    };
  }
}
