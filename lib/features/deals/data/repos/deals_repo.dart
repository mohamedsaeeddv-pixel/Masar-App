import '../models/deal_model.dart';
abstract class DealsRepo {
  Stream<List<DealModel>> fetchDeals();
}