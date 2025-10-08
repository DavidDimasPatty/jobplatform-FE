class ProfileCompanydata {
  final String? id;
  final String? nama;
  final String? alamat;
  final String? domain;
  final DateTime? addTime;
  final DateTime? updTime;
  final String? noTelp;
  final DateTime? lastLogin;
  final String? email;
  final String? statusAccount;
  final List<String>? benefit;
  final String? deskripsi;
  final String? facebook;
  final String? industri;
  final String? instagram;
  final String? linkedin;
  final String? logo;
  final String? twitter;
  final String? tiktok;

  ProfileCompanydata({
    this.id,
    this.nama,
    this.alamat,
    this.domain,
    this.addTime,
    this.updTime,
    this.noTelp,
    this.lastLogin,
    this.email,
    this.statusAccount,
    this.benefit,
    this.deskripsi,
    this.facebook,
    this.industri,
    this.instagram,
    this.linkedin,
    this.logo,
    this.twitter,
    this.tiktok,
  });

  factory ProfileCompanydata.fromJson(Map<String, dynamic> json) {
    return ProfileCompanydata(
      id: json["data"]['_id'] ?? '',
      nama: json["data"]['nama'] ?? '',
      alamat: json["data"]['alamat'] ?? '',
      domain: json["data"]['domain'] ?? '',
      addTime: DateTime.parse(
        json["data"]['addTime'] ?? DateTime.now().toString(),
      ),
      updTime: DateTime.parse(
        json["data"]['updTime'] ?? DateTime.now().toString(),
      ),
      noTelp: json["data"]['noTelp'] ?? '',
      lastLogin: DateTime.parse(
        json["data"]['lastLogin'] ?? DateTime.now().toString(),
      ),
      email: json["data"]['email'] ?? '',
      statusAccount: json["data"]['statusAccount'] ?? '',
      benefit:
          (json["data"]['benefit'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      deskripsi: json["data"]['deskripsi'] ?? '',
      facebook: json["data"]['facebook'] ?? '',
      industri: json["data"]['industri'] ?? '',
      instagram: json["data"]['instagram'] ?? '',
      linkedin: json["data"]['linkedin'] ?? '',
      logo: json["data"]['logo'] ?? '',
      twitter: json["data"]['twitter'] ?? '',
      tiktok: json["data"]['tiktok'] ?? '',
    );
  }
}
