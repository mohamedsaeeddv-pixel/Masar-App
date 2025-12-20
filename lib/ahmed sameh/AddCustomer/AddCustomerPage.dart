// import 'package:flutter/material.dart';
//
// class AddCustomerPage extends StatefulWidget {
//   @override
//   _AddCustomerPageState createState() => _AddCustomerPageState();
// }
//
// class _AddCustomerPageState extends State<AddCustomerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl, // لضبط الاتجاه من اليمين لليسان
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('إضافة عميل جديد', style: TextStyle(fontWeight: FontWeight.bold)),
//           centerTitle: true,
//           backgroundColor: Color(0xFF0D47A1), // اللون الأزرق العلوي
//         ),
//         body: SingleChildScrollView(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildLabel("اسم العميل *"),
//               _buildTextField("أدخل اسم العميل"),
//
//               _buildLabel("رقم الهاتف *"),
//               _buildTextField("أدخل رقم الهاتف", keyboardType: TextInputType.phone),
//
//               _buildLabel("الموقع *"),
//               ElevatedButton.icon(
//                 onPressed: () {},
//                 icon: Icon(Icons.location_on),
//                 label: Text("تحديد موقعي الحالي"),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFFFFC107), // اللون الأصفر
//                   foregroundColor: Colors.black,
//                   minimumSize: Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 ),
//               ),
//               SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(child: _buildSmallTextField("خط العرض", "30.0444")),
//                   SizedBox(width: 10),
//                   Expanded(child: _buildSmallTextField("خط الطول", "31.2357")),
//                 ],
//               ),
//
//               _buildLabel("نوع النشاط التجاري *"),
//               _buildTextField("مثال: سوبر ماركت، صيدلية، كافيه"),
//
//               _buildLabel("تصنيف العميل *"),
//               _buildDropdown("اختر التصنيف"),
//
//               _buildLabel("نوع العميل *"),
//               _buildDropdown("اختر النوع"),
//
//               SizedBox(height: 20),
//               _buildStaticDataSection(),
//
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {},
//                 child: Text("إضافة العميل", style: TextStyle(fontSize: 18, color: Colors.white)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xFF0D47A1),
//                   minimumSize: Size(double.infinity, 55),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Color(0xFF0D47A1),
//           items: [
//             BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "البروفايل"),
//             BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in_outlined), label: "المهام اليومية"),
//             BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "إضافة عميل"),
//             BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "الإعدادات"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // Widget مساعد لعناوين الحقول
//   Widget _buildLabel(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0, top: 12.0),
//       child: Text(text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//     );
//   }
//
//   // Widget للحقول النصية
//   Widget _buildTextField(String hint, {TextInputType keyboardType = TextInputType.text}) {
//     return TextFormField(
//       keyboardType: keyboardType,
//       decoration: InputDecoration(
//         hintText: hint,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
//         filled: true,
//         fillColor: Colors.grey[50],
//       ),
//     );
//   }
//
//   // Widget لحقول خطوط الطول والعرض
//   Widget _buildSmallTextField(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
//         TextFormField(
//           initialValue: value,
//           textAlign: TextAlign.center,
//           decoration: InputDecoration(border: OutlineInputBorder()),
//         ),
//       ],
//     );
//   }
//
//   // Widget للقوائم المنسدلة
//   Widget _buildDropdown(String hint) {
//     return DropdownButtonFormField(
//       decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
//       hint: Text(hint),
//       items: [], // أضف العناصر هنا
//       onChanged: (val) {},
//     );
//   }
//
//   // Widget لقسم البيانات الثابتة في الأسفل
//   Widget _buildStaticDataSection() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey[100],
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("بيانات ثابتة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//           Divider(),
//           _staticRow("تاريخ آخر زيارة:", "2025/12/15"),
//           _staticRow("اشترى آخر مرة بكام:", "0 جنيه"),
//           _staticRow("عدد الزيارات:", "0"),
//         ],
//       ),
//     );
//   }
//
//   Widget _staticRow(String title, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title, style: TextStyle(color: Colors.grey[700])),
//           Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }