import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/chat/data/models/chats_model.dart';
import 'package:masar_app/features/chat/data/repos/chats_repo.dart';

import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatsRepo repo;
  StreamSubscription<Either<Failure, List<ChatModel>>>? _messagesSubscription;

  ChatCubit({required this.repo}) : super(ChatInitial());

 void listenMessages(String chatId) {
  emit(ChatLoading());
  _messagesSubscription?.cancel();

  _messagesSubscription = repo.listenMessages(chatId).listen((either) {
    either.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(ChatSuccess(messages)),
    );
  });
}

Future<void> sendMessage(String chatId, String senderId, String content) async {
  final result = await repo.sendMessage(chatId, senderId, content);
  result.fold(
    (failure) => emit(ChatError(failure.message)),
    (_) => null,
  );
}
  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
