import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/errors/failures.dart';
import 'package:masar_app/features/chat/data/models/chats_model.dart';
import 'package:masar_app/features/chat/data/repos/chats_repo.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatsRepo repo;
  final String chatId;
  final String currentUserId;

  StreamSubscription<Either<Failure, List<ChatModel>>>? _messagesSubscription;

  ChatCubit({
    required this.repo,
    required this.chatId,
    required this.currentUserId,
  }) : super(ChatInitial());

  void listenMessages() {
    _messagesSubscription?.cancel();

    if (state is ChatSuccess) {
      emit(ChatLoading());
    }
    _messagesSubscription = repo.listenMessages(chatId).listen((either) {
      either.fold(
        (failure) => emit(ChatError(failure.message)),
        (messages) => emit(ChatSuccess(messages)),
      );
    });
  }

  Future<void> sendMessage(String content) async {
    final result = await repo.sendMessage(chatId, currentUserId, content);

    result.fold((failure) => emit(ChatError(failure.message)), (_) {});
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
