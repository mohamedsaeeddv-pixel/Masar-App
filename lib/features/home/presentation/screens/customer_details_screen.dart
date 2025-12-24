// Customer Details Screen
// Displays comprehensive information about a specific customer
// including personal info, location, purchase history, and order actions

import 'package:flutter/material.dart';
import 'package:masar_app/core/constants/app_colors.dart';
import 'package:masar_app/core/constants/app_styles.dart';
import 'package:masar_app/core/widgets/custom_app_bar.dart';
import 'package:masar_app/core/widgets/custom_dialog.dart';
import 'package:masar_app/features/home/presentation/widgets/product_items_section.dart';

/// Main screen widget for displaying detailed customer information
/// Shows customer data, location, purchase stats, and available actions
class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom app bar with title and edit action
      appBar: CustomAppBar(
        title: "تفاصيل العميل",
        leading: IconButton(icon: Icon(Icons.edit_outlined), onPressed: () {}),
      ),
      // Scrollable body containing all customer information sections
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            // Distance indicator banner
            DistanceBanner(),
            // Customer basic information cards
            InfoCard(
              title: 'اسم العميل',
              value: 'أحمد محمد',
              icon: Icons.person,
            ),
            InfoCard(
              title: 'رقم التليفون',
              value: '01234567890',
              icon: Icons.phone,
            ),
            InfoCard(
              title: 'تاريخ آخر زيارة',
              value: '2024-01-10',
              icon: Icons.calendar_today,
            ),
            InfoCard(
              title: 'اشترى آخر مرة بكام',
              value: '180 جنيه',
              icon: Icons.attach_money,
            ),
            // Customer location details
            LocationCard(),
            // Business type information
            InfoCard(
              title: 'نوع النشاط التجاري',
              value: 'مطعم',
              icon: Icons.store,
            ),
            // Purchase statistics
            InfoCard(
              title: 'إحصائيات الشراء',
              value: '165 جنيه\nإجمالي 12 عملية شراء',
              icon: Icons.trending_up,
            ),
            // Customer rating
            InfoCard(
              isRating: true,
              title: 'التصنيف',
              value: 'ممتاز-A',
              icon: Icons.sell_outlined,
            ),
            // Client classification
            InfoCard(
              title: 'نوع العميل',
              value: 'جملة الجملة',
              icon: Icons.group,
            ),
            // Current visit reason
            // Ordered products list
            ProductsSection(status: "استرجاع"),
            // Action buttons for order management
            ActionButtonsSection(),
          ],
        ),
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
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'A',
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
  const LocationCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(
              '15 شارع طلعت حرب، وسط البلد، القاهرة',
              style: AppTextStyles.body14Regular.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            Text(
              '30.044400 , 31.235700',
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
class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                text: 'استرجاع',
                color: AppColors.orange,
                icon: Icons.undo,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionBtn(
                text: 'تم تسليم الطلب',
                color: AppColors.green,
                icon: Icons.check_circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _actionBtn(
                text: 'إلغاء الطلب',
                color: AppColors.red,
                icon: Icons.cancel,
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (_) => AppDialog(
                      title: 'Cancel Order',
                      message: 'Are you sure you want to cancel this order?',
                      onConfirm: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                }
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionBtn(
                text: 'طلب جديد',
                color: AppColors.blue,
                icon: Icons.add,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AppDialog(
                      title: 'Delete Item',
                      message: 'Are you sure you want to delete this item?',
                      onConfirm: () {
                        Navigator.pop(context);
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
  }

  /// Helper method to build action buttons with consistent styling
  /// @param text Button label text
  /// @param color Button background color
  Widget _actionBtn({
    required String text,
    required Color color,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.body14SemiBold),
        ],
      ),
    );
  }
}
