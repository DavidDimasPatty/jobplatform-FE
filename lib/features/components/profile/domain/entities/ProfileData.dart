class Profiledata {
  final String nama;
  final String email;
  final DateTime tanggalLahir;
  final String tempatLahir;
  final String jenisKelamin;
  final DateTime lastLogin;
  final String statusAccount;
  final DateTime addTime;
  final DateTime updTime;
  final String noTelp;
  final List<String>? linkPorto;
  final String? domisili;
  final String? cv;
  final String? headline;
  final String? photoURL;
  final String? ringkasan;
  final bool? isVisible;
  final int? seekStatus;
  final bool? privacy;

  Profiledata({
    required this.nama,
    required this.email,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.jenisKelamin,
    required this.lastLogin,
    required this.statusAccount,
    required this.addTime,
    required this.updTime,
    required this.noTelp,
    this.linkPorto,
    this.domisili,
    this.cv,
    this.headline,
    this.photoURL,
    this.ringkasan,
    this.isVisible,
    this.seekStatus,
    this.privacy,
  });

  factory Profiledata.fromJson(Map<String, dynamic> json) {
    return Profiledata(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      tanggalLahir: DateTime.parse(
        json['tanggalLahir'] ?? DateTime.now().toString(),
      ),
      tempatLahir: json['tempatLahir'] ?? '',
      jenisKelamin: json['jenisKelamin'] ?? '',
      lastLogin: DateTime.parse(json['lastLogin'] ?? DateTime.now().toString()),
      statusAccount: json['statusAccount'] ?? '',
      addTime: DateTime.parse(json['addTime'] ?? DateTime.now().toString()),
      updTime: DateTime.parse(json['updTime'] ?? DateTime.now().toString()),
      noTelp: json['noTelp'] ?? "",
      linkPorto: json['linkPorto'] != null
          ? (json['linkPorto'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList()
          : null,
      domisili: json['domisili'] ?? '',
      cv: json['cv'] ?? '',
      headline: json['headline'] ?? '',
      photoURL: json['photoURL'] ?? '',
      ringkasan: json['ringkasan'] ?? '',
      isVisible: json['visibility'] != null
          ? bool.tryParse(json["visibility"].toString())
          : null,
      seekStatus: json['seekStatus'] != null
          ? int.tryParse(json["seekStatus"].toString())
          : null,
      privacy: json['privacy'] != null
          ? bool.tryParse(json["privacy"].toString())
          : null,
    );
  }
}
