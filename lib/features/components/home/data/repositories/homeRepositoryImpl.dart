import 'package:job_platform/features/components/home/data/models/HomePageCompany.dart';

import 'package:job_platform/features/components/home/data/models/HomePageHR.dart';

import 'package:job_platform/features/components/home/data/models/HomePageUser.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageCompanyVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageHRVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageUserVM.dart';

import '../../domain/repositories/homeRepository.dart';
import '../datasources/HomeRemoteDataSource.dart';

class homeRepositoryImpl implements Homerepository {
  final HomeRemoteDataSource remoteDataSource;

  homeRepositoryImpl(this.remoteDataSource);

  @override
  Future<HomePageCompanyVM?> getHomeCompany(String id) async {
    final homeCompany = await remoteDataSource.getHomePageCompany(id);
    if (homeCompany != null) {
      HomePageCompanyVM? homeCompanyVM = HomePageCompanyVM(
        dataHRD: homeCompany.dataHRD,
        dataProsesPelamaran: homeCompany.dataProsesPelamaran,
        dataProsesPerekrutan: homeCompany.dataProsesPerekrutan,
        dataVacancy: homeCompany.dataVacancy,
      );
      return homeCompanyVM;
    } else {
      return null;
    }
  }

  @override
  Future<HomePageHRVM?> getHomePageHR(String id) async {
    final homeHR = await remoteDataSource.getHomePageHR(id);
    if (homeHR != null) {
      HomePageHRVM? homeHRVM = HomePageHRVM(
        dataKunjunganProfile: homeHR.dataKunjunganProfile,
        dataProfileComplete: homeHR.dataProfileComplete,
        dataProfileSerupa: homeHR.dataProfileSerupa,
        dataVacancy: homeHR.dataVacancy,
        dataTawaran: homeHR.dataTawaran,
      );
      return homeHRVM;
    } else {
      return null;
    }
  }

  @override
  Future<HomePageUserVM?> getHomePageUser(String id) async {
    final homeUser = await remoteDataSource.getHomePageUser(id);
    if (homeUser != null) {
      HomePageUserVM? homeUserVM = HomePageUserVM(
        dataKunjunganProfile: homeUser.dataKunjunganProfile,
        dataProfileComplete: homeUser.dataProfileComplete,
        dataProfileSerupa: homeUser.dataProfileSerupa,
        dataTawaran: homeUser.dataTawaran,
      );
      return homeUserVM;
    } else {
      return null;
    }
  }
}
