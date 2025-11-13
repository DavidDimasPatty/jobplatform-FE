class ProfileSerupa {
  final String? id;
  final String? nama;
  final String? urlPhoto;
  final int? umur;
  final String? posisi;
  ProfileSerupa({this.id, this.nama, this.urlPhoto, this.umur, this.posisi});

  factory ProfileSerupa.fromJson(Map<String, dynamic> json) {
    return ProfileSerupa(
      id: json["id"] ?? "",
      nama: json["nama"] ?? "",
      urlPhoto: json["urlPhoto"] ?? "",
      umur: json["umur"] != null ? int.parse(json["umur"].toString()) : null,
      posisi: json["posisi"] ?? "",
    );
  }
}
