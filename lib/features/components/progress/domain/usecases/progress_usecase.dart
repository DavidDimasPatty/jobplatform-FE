import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressAllVM.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressDetailVM.dart';

import '../repositories/auth_repository.dart';

class ProgressUsecase {
  final AuthRepository repository;

  ProgressUsecase(this.repository);

  Future<List<ProgressAllVM>?> getAllProgress(String id) {
    return repository.getAllProgress(id);
  }

  Future<ProgressDetailVM?> getDetailProgress(String id) {
    return repository.getProgressDetail(id);
  }

  Future<String?> validateProgress(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) {
    return repository.validateProgress(
      idUserVacancy,
      status,
      alasanReject,
      idUser,
    );
  }
}
