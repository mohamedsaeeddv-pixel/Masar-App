import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_models/client_model.dart';
import '../../data/repos/add_client_repo.dart';
import 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  final AddClientRepo clientRepo; // بنعتمد على العقد (Interface)

  AddClientCubit(this.clientRepo) : super(AddClientInitial());

  Future<void> addClient(ClientModel client) async {
    emit(AddClientLoading()); // بنقول للشاشة "أنا بحمل"

    try {
      await clientRepo.addClient(client);
      emit(AddClientSuccess("تمت إضافة العميل بنجاح!"));
    } catch (e) {
      emit(AddClientFailure("عذراً، حدث خطأ: ${e.toString()}"));
    }
  }
}