


import 'package:flutter/material.dart';
import 'package:masar_app/core/constants/app_colors.dart';
import 'package:masar_app/core/constants/app_styles.dart';

/// Section displaying list of ordered products
/// Shows product items with quantities and prices, plus total amount
class ProductsSection extends StatelessWidget {

  const ProductsSection({super.key, required this.status});

  final String status ; // Example status

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
     Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: status== 'تحصيل' ? AppColors.lightGreenBackground : AppColors.lightOrangeBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: status=='تحصيل' ? AppColors.green : AppColors.textOrange),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: status=='تحصيل' ? AppColors.green : AppColors.textOrange, size: 20),
              const SizedBox(width: 6),
              Text(
                'سبب الزيارة',
                style: AppTextStyles.body16Bold.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            status=='تحصيل' ? 'تحصيل' : 'استرجاع',
            style: AppTextStyles.heading24Bold.copyWith(color: status=='تحصيل' ? AppColors.green : AppColors.textOrange),
          ),
        ],
      ),
    ),
 
        Card(
          margin: const EdgeInsets.only(bottom: 12),
          color: AppColors.bluePrimaryLight,
          shadowColor:status=="تحصيل" ? AppColors.blueSecondaryLightForBorder : AppColors.textOrange,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.shopping_cart_outlined, color:status=="تحصيل" ? AppColors.backgroundLight : AppColors.textOrange),
                    const SizedBox(width: 12),
                    Text(
                      status=="تحصيل" ? 'المنتجات المطلوبة' :
                      'المنتجات  المطلوب استرجاعها',
                      style: AppTextStyles.body16Bold.copyWith(
                        color: status=="تحصيل" ? AppColors.bluePrimaryDark : AppColors.textOrange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                 ProductItem(
                  name: 'كوكاكولا 2 لتر',
                  qty: '10 × 15',
                  price: '150',
                  status: status,
                ),
                 ProductItem(
                  name: 'بيبسي 1.5 لتر',
                  qty: '8 × 12',
                  price: '96',
                  status: status,
                ),
                Divider(color: status=="تحصيل" ? AppColors.blueSecondaryLightForBorder : AppColors.textOrange),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الإجمالي',
                      style: AppTextStyles.body16Bold.copyWith(
                        color: status=="تحصيل" ? AppColors.bluePrimaryDark : AppColors.textOrange,
                      ),
                    ),
                    Text(
                      '442 جنيه',
                      style: AppTextStyles.body16Bold.copyWith(
                        color: status=="تحصيل" ? AppColors.bluePrimaryDark : AppColors.textOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Individual product item widget
/// Displays product name, quantity, and price in a row layout
class ProductItem extends StatelessWidget {
  final String name; // Product name
  final String qty; // Quantity information
  final String price; // Price in EGP
  final String status; // Status of the product item

  const ProductItem({
    super.key,
    required this.name,
    required this.qty,
    required this.price,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: status=="تحصيل" ? AppColors.blueSecondaryLightForBorder : AppColors.textOrange),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                Text(
                  'الكمية: $qty جنيه',
                  style: AppTextStyles.body14Regular.copyWith(
                    color: AppColors.grayText,
                  ),
                ),
              ],
            ),
            Text(
              '$price جنيه',
              style: AppTextStyles.body14SemiBold.copyWith(
                color: status=="تحصيل" ? AppColors.bluePrimaryDark : AppColors.textOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
