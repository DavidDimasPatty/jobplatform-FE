import 'package:job_platform/features/components/manageHRD/data/models/GetAllHRDTransaction.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/HRDDataVM.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/ManageHRDResponse.dart';

abstract class AuthRepository {
  Future<List<HRDDataVM?>?> getDataHRD(String idCompany);
  Future<ManageHRDResponse?> deleteHRD(GetAllHRDTransaction profile);
  Future<ManageHRDResponse?> addHRD(GetAllHRDTransaction profile, String email);
}
