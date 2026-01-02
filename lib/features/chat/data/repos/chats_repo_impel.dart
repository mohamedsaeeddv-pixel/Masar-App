import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import '../models/chats_model.dart';
import 'chats_repo.dart';


class ChatsRepoImpl implements ChatsRepo {
  final FirebaseFirestore firestore;

  ChatsRepoImpl({required this.firestore});

  @override
  Stream<Either<Failure, List<ChatModel>>> listenMessages(String chatId) async* {
    try {
      yield* firestore
          .collection('chat')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) {
        final messages = snapshot.docs.map((doc) => ChatModel.fromMap(doc.data())).toList();
        return Right(messages);
      });
    } on FirebaseException catch (e) {
      yield Left(FirebaseFailure.fromException(e));
    } catch (e) {
      yield Left(FirebaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(String chatId, String senderId, String content) async {
    try {
      await firestore
          .collection('chat')
          .doc(chatId)
          .collection('messages')
          .add({
        'content': content,
        'senderId': senderId,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return const Right(null);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure.fromException(e));
    } catch (e) {
      return Left(FirebaseFailure(message: e.toString()));
    }
  }
}
