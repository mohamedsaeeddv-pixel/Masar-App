import 'package:flutter/material.dart';
import 'app_colors.dart'; // تأكد من استيراد ملف الألوان اللي عدلناه

class AppTextStyles {
  AppTextStyles._();

  // ==========================================
  // القائمة القديمة (لا يتم مسحها لضمان ثبات الكود الحالي)
  // ==========================================
  static const TextStyle body14Regular = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle body14SemiBold = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
  static const TextStyle body14Bold = TextStyle(fontSize: 14, fontWeight: FontWeight.w700);

  static const TextStyle body16Regular = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle body16SemiBold = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static const TextStyle body16Bold = TextStyle(fontSize: 16, fontWeight: FontWeight.w700);

  static const TextStyle subtitle18Regular = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static const TextStyle subtitle18SemiBold = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const TextStyle subtitle18Bold = TextStyle(fontSize: 18, fontWeight: FontWeight.w700);

  static const TextStyle title20Regular = TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  static const TextStyle title20SemiBold = TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static const TextStyle title20Bold = TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white);

  static const TextStyle headline30Regular = TextStyle(fontSize: 30, fontWeight: FontWeight.w400);
  static const TextStyle headline30SemiBold = TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const TextStyle headline30Bold = TextStyle(fontSize: 30, fontWeight: FontWeight.w700);

  static const TextStyle heading24Regular = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static const TextStyle heading24SemiBold = TextStyle(fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle heading24Bold = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);

  // =================================================================
  // التعديلات الجديدة (دعم الـ Dark Mode وتغيير حجم الخط مستقبلاً)
  // استخدام هذه الدوال في الصفحات الجديدة يضمن توافقها مع الـ Theme
  // =================================================================

  // دالة مساعدة لتوحيد منطق إنشاء الستايل الديناميكي
  static TextStyle _getStyle(BuildContext context, double size, FontWeight weight, {Color? color}) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      // إذا لم يتم تحديد لون، يسحب اللون الأساسي (أسود في الفاتح، أبيض في الداكن)
      color: color ?? AppColors.primaryText(context),
    );
  }

  // أمثلة للدوال اللي هتستخدمها وأنت بتعدي على الصفحات:
  static TextStyle getBody14Regular(BuildContext context) => _getStyle(context, 14, FontWeight.w400);
  static TextStyle getBody14Bold(BuildContext context) => _getStyle(context, 14, FontWeight.w700);

  static TextStyle getBody16SemiBold(BuildContext context) => _getStyle(context, 16, FontWeight.w600);
  static TextStyle getBody16Bold(BuildContext context) => _getStyle(context, 16, FontWeight.w700);

  static TextStyle getTitle20Bold(BuildContext context) => _getStyle(context, 20, FontWeight.w700);

  // ستايل خاص بالنصوص الباهتة (مثل التاريخ أو الملاحظات الجانبية)
  static TextStyle getBody14Muted(BuildContext context) => _getStyle(
    context, 14, FontWeight.w400,
    color: AppColors.secondaryText(context),
  );
}