import 'package:flutter_bloc/flutter_bloc.dart';

// تعريف الحالات (States)
class HomeState {
  final int index;
  HomeState(this.index);
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(2));

  void changeIndex(int newIndex) {
    emit(HomeState(newIndex));
  }
}