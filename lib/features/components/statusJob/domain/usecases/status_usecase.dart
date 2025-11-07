import 'package:job_platform/features/components/statusJob/domain/entities/statusAllVM.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';

import '../repositories/auth_repository.dart';

class StatusUseCase {
  final AuthRepository repository;

  StatusUseCase(this.repository);

  Future<List<StatusAllVM>?> getAllStatus(String id) {
    return repository.getAllStatus(id);
  }

  Future<StatusDetailVM?> getDetailStatus(String id) {
    return repository.getStatusDetail(id);
  }

  Future<String?> validateVacancy(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) {
    return repository.validateVacancy(
      idUserVacancy,
      status,
      alasanReject,
      idUser,
    );
  }
}
