import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressAllVM.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressDetailVM.dart';

abstract class AuthRepository {
  Future<List<ProgressAllVM>?> getAllProgress(String id);
  Future<ProgressDetailVM?> getProgressDetail(String id);
  Future<String?> validateProgress(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  );
  Future<String?> editVacancyCandidate(
    String idUserVacancy,
    String idUser,
    String? tipeKerja,
    String? sistemKerja,
    double? gajiMin,
    double? gajiMax,
  );
}
