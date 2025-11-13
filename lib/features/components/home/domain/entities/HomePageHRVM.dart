import 'package:job_platform/features/components/home/data/models/HRDList.dart';
import 'package:job_platform/features/components/home/data/models/KunjunganProfile.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProfileSerupa.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';
import 'package:job_platform/features/components/home/data/models/TawaranPekerjaan.dart';

class HomePageHRVM {
  final List<TawaranPekerjaan>? dataTawaran;
  final double? dataProfileComplete;
  final List<ProfileSerupa>? dataProfileSerupa;
  final KunjunganProfile? dataKunjunganProfile;
  final List<OpenVacancy>? dataVacancy;

  HomePageHRVM({
    this.dataTawaran,
    this.dataProfileComplete,
    this.dataProfileSerupa,
    this.dataKunjunganProfile,
    this.dataVacancy,
  });
}
