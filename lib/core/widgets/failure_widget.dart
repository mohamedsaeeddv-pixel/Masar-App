import 'package:flutter/material.dart';

class FailureWidget extends StatelessWidget {
  final String message;       // رسالة الخطأ
  final VoidCallback? onRetry; // دالة إعادة المحاولة

  const FailureWidget({
    super.key,
    this.message = "حدث خطأ ما، يرجى المحاولة مرة أخرى.",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text("إعادة المحاولة"),
            ),
          ]
        ],
      ),
    );
  }
}
