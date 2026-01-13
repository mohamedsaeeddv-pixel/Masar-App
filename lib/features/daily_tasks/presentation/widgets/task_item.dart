import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
// استيراد الـ Core
import '../../../../core/constants/app_colors.dart';

class TaskItem extends StatelessWidget {
  final TaskModel task;
  final bool isDarkMode;
  
  const TaskItem({super.key, required this.task, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    // تحديد اللون بناءً على نوع المهمة باستخدام ألوان الـ Core
    Color statusColor = task.taskType.label == "استرجاع"
        
        ? AppColors.amberAccent: AppColors.cyanSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.inputBorder : AppColors.cardBackground, // من الـ Core
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
                  task.area.name,
                  style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? AppColors.textOnPrimary : AppColors.textMutedGray // من الـ Core
                  )
              ),
              _buildBadge(task.taskType.label, statusColor),
            ],
          ),
          const Divider(height: 30, color: AppColors.borderLight), // من الـ Core
          Text(
              '${'daily_tasks.client_name'.tr()}: ${task.client.name }',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDarkMode ? AppColors.textOnPrimary : AppColors.textPrimaryDark // من الـ Core
              )
          ),
          const SizedBox(height: 4),
          Text(
              task.client.phone,
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
                  '${task.totalPrice} ${'common.currency'.tr()}',
                  style: TextStyle(
                      color: isDarkMode ? AppColors.textOnPrimary : AppColors.bluePrimaryDark, // من الـ Core
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  )
              ),
              Text(
                  task.createdAt.toLocal().toString().split(' ')[0],
                  style: TextStyle(
                      color: isDarkMode ? AppColors.textOnPrimary : AppColors.textMutedGray, // من الـ Core
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