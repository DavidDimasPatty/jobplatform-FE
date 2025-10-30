class Companies {
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
  final String? tiktok;
  final String? twitter;

  Companies({
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
    this.tiktok,
    this.twitter,
  });

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      id: json["_id"] ?? null,
      nama: json["nama"] ?? null,
      alamat: json["alamat"] ?? null,
      domain: json["domain"] ?? null,
      addTime: json["addTime"] != null ? DateTime.parse(json["addTime"]) : null,
      updTime: json["updTime"] != null ? DateTime.parse(json["updTime"]) : null,
      benefit: json["benefit"] != null
          ? List<String>.from(json["benefit"].map((x) => x.toString()))
          : null,
      deskripsi: json["deskripsi"] ?? null,
      email: json["email"] ?? null,
      facebook: json["facebook"] ?? null,
      industri: json["industri"] ?? null,
      instagram: json["instagram"] ?? null,
      lastLogin: json["lastLogin"] != null
          ? DateTime.parse(json["lastLogin"])
          : null,
      linkedin: json["linkedin"] ?? null,
      logo: json["logo"] ?? null,
      noTelp: json["noTelp"] ?? null,
      statusAccount: json["statusAccount"] ?? null,
      tiktok: json["tiktok"] ?? null,
      twitter: json["twitter"] ?? null,
    );
  }
}
