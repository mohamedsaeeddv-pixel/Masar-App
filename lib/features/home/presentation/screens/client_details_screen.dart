// Customer Details Screen
// Displays comprehensive information about a specific customer
// including personal info, location, purchase history, and order actions

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/core/constants/app_colors.dart';
import 'package:masar_app/core/constants/app_styles.dart';
import 'package:masar_app/core/widgets/custom_app_bar.dart';
import 'package:masar_app/core/utils/snack_bar_helper.dart';
import 'package:masar_app/core/widgets/custom_dialog_for_confirm.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_type_model.dart';
import 'package:masar_app/features/home/data/repos/client_details_repos/client_details_repo_impl.dart';
import 'package:masar_app/features/home/data/repos/order_repo_imple.dart';
import 'package:masar_app/features/home/data/repos/product_repo_imple.dart';
import 'package:masar_app/features/home/presentation/manager/clients_details/cubit/client_details_cubit.dart';
import 'package:masar_app/features/home/presentation/manager/orders/cubit/order_cubit.dart';
import 'package:masar_app/features/home/presentation/widgets/order_dialog.dart';
import 'package:masar_app/features/home/presentation/widgets/product_items_section.dart';
import 'package:masar_app/features/login/presentation/manager/auth_cubit.dart';
import 'package:masar_app/routes/app_routes.dart';

/// Main screen widget for displaying detailed customer information
/// Shows customer data, location, purchase stats, and available actions
class ClientDetailsScreen extends StatelessWidget {
  final String clientId;
  final TaskModel task;
  final List<TaskModel> tasks;

  const ClientDetailsScreen({
    super.key,
    required this.clientId,
    required this.task,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClientDetailsCubit(
        clientRepository: ClientDetailsRepositoryImpl(
          firestore: FirebaseFirestore.instance,
        ),
      )..getClientDetails(clientId),
      child: ClientDetailsView(task: task, tasks: tasks),
    );
  }
}

class ClientDetailsView extends StatelessWidget {
  final TaskModel task;
  final List<TaskModel> tasks;

  const ClientDetailsView({super.key, required this.task, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with title and edit action
      appBar: CustomAppBar(
        title: "تفاصيل العميل",
        // leading: IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
        actions: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
              color: AppColors.bluePrimaryDark,
            ),
            onPressed: () {
              // Navigate to edit client screen
              context.pushNamed(AppRoutes.home);
            },
          ),
        ],
      ),
      // Scrollable body containing all customer information sections
      body: BlocConsumer<ClientDetailsCubit, ClientDetailsState>(
        listener: (context, state) {
          if (state is ClientDetailsFailure) {
            SnackBarHelper.showError(context, message: state.failure.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is ClientDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ClientDetailsFailure) {
            return Center(
              child: Text(
                'حدث خطأ: ${state.failure.errorMessage}',
                style: AppTextStyles.body16Bold.copyWith(color: AppColors.red),
              ),
            );
          }

          if (state is ClientDetailsSuccess) {
            final client = state.client;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Distance indicator banner
                  DistanceBanner(),
                  // Customer basic information cards
                  InfoCard(
                    title: 'اسم العميل',
                    value: client.nameAr,
                    icon: Icons.person,
                  ),
                  InfoCard(
                    title: 'رقم التليفون',
                    value: client.phone,
                    icon: Icons.phone,
                  ),
                  InfoCard(
                    title: 'تاريخ آخر زيارة',
                    value: client.lastVisit,
                    icon: Icons.calendar_today,
                  ),
                  InfoCard(
                    title: 'اشترى آخر مرة بكام',
                    value: '${client.totalSpent} جنيه',
                    icon: Icons.attach_money,
                  ),
                  // Customer location details
                  LocationCard(latlng: client.address ?? GeoPoint(0, 0)),
                  // Business type information
                  InfoCard(
                    title: 'نوع النشاط التجاري',
                    value: client.activity,
                    icon: Icons.store,
                  ),

                  // Customer rating
                  InfoCard(
                    isRating: true,
                    title: 'التصنيف',
                    value: client.classification,
                    icon: Icons.sell_outlined,
                  ),
                  // Client classification
                  InfoCard(
                    title: 'نوع العميل',
                    value: client.activityType,
                    icon: Icons.group,
                  ),
                  // Current visit reason
                  // Ordered products list
                  ProductsSection(task: task),
                  // Action buttons for order management
                  BlocProvider<OrderCubit>(
                    create: (context) => OrderCubit(
                      repository: OrderRepositoryImpl(
                        firestore: FirebaseFirestore.instance,
                      ),
                    ),
                    child: ActionButtonsSection(task: task, tasks: tasks),
                  ),
                ],
              ),
            );
          }

          // Default case: return empty container
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// Banner widget displaying the distance to the customer's location
/// Shows distance in meters with location pin icon
class DistanceBanner extends StatelessWidget {
  const DistanceBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.green),
      ),
      child: Center(
        child: Text(
          '📍 المسافة: 0 متر',
          style: AppTextStyles.body16Bold.copyWith(color: AppColors.green),
        ),
      ),
    );
  }
}

