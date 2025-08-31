import 'package:job_platform/features/components/login/data/models/company.dart';
import 'package:job_platform/features/components/login/data/models/hrCompanies.dart';
import 'package:job_platform/features/components/login/data/models/progress.dart';
import 'package:job_platform/features/components/login/data/models/user.dart';

class loginModel {
  UserModel? user;
  HrCompanies? hrCompanies;
  Company? company;
  Progress? progress;

  loginModel({this.user, this.hrCompanies, this.company, this.progress});

  factory loginModel.fromJson(Map<String, dynamic> json) {
    return loginModel(
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      hrCompanies: json['hrCompanies'] != null
          ? HrCompanies.fromJson(json['hrCompanies'][0])
          : null,
      company: json['company'] != null
          ? Company.fromJson(json['company'])
          : null,
      progress: json['progress'] != null
          ? Progress.fromJson(json['progress'])
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
