class HRDList {
  final String? nama;
  final String? email;
  final String? url;
  HRDList({this.nama, this.email, this.url});

  factory HRDList.fromJson(Map<String, dynamic> json) {
    return HRDList(
      nama: json["nama"] ?? "",
      email: json["email"] ?? "",
      url: json["url"] ?? "",
    );
  }
}
