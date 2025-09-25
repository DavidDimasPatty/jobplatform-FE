class OrganizationMV {
  String id;
  String idUser;
  String idOrganization;
  String? nama;
  DateTime? startDate;
  DateTime? endDate;
  String? deskripsi;
  String? jabatan;

  OrganizationMV(
    this.id,
    this.idUser,
    this.idOrganization,
    this.nama,
    this.startDate,
    this.endDate,
    this.deskripsi,
    this.jabatan,
  );

  factory OrganizationMV.fromJson(Map<String, dynamic> json) {
    return OrganizationMV(
      json['userOrganization']['_id'] as String,
      json['userOrganization']['idUser'] as String,
      json['userOrganization']['idOrganization'] as String,
      json['organization']['nama'] as String?,
      json['userOrganization']['startDate'] != null ? DateTime.parse(json['userOrganization']['startDate']) : null,
      json['userOrganization']['endDate'] != null ? DateTime.parse(json['userOrganization']['endDate']) : null,
      json['userOrganization']['deskripsi'] as String?,
      json['userOrganization']['jabatan'] as String?,
    );
  }
}
