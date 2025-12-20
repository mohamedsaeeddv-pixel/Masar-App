import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundColor: Color(0xFF1565C0),
              child: Icon(Icons.person, color: Colors.white, size: 40),
            ),

            // ✅ Online indicator ملتحم مع الدايرة
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Colors.white, // فاصل أبيض زي التصميم
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),
        const Text(
          'محمد أحمد',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        const Text(
          'ID: #88231',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'متصل',
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }
}
