import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masar_app/features/home/data/models/product_model.dart';
import 'package:masar_app/features/home/data/repos/product_repo.dart';
import 'package:masar_app/features/home/data/repos/product_repo_imple.dart';
import 'package:masar_app/features/home/presentation/manager/orders/cubit/order_cubit.dart';
import 'package:masar_app/features/home/presentation/manager/product/cubit/products_cubit.dart';
import 'package:masar_app/features/home/presentation/manager/product/cubit/products_state.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_styles.dart';

typedef OrderDialogCallback = void Function(List<_ProductData> products);

class OrderDialog extends StatefulWidget {
  const OrderDialog({
    super.key,
    required this.orderType,
    required this.onConfirm,
    required this.cubit,
    required this.repository, // تمرير repository مباشرة
  });

  final String orderType;
  final OrderDialogCallback onConfirm;
  final ProductsRepository repository;
    final OrderCubit cubit; // اضفت هنا

  
  @override
  State<StatefulWidget> createState() {
    return _OrderDialogState();
  } // <-- repository هنا
}

class _OrderDialogState extends State<OrderDialog> {
  final List<_ProductData> _products = [_ProductData()];

  void _addProduct() {
    setState(() {
      _products.add(_ProductData());
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  void _confirmAction() {
    widget.onConfirm(_products);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(repository: widget.repository)..getProducts(),
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.mutedBackground,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Header(orderType: widget.orderType),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                      ...List.generate(
                        _products.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: ProductCard(
                            product: _products[index],
                            index: index + 1,
                            showDelete: index != 0,
                            onDelete: () => _removeProduct(index),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _AddProductButton(
                          onPressed: _addProduct,
                          orderType: widget.orderType,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _ConfirmButton(
                  onPressed: _confirmAction,
                  orderType: widget.orderType,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ---------------- Header ---------------- */
class _Header extends StatelessWidget {
  const _Header({required this.orderType});
  final String orderType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: orderType == 'طلب جديد'
            ? AppColors.bluePrimaryDark
            : AppColors.orange,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Spacer(),
          Text(
            orderType == 'طلب جديد' ? 'طلب جديد' : 'استرجاع منتجات',
            style: AppTextStyles.subtitle18Bold.copyWith(
              color: AppColors.textOnPrimary,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

/* ---------------- Product Data ---------------- */
class _ProductData {
  ProductModel? selectedProduct;
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
}

/* ---------------- Product Card ---------------- */
class ProductCard extends StatelessWidget {
  final int index;
  final _ProductData product;
  final bool showDelete;
  final VoidCallback? onDelete;

  const ProductCard({
    super.key,
    required this.index,
    required this.product,
    this.showDelete = false,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'منتج $index',
                style: AppTextStyles.body14Bold.copyWith(
                  color: AppColors.textMutedGray,
                ),
              ),
              const Spacer(),
              if (showDelete)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  onPressed: onDelete,
                ),
            ],
          ),
          const SizedBox(height: 12),

          /// 🔹 Dropdown for Product Selection
          BlocBuilder<ProductsCubit, ProductsState>(
            builder: (context, state) {
              if (state is ProductsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductsFailure) {
                return Text('حدث خطأ: ${state.message}');
              } else if (state is ProductsSuccess) {
                return _LabeledDropdown<ProductModel>(
                  label: 'اسم المنتج',
                  hint: 'اختر المنتج',
                  value: product.selectedProduct,
                  items: state.products.map((p) {
                    return DropdownMenuItem<ProductModel>(
                      value: p,
                      child: Text(p.nameAr),
                    );
                  }).toList(),
                  onChanged: (value) {
                    product.selectedProduct = value;
                    product.priceController.text = value!.hasDiscount
                        ? value.priceAfterDiscount.toString()
                        : value.price.toString();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 12),

          // السعر
          _LabeledField(
            controller: product.priceController,
            label: 'السعر (جنيه)',
            hint: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _LabeledField(
            controller: product.quantityController,
            label: 'الكمية',
            hint: '0',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          _LabeledField(
            controller: product.notesController,
            label: 'ملاحظات',
            hint: 'اختياري',
          ),
        ],
      ),
    );
  }
}

/* ---------------- Input Field ---------------- */
class _LabeledField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final TextEditingController controller;

  const _LabeledField({
    required this.label,
    required this.hint,
    this.keyboardType,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body14Regular.copyWith(
            color: AppColors.textMutedGray,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
          ),
        ),
      ],
    );
  }
}

/* ---------------- Add Product Button ---------------- */
class _AddProductButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String orderType;

  const _AddProductButton({required this.onPressed, required this.orderType});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text('إضافة منتج آخر'),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        foregroundColor: orderType == 'طلب جديد' ? AppColors.bluePrimaryDark : AppColors.orange,
        side: BorderSide(
          color: orderType == 'طلب جديد' ? AppColors.bluePrimaryDark : AppColors.orange,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

/* ---------------- Confirm Button ---------------- */
class _ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String orderType;

  const _ConfirmButton({required this.onPressed, required this.orderType});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(orderType == 'طلب جديد' ? Icons.shopping_cart : Icons.check_box_outlined),
      label: Text(orderType == 'طلب جديد' ? 'تأكيد الطلب' : 'تأكيد الاسترجاع'),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 54),
        backgroundColor: orderType == 'طلب جديد' ? AppColors.bluePrimaryDark : AppColors.orange,
        foregroundColor: AppColors.textOnPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

/// ---------------- Labeled Dropdown ---------------- */
class _LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _LabeledDropdown({
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.body14Regular.copyWith(color: AppColors.textMutedGray),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: value,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.inputBackground,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.inputBorder),
            ),
          ),
          items: items,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
