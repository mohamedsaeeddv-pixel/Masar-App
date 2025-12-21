import 'package:flutter/material.dart';
import 'package:masar_app/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:masar_app/core/constants/app_styles.dart';

class ChatBubble extends StatelessWidget {
  final String message; // RichText content
  final bool isSent;
  final DateTime timestamp;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isSent,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    double maxBubbleWidth = MediaQuery.of(context).size.width * 0.7;

    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxBubbleWidth,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSent ? AppColors.chartBlue : AppColors.chartGray,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSent ? 16 : 0),
            bottomRight: Radius.circular(isSent ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: AppTextStyles.subtitle18Regular.copyWith(
                color:Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('hh:mm a').format(timestamp),
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
