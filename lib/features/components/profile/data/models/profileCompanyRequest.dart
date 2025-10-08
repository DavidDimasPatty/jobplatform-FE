import 'dart:convert';
import 'dart:typed_data';

class ProfileCompanyRequest {
  String idCompany;
  final String? nama;
  final String? alamat;
  final String? domain;
  final String? noTelp;
  final String? email;
  final String? statusAccount;
  final List<String>? benefit;
  final String? deskripsi;
  final String? facebook;
  final String? industri;
  final String? instagram;
  final String? linkedin;
  final Uint8List? logo;
  final String? twitter;
  final String? tiktok;
  bool? privacy;

  ProfileCompanyRequest({
    required this.idCompany,
    this.nama,
    this.alamat,
    this.domain,
    this.noTelp,
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
    this.privacy,
  });

  factory ProfileCompanyRequest.fromJson(Map<String, dynamic> json) {
    return ProfileCompanyRequest(idCompany: json['idUser']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idCompany": idCompany,
      "nama": nama,
      "alamat": alamat,
      "domain": domain,
      "noTelp": noTelp,
      "email": email,
      "statusAccount": statusAccount,
      "benefit": benefit,
      "deskripsi": deskripsi,
      "facebook": facebook,
      "industri": industri,
      "instagram": instagram,
      "linkedin": linkedin,
      "twitter": twitter,
      "tiktok": tiktok,
    };
  }

  Map<String, dynamic> toJsonAvatar() {
    return {
      "idCompany": idCompany,
      "logo": logo != null ? base64Encode(logo as List<int>) : null,
    };
  }

  Map<String, dynamic> toJsonPrivacy() {
    return {"idCompany": idCompany, "privacy": privacy};
  }
}
