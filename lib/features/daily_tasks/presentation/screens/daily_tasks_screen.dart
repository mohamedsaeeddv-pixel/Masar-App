import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/daily_tasks/presentation/manager/tasks_state.dart';
import '../manager/tasks_cubit.dart';
import '../widgets/navigation_card.dart';
import '../widgets/task_item.dart';

class DailyTasksScreen extends StatelessWidget {
  final String agentId; // أضفنا id الوكيل هنا

  const DailyTasksScreen({super.key, required this.agentId});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF121212) : const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: Text(
          'daily_tasks.title'.tr(),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => context.read<TasksCubit>().getTasks(),
            child: BlocBuilder<TasksCubit, TasksState>(
              builder: (context, state) {
                if (state is TasksLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TasksSuccess) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ProgressCard(clientsLength: state.tasks.length),
                        const SizedBox(height: 16),
                        NavigationCard(
                          isDarkMode: isDarkMode,
                          tasks: state.tasks.where((task) => task.status == TaskStatus.assigned).toList(),
                        ),
                        const SizedBox(height: 20),
                         Text(
                          'daily_tasks.pending_tasks'.tr(),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        state.tasks.isEmpty
                            ? _buildEmptyState(isDarkMode: isDarkMode)
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.tasks.length,
                                itemBuilder: (context, index) {
                                  if (state.tasks[index].status ==
                                      TaskStatus.assigned){
                                    return TaskItem(isDarkMode: isDarkMode, task: state.tasks[index]);}
                                  return const SizedBox.shrink();
                                },
                              ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  );
                }

                if (state is TasksFailure) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({ required bool isDarkMode}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80,
            color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
          ),
          const SizedBox(height: 16),
           Text(
            'daily_tasks.no_tasks'.tr(),
            style: TextStyle(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
