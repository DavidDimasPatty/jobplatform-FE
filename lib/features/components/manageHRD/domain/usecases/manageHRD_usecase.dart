import 'package:job_platform/features/components/manageHRD/data/models/GetAllHRDTransaction.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/HRDDataVM.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/ManageHRDResponse.dart';

import '../repositories/auth_repository.dart';

class ManagehrdUsecase {
  final AuthRepository repository;

  ManagehrdUsecase(this.repository);

  Future<List<HRDDataVM?>?> getAllHRD(String idCompany) {
    return repository.getDataHRD(idCompany);
  }

  Future<ManageHRDResponse?> deleteHRD(GetAllHRDTransaction profile) {
    return repository.deleteHRD(profile);
  }

  Future<ManageHRDResponse?> addHRD(
    GetAllHRDTransaction profile,
    String email,
  ) {
    return repository.addHRD(profile, email);
  }
}
