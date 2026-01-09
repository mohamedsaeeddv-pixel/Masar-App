import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import '../models/chats_model.dart';

abstract class ChatsRepo {
  /// Listen to messages for a specific chat
  /// chatId = agentId
  Stream<Either<Failure, List<ChatModel>>> listenMessages(String chatId);

  /// Send message to a specific chat
  Future<Either<Failure, void>> sendMessage(
    String chatId,
    String senderId,
    String content,
  );
}
