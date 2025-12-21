import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import '../models/chats_model.dart';

abstract class ChatsRepo {
  // الاستماع للرسائل real-time مع Either للأخطاء
  Stream<Either<Failure, List<ChatModel>>> listenMessages(String chatId);

  // إرسال رسالة جديدة مع Either للأخطاء
  Future<Either<Failure, void>> sendMessage(String chatId, String senderId, String content);
}
