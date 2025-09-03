import 'package:job_platform/features/components/login/data/models/company.dart';
import 'package:job_platform/features/components/login/data/models/hrCompanies.dart';
import 'package:job_platform/features/components/login/data/models/progress.dart';
import 'package:job_platform/features/components/login/data/models/user.dart';

class loginModel {
  bool? exists;
  String? collection;
  UserModel? user;
  HrCompanies? hrCompanies;
  Company? company;
  Progress? progress;

  loginModel({
    this.exists,
    this.collection,
    this.user,
    this.hrCompanies,
    this.company,
    this.progress,
  });

  factory loginModel.fromJson(Map<String, dynamic> json) {
    print(json['data']['collection']);
    print(json['data']['exists']);
    return loginModel(
      collection: json['data']['collection'] != null
          ? json['data']['collection']
          : null,
      exists: json['data']['exists'] != false ? json['data']['exists'] : false,
      user: json['data']['dataLengkap']['user'] != null
          ? UserModel.fromJson(json['data']['dataLengkap']['user'])
          : null,
      hrCompanies: json['data']['dataLengkap']['hrCompanies'] != null
          ? HrCompanies.fromJson(json['data']['dataLengkap']['hrCompanies'][0])
          : null,
      company: json['data']['dataLengkap']['company'] != null
          ? Company.fromJson(json['data']['dataLengkap']['company'])
          : null,
      progress: json['data']['dataLengkap']['progress'] != null
          ? Progress.fromJson(json['data']['dataLengkap']['progress'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'hrCompanies': hrCompanies != null ? [hrCompanies!.toJson()] : [],
      'company': company?.toJson(),
      'progress': progress?.toJson(),
    };
  }
}
