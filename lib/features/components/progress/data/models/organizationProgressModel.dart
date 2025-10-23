class OrganizationProgressModel {
  String? idOrganization;
  String? nama;
  String? lokasi;
  bool? isActive;
  String? jabatan;
  DateTime? startDate;
  DateTime? endDate;

  OrganizationProgressModel({
    this.idOrganization,
    this.nama,
    this.lokasi,
    this.isActive,
    this.jabatan,
    this.startDate,
    this.endDate,
  });

  factory OrganizationProgressModel.fromJson(Map<String, dynamic> json) {
    return OrganizationProgressModel(
      idOrganization: json['organization'] != null
          ? json['organization']["id"] ?? null
          : null,
      nama: json['organization'] != null
          ? json['organization']["nama"] ?? null
          : null,
      lokasi: json['organization'] != null
          ? json['organization']["lokasi"] ?? null
          : null,
      endDate: json['userOrganization'] != null
          ? DateTime.tryParse(json['userOrganization']["endDate"]) ?? null
          : null,
      isActive: json['userOrganization'] != null
          ? bool.tryParse(json['userOrganization']["isActive"]) ?? null
          : null,
      jabatan: json['userOrganization'] != null
          ? json['userOrganization']["jabatan"] ?? null
          : null,
      startDate: json['userOrganization'] != null
          ? DateTime.tryParse(json['userOrganization']["startDate"]) ?? null
          : null,
    );
  }
}
