import 'package:job_platform/features/components/home/data/models/HRDList.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';

class HomePageCompany {
  final ProsesPerekrutan? dataProsesPerekrutan;
  final ProsesPelamaran? dataProsesPelamaran;
  final List<HRDList>? dataHRD;
  final List<OpenVacancy>? dataVacancy;
  HomePageCompany({
    this.dataProsesPerekrutan,
    this.dataProsesPelamaran,
    this.dataHRD,
    this.dataVacancy,
  });

  factory HomePageCompany.fromJson(Map<String, dynamic> json) {
    return HomePageCompany(
      dataProsesPerekrutan: json["dataProsesPerekrutan"] != null
          ? ProsesPerekrutan.fromJson(json["dataProsesPerekrutan"])
          : null,
      dataProsesPelamaran: json["dataProsesPelamaran"] != null
          ? ProsesPelamaran.fromJson(json["dataProsesPelamaran"])
          : null,
      dataVacancy: json["dataHRD"] != null
          ? List<OpenVacancy>.from(
              json["dataHRD"].map((x) => OpenVacancy.fromJson(x)),
            )
          : null,
      dataHRD: json["dataHRD"] != null
          ? List<HRDList>.from(json["dataHRD"].map((x) => HRDList.fromJson(x)))
          : null,
    );
  }
}
