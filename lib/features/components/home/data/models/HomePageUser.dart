import 'package:job_platform/features/components/home/data/models/HRDList.dart';
import 'package:job_platform/features/components/home/data/models/KunjunganProfile.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProfileSerupa.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';
import 'package:job_platform/features/components/home/data/models/TawaranPekerjaan.dart';

class HomePageUser {
  final List<TawaranPekerjaan>? dataTawaran;
  final double? dataProfileComplete;
  final List<ProfileSerupa>? dataProfileSerupa;
  final KunjunganProfile? dataKunjunganProfile;

  HomePageUser({
    this.dataTawaran,
    this.dataProfileComplete,
    this.dataProfileSerupa,
    this.dataKunjunganProfile,
  });

  factory HomePageUser.fromJson(Map<String, dynamic> json) {
    return HomePageUser(
      dataTawaran: json["dataTawaran"] != null
          ? List<TawaranPekerjaan>.from(
              json["dataTawaran"].map((x) => TawaranPekerjaan.fromJson(x)),
            )
          : null,
      dataProfileComplete: json["dataProfileComplete"] != null
          ? double.parse(json["dataProfileComplete"].toString())
          : null,
      dataProfileSerupa: json["dataProfileSerupa"] != null
          ? List<ProfileSerupa>.from(
              json["dataProfileSerupa"].map((x) => ProfileSerupa.fromJson(x)),
            )
          : null,
      dataKunjunganProfile: json["dataKunjunganProfile"] != null
          ? KunjunganProfile.fromJson(json["dataKunjunganProfile"])
          : null,
    );
  }
}
