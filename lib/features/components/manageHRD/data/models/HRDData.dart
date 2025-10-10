class HRDData {
  final String id;
  final String idCompany;
  final String idUser;
  final String status;
  final String nama;
  final String email;
  final String photoURL;

  HRDData({
    required this.id,
    required this.idUser,
    required this.idCompany,
    required this.status,
    required this.nama,
    required this.email,
    required this.photoURL,
  });

  factory HRDData.fromJson(Map<String, dynamic> json) {
    return HRDData(
      id: json["_id"],
      nama: json["dataHRD"]["nama"] ?? "",
      email: json["dataHRD"]["email"] ?? "",
      photoURL: json["dataHRD"]["photoURL"] ?? "",
      idCompany: json["idCompany"] ?? "",
      idUser: json["idUser"] ?? "",
      status: json["status"] ?? "",
    );
  }
}
