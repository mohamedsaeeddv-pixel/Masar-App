import '../models/profile_model.dart';

abstract class ProfileRepo {
  Future<ProfileModel> getProfileData();
// ممكن مستقبلاً تضيف: Future<void> updateProfile(ProfileModel user);
}