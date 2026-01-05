import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/daily_tasks/presentation/manager/tasks_state.dart';
import '../manager/tasks_cubit.dart';
import '../widgets/progress_card.dart';
import '../widgets/navigation_card.dart';
import '../widgets/task_item.dart';

class DailyTasksScreen extends StatelessWidget {
  final String agentId; // أضفنا id الوكيل هنا

  const DailyTasksScreen({super.key, required this.agentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        title: const Text(
          'المهام اليومية',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async =>
                context.read<TasksCubit>().fetchCustomerTasks(),
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
                        ProgressCard(clientsLength: state.customerTasks.length),
                        const SizedBox(height: 16),
                        NavigationCard(clientsLength: state.customerTasks.length),
                        const SizedBox(height: 20),
                        const Text(
                          'المهام المعلقة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        state.customerTasks.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.customerTasks.length,
                                itemBuilder: (context, index) => TaskItem(
                                  taskClient: state.customerTasks[index],
                                  clientsName:
                                      state.customerTasks[index].customer.name,
                                ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(
            Icons.assignment_turned_in_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          const Text(
            "لا توجد مهام حالياً",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
