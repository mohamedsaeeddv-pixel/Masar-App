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
  final ProfileRepo profileRepo;

  ProfileCubit(this.profileRepo) : super(ProfileInitial());

  Future<void> getProfileData() async {
    emit(ProfileLoading());

    try {
      // لازم النداء يكون جوه الـ try عشان نمسك أي خطأ من الـ Repo
      final result = await profileRepo.getProfileData();
      emit(ProfileSuccess(result));
    } catch (e) {
      // إحنا بنبعت الـ e.toString() اللي جاية من الـ Repo (فيها "خطأ في جلب البيانات")
      emit(ProfileError(e.toString()));
    }
  }
}