class OrganizationModel {
  String? idOrganization;
  String nama;
  String lokasi;

  OrganizationModel({
    this.idOrganization,
    required this.nama,
    required this.lokasi,
  });

  factory OrganizationModel.fromJson(Map<String, dynamic> json) {
    return OrganizationModel(
      idOrganization: json['_id'],
      nama: json['nama'],
      lokasi: json['lokasi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"idOrganization": idOrganization, "nama": nama, "lokasi": lokasi};
  }
}
