class Company {
  final String id;
  final String nama;
  final String alamat;
  final String domain;
  final DateTime addTime;
  final DateTime updTime;
  final String noTelp;
  final DateTime lastLogin;
  final String email;
  final String statusAccount;

  Company({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.domain,
    required this.addTime,
    required this.updTime,
    required this.noTelp,
    required this.lastLogin,
    required this.email,
    required this.statusAccount,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      nama: json['nama'],
      alamat: json['alamat'],
      domain: json['domain'],
      addTime: DateTime.parse(json['addTime']),
      updTime: DateTime.parse(json['updTime']),
      noTelp: json['noTelp'],
      lastLogin: DateTime.parse(json['lastLogin']),
      email: json['email'],
      statusAccount: json['statusAccount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "nama": nama,
      "alamat": alamat,
      "domain": domain,
      "addTime": addTime.toIso8601String(),
      "updTime": updTime.toIso8601String(),
      "noTelp": noTelp,
      "lastLogin": lastLogin.toIso8601String(),
      "email": email,
      "statusAccount": statusAccount,
    };
  }
}
