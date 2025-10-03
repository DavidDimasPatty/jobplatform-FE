class KotaModel {
  final String id;
  final String nama;

  KotaModel({required this.id, required this.nama});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KotaModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
