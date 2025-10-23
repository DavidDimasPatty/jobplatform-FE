import 'package:job_platform/features/components/progress/domain/entities/progressAllVM.dart';
import 'package:job_platform/features/components/progress/domain/entities/progressDetailVM.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/aut_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<ProgressAllVM>?> getAllProgress(String id) async {
    final progressModel = await remoteDataSource.getAllProgress(id);
    if (progressModel != null) {
      List<ProgressAllVM>? dataStatusVM = progressModel
          .map(
            (x) => ProgressAllVM(
              namaKandidat: x.dataUser?.nama ?? null,
              namaPosisi: x.vacancy?.namaPosisi ?? null,
              tipeKerja: x.vacancy?.tipeKerja ?? null,
              idUserVacancy: x.userVacancy?.id ?? null,
              domisiliKandidat: x.dataUser?.domisili ?? null,
              status: x.status?.last.status ?? null,
              jabatanPosisi: x.vacancy?.jabatan ?? null,
              tanggalLahirKandidat: x.dataUser?.tanggalLahir ?? null,
              url: x.dataUser?.photoURL ?? null,
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
  Future<ProgressDetailVM?> getProgressDetail(String id) async {
    final progressDetailModel = await remoteDataSource.getDetailProgress(id);
    if (progressDetailModel != null) {
      ProgressDetailVM dataStatusVM = ProgressDetailVM(
        dataCertificate: progressDetailModel.dataCertificate,
        dataEducation: progressDetailModel.dataEducation,
        dataExperience: progressDetailModel.dataExperience,
        dataOrganization: progressDetailModel.dataOrganization,
        dataPreference: progressDetailModel.dataPreference,
        dataSkill: progressDetailModel.dataSkill,
        dataStatusVacancy: progressDetailModel.dataStatusVacancy,
        dataUser: progressDetailModel.dataUser,
        dataUserVacancy: progressDetailModel.dataUserVacancy,
        dataVacancy: progressDetailModel.dataVacancy,
      );
      return dataStatusVM;
    } else {
      return null;
    }
  }

  @override
  Future<String?> validateProgress(
    String idUserVacancy,
    bool status,
    String? alasanReject,
    String? idUser,
  ) async {
    final result = await remoteDataSource.validateProgress(
      idUserVacancy,
      status,
      alasanReject,
      idUser,
    );
    return result;
  }
}
