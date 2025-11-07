import 'package:job_platform/features/components/statusJob/domain/entities/statusAllVM.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';

abstract class AuthRepository {
  Future<List<StatusAllVM>?> getAllStatus(String id);
  Future<StatusDetailVM?> getStatusDetail(String id);
  Future<String?> validateVacancy(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  );
}
