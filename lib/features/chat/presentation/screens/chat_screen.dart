import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/core/widgets/custom_app_bar.dart';
import 'package:masar_app/core/utils/app_validators.dart';
import 'package:masar_app/core/widgets/failure_widget.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_cubit.dart';
import 'package:masar_app/features/chat/presentation/manager/chat_state.dart';
import 'package:masar_app/features/chat/presentation/widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late TextEditingController _messageController;
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
        text,
      );
    
    }
    FocusScope.of(context).unfocus(); // إغلاق الكيبورد
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    if (bottomInset > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(title: "خدمة  العملاء"),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatSuccess) {
                    final messages = state.messages;
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      physics:const BouncingScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
    final message = messages[messages.length - 1 - index]; // عكس ترتيب الرسائل
                        final isSent = message.senderId == widget.currentUserId;
                        return ChatBubble(
                          message: message.content,
                          isSent: isSent,
                          timestamp: message.timestamp,
                        );
                      },
                    );
                  } else if (state is ChatError) {
                    return Center(
                      child: FailureWidget(
                        message: state.error,
                        onRetry: () {
                          context.read<ChatCubit>().listenMessages(
                            
                          );
                        },
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: "اكتب رسالتك...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(32)),),
                        ),
                        validator: (value) => AppValidators.chatMessage(value),
                        onFieldSubmitted: (_) {
                          if (_formKey.currentState!.validate()) {
                            _sendMessage();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _sendMessage();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
