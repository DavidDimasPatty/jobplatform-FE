import 'package:job_platform/features/components/profile/data/models/profileModel.dart';

abstract class AuthRepository {
  Future<ProfileModel?> profile(String id);
}
