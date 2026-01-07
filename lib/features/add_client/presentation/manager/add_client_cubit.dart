import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/client_model.dart'; // تأكد من مسار الموديل بتاعك
import '../../data/repos/add_client_repo.dart';
import 'add_client_state.dart';

class AddClientCubit extends Cubit<AddClientState> {
  final AddClientRepo clientRepo;

  AddClientCubit(this.clientRepo) : super(AddClientInitial());

  // الميثود اللي الشاشة بتنادي عليها
  Future<void> saveClient({
    required String nameEn,
    required String nameAr,
    required String phone,
    required String activity,
    required String? activityType,
    required String? area,
    required String? classification,
    required String? type,
    required String lat,
    required String lng,
    required String spent,
    required String visits,
  }) async {
    // بناء الكائن باستخدام الموديل بتاعك ClientModel
    final client = ClientModel(
      name: nameEn.trim(),      // الاسم بالإنجليزي
      nameAr: nameAr.trim(),    // الاسم بالعربي
      phone: phone.trim(),
      activity: activity.trim(),
      activityType: activityType ?? "غير محدد",
      area: area ?? "غير محدد",
      classification: classification ?? 'A',
      type: type ?? 'عميل جديد',
      lastVisit: DateTime.now().toString().split(' ')[0], // تاريخ النهاردة YYYY-MM-DD
      totalSpent: int.tryParse(spent) ?? 0,
      visitsCount: int.tryParse(visits) ?? 1,
      address: GeoPoint(
        double.tryParse(lat) ?? 0.0,
        double.tryParse(lng) ?? 0.0,
      ),
    );

    await addClient(client);
  }

  // ميثود الرفع لـ Firebase
  Future<void> addClient(ClientModel client) async {
    emit(AddClientLoading());
    try {
      await clientRepo.addClient(client); // الـ Repo هيستخدم client.toMap() داخلياً
      emit(AddClientSuccess("تمت إضافة العميل ${client.nameAr} بنجاح!"));
    } catch (e) {
      emit(AddClientFailure("عذراً، تعذر حفظ البيانات: ${e.toString()}"));
    }
  }
}