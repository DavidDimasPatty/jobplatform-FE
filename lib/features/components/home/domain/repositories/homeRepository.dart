import 'package:job_platform/features/components/home/domain/entities/HomePageCompanyVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageHRVM.dart';
import 'package:job_platform/features/components/home/domain/entities/HomePageUserVM.dart';

abstract class Homerepository {
  Future<HomePageUserVM?> getHomePageUser(String id);
  Future<HomePageHRVM?> getHomePageHR(String id);
  Future<HomePageCompanyVM?> getHomeCompany(String id);
}
