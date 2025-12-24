import 'package:flutter/material.dart';
import '../../data/models/task_model.dart';
// استيراد الـ Core
import '../../../../core/constants/app_colors.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  const TaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    // تحديد اللون بناءً على نوع المهمة باستخدام ألوان الـ Core
    Color statusColor = task.type == "تحصيل"
        ? AppColors.cyanSecondary
        : AppColors.amberAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground, // من الـ Core
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  task.taskName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMutedGray // من الـ Core
                  )
              ),
              _buildBadge(task.type, statusColor),
            ],
          ),
          const Divider(height: 30, color: AppColors.borderLight), // من الـ Core
          Text(
              'العميل: ${task.clientName}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textPrimaryDark // من الـ Core
              )
          ),
          const SizedBox(height: 4),
          Text(
              task.location,
              style: const TextStyle(
                  color: AppColors.textMutedGray, // من الـ Core
                  fontSize: 13
              )
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  task.price,
                  style: const TextStyle(
                      color: AppColors.bluePrimaryDark, // من الـ Core
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  )
              ),
              Text(
                  task.time,
                  style: const TextStyle(
                      color: AppColors.textMutedGray, // من الـ Core
                      fontSize: 14
                  )
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8)
      ),
      child: Text(
          label,
          style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold
          )
      ),
    );
  }
}