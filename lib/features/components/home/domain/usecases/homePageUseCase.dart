import 'package:job_platform/features/components/home/domain/entities/HomePageCompanyVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageHRVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageUserVM.dart';

import '../repositories/homeRepository.dart';

class homePageUseCase {
  final Homerepository repository;

  homePageUseCase(this.repository);

  Future<HomePageUserVM?> getHomePageUser(String id) {
    return repository.getHomePageUser(id);
  }

  Future<HomePageHRVM?> getHomePageHR(String id) {
    return repository.getHomePageHR(id);
  }

  Future<HomePageCompanyVM?> getHomePageCompany(String id) {
    return repository.getHomeCompany(id);
  }
}
