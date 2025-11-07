import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/manageHRD/data/models/GetAllHRDTransaction.dart';
import 'package:job_platform/features/components/manageHRD/data/models/HRDData.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/HRDDataVM.dart';
import 'package:job_platform/features/components/manageHRD/domain/entities/ManageHRDResponse.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<HRDDataVM?>?> getDataHRD(String idCompany) async {
    final HRDModel = await remoteDataSource.getAllDataHRD(idCompany);
    if (HRDModel != null) {
      List<HRDDataVM>? dataHRDVM = HRDModel.map(
        (e) => HRDDataVM(
          id: e!.dataHRD!.id,
          nama: e.dataHRD!.nama,
          email: e.dataHRD!.email,
          photoURL: e.dataHRD!.photoURL,
          status: e.dataHRD!.status,
        ),
      ).toList();

      return dataHRDVM;
    } else {
      return null;
    }
  }

  @override
  Future<ManageHRDResponse?> deleteHRD(GetAllHRDTransaction profile) async {
    final HRDResponseModel = await remoteDataSource.deleteHRD(profile);
    return HRDResponseModel;
  }

  @override
  Future<ManageHRDResponse?> addHRD(
    GetAllHRDTransaction profile,
    String email,
  ) async {
    final HRDResponseModel = await remoteDataSource.addHRD(profile, email);
    return HRDResponseModel;
  }
}
