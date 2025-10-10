import 'package:job_platform/features/components/vacancy/data/models/vacancyModel.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyRequest.dart';
import 'package:job_platform/features/components/vacancy/data/models/vacancyResponse.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<VacancyModel>?> getAllVacancy(String idCompany) async {
    final vacancyModel = await remoteDataSource.getAllVacancy(idCompany);
    return vacancyModel;
  }

  @override
  Future<VacancyResponse> addVacancy(VacancyRequest vacancy) async {
    final response = await remoteDataSource.addVacancy(vacancy);
    return response;
  }

  @override
  Future<VacancyResponse> editVacancy(VacancyRequest vacancy) async {
    final response = await remoteDataSource.editVacancy(vacancy);
    return response;
  }

  @override
  Future<VacancyResponse> deleteVacancy(String idVacancy) async {
    final response = await remoteDataSource.deleteVacancy(idVacancy);
    return response;
  }
}
