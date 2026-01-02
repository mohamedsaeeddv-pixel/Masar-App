import '../models/deal_model.dart';
abstract class DealsRepo {
  Future<List<DealModel>> fetchDeals();
}