/// Reusable card widget for displaying customer information
/// Used for basic customer details like name, phone, last visit, etc.
class InfoCard extends StatelessWidget {
  final String title; // Label for the information field
  final String value; // The actual data value to display
  final IconData icon; // Icon representing the information type
  final bool isRating;
  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.isRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.cardBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.bluePrimaryDark, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textMutedGray,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (isRating)
                Container(
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(right: 6, left: 6),
                  decoration: BoxDecoration(
                    color: value == 'A'
                        ? AppColors.green
                        : value == 'B'
                        ? AppColors.sidebarPrimary
                        : AppColors.chartAmber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value,
                    style: AppTextStyles.body16Bold.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),

              Text(
                value,
                style: AppTextStyles.body16SemiBold.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Card widget displaying customer's location details
/// Shows address and GPS coordinates
class LocationCard extends StatelessWidget {
  final GeoPoint latlng;
  const LocationCard({super.key, required this.latlng});

  @override
  Widget build(BuildContext context) {
    final lat = latlng.latitude;
    final lng = latlng.longitude;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: AppColors.bluePrimaryDark),
                const SizedBox(width: 6),
                Text(
                  'الموقع',
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textMutedGray,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Text(
            //   '15 شارع طلعت حرب، وسط البلد، القاهرة',
            //   style: AppTextStyles.body14Regular.copyWith(
            //     color: AppColors.textPrimaryDark,
            //   ),
            // ),
            Text(
              '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.grayText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section with action buttons for order management
/// Provides buttons for: return, delivery confirmation, cancellation, and new order
class ActionButtonsSection extends StatefulWidget {
  const ActionButtonsSection({
    super.key,
    required this.task,
    required this.tasks,
  });

  final TaskModel task;
  final List<TaskModel> tasks;

  @override
  State<ActionButtonsSection> createState() => _ActionButtonsSectionState();
}

class _ActionButtonsSectionState extends State<ActionButtonsSection> {
  final Map<String, bool> _buttonDisabled = {};

  @override
  Widget build(BuildContext context) {
    final agentId = context.read<AuthCubit>().state is AuthCubitAuthenticated
        ? (context.read<AuthCubit>().state as AuthCubitAuthenticated).user.uid
        : 'UNKNOWN_AGENT';

    return BlocConsumer<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (state is OrderSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pop();
            SnackBarHelper.showSuccess(context, message: state.message);
          });
        }

        if (state is OrderFailure) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context, rootNavigator: true).pop();
            SnackBarHelper.showError(context, message: state.error);
          });
        }
      },
      builder: (context, state) {
        final isLoading = state is OrderLoading;

        return Column(
          children: [
            Row(
              children: [
                // زر الاسترجاع
                Expanded(
                  child: _actionBtn(
                    isLoading: isLoading,
                    text: 'استرجاع',
                    color: AppColors.orange,
                    icon: Icons.undo,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => OrderDialog(
                          cubit: context.read<OrderCubit>(),
                          repository: ProductsRepositoryImpl(
                            firestore: FirebaseFirestore.instance,
                          ),
                          orderType: 'طلب استرجاع منتج',
                          onConfirm: (products) {
                            final newTask = TaskModel(
                              id: FirebaseFirestore.instance
                                  .collection('new_order')
                                  .doc()
                                  .id,
                              area: widget.task.area,
                              client: widget.task.client,
                              products: products
                                  .map((p) => p.toTaskProduct())
                                  .toList(),
                              taskType: TaskTypeModel(
                                key: 'return',
                                label: 'طلب استرجاع',
                              ),
                              totalPrice: products
                                  .fold(
                                    0.0,
                                    (sum, p) =>
                                        sum +
                                        (double.tryParse(
                                                  p.priceController.text,
                                                ) ??
                                                0) *
                                            (int.tryParse(
                                                  p.quantityController.text,
                                                ) ??
                                                1),
                                  )
                                  .toInt(),
                              createdAt: DateTime.now(),
                              representativeId: agentId,
                              status: TaskStatus.assigned,
                            );

                            context.read<OrderCubit>().addNewOrder(newTask);

                            // ارجع للـ home بعد الاسترجاع
                            context.goNamed(AppRoutes.home);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // زر الاستلام / التسليم
                Expanded(
                  child: _actionBtn(
                    isLoading:
                        isLoading || (_buttonDisabled[widget.task.id] ?? false),
                    text: widget.task.taskType.label == 'تحصيل'
                        ? 'تم تسليم الطلب'
                        : 'تم استلام الطلب',
                    color: AppColors.green,
                    icon: Icons.check_circle,
                    onPressed: () {
                      final newStatus = widget.task.taskType.label == 'تحصيل'
                          ? TaskStatus.delivered
                          : TaskStatus.received;

                      final updatedTask = widget.task.copyWith(
                        status: newStatus,
                        updatedAt: DateTime.now(),
                      );

                      // قفل الزر بعد الضغط
                      setState(() {
                        _buttonDisabled[widget.task.id] = true;
                      });

                      context.read<OrderCubit>().sendAction(
                        updatedTask,
                        newStatus,
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // زر إلغاء الطلب
                Expanded(
                  child: _actionBtn(
                    isLoading: isLoading,
                    text: 'إلغاء الطلب',
                    color: AppColors.red,
                    icon: Icons.cancel,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AppDialogForConfirm(
                          title: 'إلغاء الطلب',
                          message: 'هل أنت متأكد من إلغاء هذا الطلب؟',
                          onConfirm: () {
                            Navigator.pop(context);

                            final updatedTask = widget.task.copyWith(
                              status: TaskStatus.cancelled,
                              updatedAt: DateTime.now(),
                            );
                            // قفل الزر بعد الضغط
                            setState(() {
                              _buttonDisabled[widget.task.id] = true;
                            });

                            context.read<OrderCubit>().sendAction(
                              updatedTask,
                              TaskStatus.cancelled,
                            );

                            // ارجع للـ home بعد الإلغاء
                            context.goNamed(AppRoutes.home);
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // زر طلب جديد
                Expanded(
                  child: _actionBtn(
                    isLoading: isLoading,
                    text: 'طلب جديد',
                    color: AppColors.blue,
                    icon: Icons.add,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => OrderDialog(
                          cubit: context.read<OrderCubit>(),
                          repository: ProductsRepositoryImpl(
                            firestore: FirebaseFirestore.instance,
                          ),
                          orderType: 'طلب جديد',
                          onConfirm: (products) {
                            final newTask = TaskModel(
                              id: FirebaseFirestore.instance
                                  .collection('new_order')
                                  .doc()
                                  .id,
                              area: widget.task.area,
                              client: widget.task.client,
                              products: products
                                  .map((p) => p.toTaskProduct())
                                  .toList(),
                              taskType: TaskTypeModel(
                                key: 'new',
                                label: 'طلب جديد',
                              ),
                              totalPrice: products
                                  .fold(
                                    0.0,
                                    (sum, p) =>
                                        sum +
                                        (double.tryParse(
                                                  p.priceController.text,
                                                ) ??
                                                0) *
                                            (int.tryParse(
                                                  p.quantityController.text,
                                                ) ??
                                                1),
                                  )
                                  .toInt(),
                              createdAt: DateTime.now(),
                              representativeId: agentId,
                              status: TaskStatus.assigned,
                            );

                            context.read<OrderCubit>().addNewOrder(newTask);

                            // ارجع للـ home بعد الطلب الجديد
                            context.goNamed(AppRoutes.home);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _actionBtn({
    required String text,
    required Color color,
    required IconData icon,
    required bool isLoading,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: isLoading ? null : onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.body14SemiBold),
        ],
      ),
    );
  }
}
