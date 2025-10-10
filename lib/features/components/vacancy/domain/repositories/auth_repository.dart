import 'package:job_platform/features/components/vacancy/data/models/vacancyModel.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyRequest.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';

abstract class AuthRepository {
  Future<List<VacancyModel>?> getAllVacancy(String idCompany);
  Future<VacancyResponse> addVacancy(VacancyRequest vacancy);
  Future<VacancyResponse> editVacancy(VacancyRequest vacancy);
  Future<VacancyResponse> deleteVacancy(String idVacancy);
}
