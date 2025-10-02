class ProvinsiModel {
  final String id;
  final String nama;

  ProvinsiModel({required this.id, required this.nama});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProvinsiModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
