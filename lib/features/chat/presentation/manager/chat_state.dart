import 'package:masar_app/features/chat/data/models/chats_model.dart';


abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<ChatModel> messages;
  ChatSuccess(this.messages);
}

class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
