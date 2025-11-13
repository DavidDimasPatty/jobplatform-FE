import 'package:job_platform/features/components/home/data/models/HRDList.dart';
import 'package:job_platform/features/components/home/data/models/OpenVacancy.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPelamaran.dart';
import 'package:job_platform/features/components/home/data/models/ProsesPerekrutan.dart';

class HomePageCompanyVM {
  final ProsesPerekrutan? dataProsesPerekrutan;
  final ProsesPelamaran? dataProsesPelamaran;
  final List<HRDList>? dataHRD;
  final List<OpenVacancy>? dataVacancy;
  HomePageCompanyVM({
    this.dataProsesPerekrutan,
    this.dataProsesPelamaran,
    this.dataHRD,
    this.dataVacancy,
  });
}
