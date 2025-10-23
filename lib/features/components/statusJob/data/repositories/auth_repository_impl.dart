import 'package:job_platform/features/components/login/data/models/loginModel.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusAllVM.dart';
import 'package:job_platform/features/components/statusJob/domain/entities/statusDetailVM.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<StatusAllVM>?> getAllStatus(String id) async {
    final statusModel = await remoteDataSource.getAllStatus(id);
    if (statusModel != null) {
      List<StatusAllVM>? dataStatusVM = statusModel
          .map(
            (x) => StatusAllVM(
              namaPerusahaan: x.company?.nama ?? null,
              namaPosisi: x.vacancy?.namaPosisi ?? null,
              jabatan: x.vacancy?.jabatan ?? null,
              tipeKerja: x.vacancy?.tipeKerja ?? null,
              idUserVacancy: x.userVacancy?.id ?? null,
              logoPerusahaan: x.company?.logo ?? null,
              status: x.status?.last.status ?? null,
              isAcceptUser: x.userVacancy?.isAccept ?? null,
              isRejectHRD:
                  (x.status?.last.alasanReject?.trim().isNotEmpty ?? false),
            ),
          )
          .toList();

      return dataStatusVM;
    } else {
      return null;
    }
  }

  @override
  Future<StatusDetailVM?> getStatusDetail(String id) async {
    final statusDetailModel = await remoteDataSource.getDetailStatus(id);
    if (statusDetailModel != null) {
      StatusDetailVM dataStatusVM = StatusDetailVM(
        namaPerusahaan: statusDetailModel.company?.nama ?? null,
        bidangPerusahaan: statusDetailModel.company?.industri ?? null,
        benefit: statusDetailModel.company?.benefit ?? null,
        gajiMax: statusDetailModel.vacancy?.gajiMax ?? null,
        gajiMin: statusDetailModel.vacancy?.gajiMin ?? null,
        jabatan: statusDetailModel.vacancy?.jabatan ?? null,
        logoPerusahaan: statusDetailModel.company?.logo ?? null,
        lokasiKerja: statusDetailModel.vacancy?.lokasi ?? null,
        lokasiPerusahaan: statusDetailModel.company?.alamat ?? null,
        namaPosisi: statusDetailModel.vacancy?.namaPosisi ?? null,
        sistemKerja: statusDetailModel.vacancy?.sistemKerja ?? null,
        tipePekerjaan: statusDetailModel.vacancy?.tipeKerja ?? null,
        userStatus: statusDetailModel.status ?? null,
        userVacancy: statusDetailModel.userVacancy ?? null,
      );
      return dataStatusVM;
    } else {
      return null;
    }
  }

  @override
  Future<String?> validateVacancy(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) async {
    final result = await remoteDataSource.validateVacancy(
      idUserVacancy,
      status,
      alasanReject,
      idUser,
    );
    return result;
  }
}
