import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/profile_model.dart';
import '../../data/repos/profile_repo.dart'; // استيراد الـ Repo

abstract class ProfileState {}
class ProfileInitial extends ProfileState {}
class ProfileLoading extends ProfileState {}
class ProfileSuccess extends ProfileState {
  final ProfileModel user;
  ProfileSuccess(this.user);
}
// ضيف حالة الخطأ دي عشان لو الـ ID مش موجود أو مفيش إنترنت
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  // بنحقن الـ Repo هنا عشان الـ Cubit ميعرفش Firebase شغال إزاي (Clean Architecture)
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    // بننادي الـ Repo اللي بيروح للـ Firestore بالـ UID
    final result = await profileRepo.getProfileData();

    // هنا ممكن تستخدم Either (لو بتستخدم dartz) أو try-catch بسيطة
    try {
      emit(ProfileSuccess(result));
    } catch (e) {
      emit(ProfileError("فشل في تحميل البيانات"));
    }
  }
}