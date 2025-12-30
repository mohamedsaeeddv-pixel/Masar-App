import '../models/deal_model.dart';
import 'deals_repo.dart';

class DealsRepoImpl implements DealsRepo {
  @override
  Future<List<DealModel>> fetchDeals() async {
    await Future.delayed(const Duration(milliseconds: 800)); // محاكاة الشبكة
    return [
      DealModel(dealId: "DL-4829", customerId: "CUST-99281", customerName: "أحمد محمد", amount: "350 جنيه", status: "تم التوصيل", location: "المعادي، القاهرة", phone: "01012345678"),
      DealModel(dealId: "DL-4832", customerId: "CUST-45182", customerName: "", amount: "0", status: "قيد الانتظار", location: "", phone: ""),
      DealModel(dealId: "DL-4810", customerId: "CUST-77392", customerName: "سارة حسن", amount: "280 جنيه", status: "تم التوصيل", location: "مدينة نصر، القاهرة", phone: "01098765432"),
      DealModel(dealId: "DL-4890", customerId: "CUST-88934", customerName: "", amount: "0", status: "فشل", location: "", phone: ""),
    ];
  }
}