class KunjunganProfile {
  final List<int>? harian;
  final List<int>? mingguan;
  final List<int>? bulanan;
  KunjunganProfile({this.harian, this.mingguan, this.bulanan});

  factory KunjunganProfile.fromJson(Map<String, dynamic> json) {
    return KunjunganProfile(
      harian: json["harian"] != null
          ? List<int>.from(json["harian"].map((x) => int.parse(x.toString())))
          : null,
      mingguan: json["mingguan"] != null
          ? List<int>.from(json["mingguan"].map((x) => int.parse(x.toString())))
          : null,
      bulanan: json["bulanan"] != null
          ? List<int>.from(json["bulanan"].map((x) => int.parse(x.toString())))
          : null,
    );
  }
}
