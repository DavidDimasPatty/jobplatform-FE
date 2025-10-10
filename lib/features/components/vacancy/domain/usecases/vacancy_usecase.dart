import 'package:job_platform/features/components/vacancy/data/models/vacancyModel.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyRequest.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';

import '../repositories/auth_repository.dart';

class VacancyUseCase {
  final AuthRepository repository;

  VacancyUseCase(this.repository);

  Future<List<VacancyModel>?> getListVacancy(String idCompany) {
    return repository.getAllVacancy(idCompany);
  }

  Future<VacancyResponse> vacancyAdd(VacancyRequest vacancy){
    return repository.addVacancy(vacancy);
  }

  Future<VacancyResponse> vacancyEdit(VacancyRequest vacancy){
    return repository.editVacancy(vacancy);
  }

  Future<VacancyResponse> vacancyDelete(String id){
    return repository.deleteVacancy(id);
  }
}
