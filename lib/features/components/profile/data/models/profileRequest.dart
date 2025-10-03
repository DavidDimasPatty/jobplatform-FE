import 'dart:convert';
import 'dart:typed_data';

class ProfileRequest {
  String idUser;
  String? nama;
  DateTime? tanggalLahir;
  String? tempatLahir;
  String? jenisKelamin;
  String? domisili;
  Uint8List? cv;
  String? headline;
  String? ringkasan;
  bool? visibility;
  int? seekStatus;
  List<String>? linkPorto;
  Uint8List? photo;
  bool? privacy;

  ProfileRequest({
    required this.idUser,
    this.nama,
    this.tanggalLahir,
    this.tempatLahir,
    this.jenisKelamin,
    this.domisili,
    this.cv,
    this.headline,
    this.ringkasan,
    this.visibility,
    this.seekStatus,
    this.linkPorto,
    this.photo,
    this.privacy
  });

  factory ProfileRequest.fromJson(Map<String, dynamic> json){
    return ProfileRequest(idUser: json['idUser']);
  }

  Map<String, dynamic> toJson() {
    return {
      "idUser": idUser,
      "nama": nama,
      "tanggalLahir": tanggalLahir?.toIso8601String(),
      "tempatLahir": tempatLahir,
      "jenisKelamin": jenisKelamin,
      "domisili": domisili,
      "cv": cv != null ? base64Encode(cv as List<int>) : null,
      "headline": headline,
      "ringkasan": ringkasan,
      "visibility": visibility,
      "seekStatus": seekStatus,
      "linkPorto": linkPorto,
    };
  }

  Map<String, dynamic> toJsonAvatar() {
    return {
      "idUser": idUser,
      "photo": photo != null ? base64Encode(photo as List<int>) : null,
    };
  }

  Map<String, dynamic> toJsonPrivacy() {
    return {
      "idUser": idUser,
      "privacy": privacy,
    };
  }
}
