import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _latController = TextEditingController(text: "0");
  final TextEditingController _lngController = TextEditingController(text: "0");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();

  String? _selectedClassification;
  String? _selectedType;

  final List<String> _classifications = ['تصنيف A', 'تصنيف B', 'تصنيف C'];
  final List<String> _clientTypes = ['عميل جديد', 'عميل دائم', 'عميل محتمل'];

  Future<void> _saveClient() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar("الرجاء التحقق من البيانات المدخلة", isError: true);
      return;
    }

    if (_latController.text == "0" || _lngController.text == "0") {
      _showSnackBar("الرجاء التقاط الموقع الجغرافي أولاً", isError: true);
      return;
    }

    _showLoadingDialog();

    try {
      await FirebaseFirestore.instance.collection('customers').add({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'lat': _latController.text,
        'lng': _lngController.text,
        'activity': _activityController.text.trim(),
        'classification': _selectedClassification ?? 'غير محدد',
        'type': _selectedType ?? 'غير محدد',
        'timestamp': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
      _showSuccessDialog("تم حفظ العميل بنجاح في النظام");
      _clearForm();

    } on FirebaseException catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar("خطأ في الاتصال بالسيرفر: ${e.message}", isError: true);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar("حدث خطأ غير متوقع", isError: true);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _phoneController.clear();
    _activityController.clear();
    setState(() {
      _latController.text = "0";
      _lngController.text = "0";
      _selectedClassification = null;
      _selectedType = null;
    });
  }

  // --- تحديث تصميم الـ Alerts ليصبح أجمل ---

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 60, width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "جاري المعالجة...",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 50),
              ),
              const SizedBox(height: 20),
              const Text("تمت العملية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("استمرار", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnackBar("تأكد من تشغيل الـ GPS", isError: true);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnackBar("تم رفض إذن الموقع", isError: true);
          return;
        }
      }

      _showLoadingDialog();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
      });

      if (mounted) Navigator.pop(context);
      _showSnackBar("تم تحديد موقعك بنجاح");
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSnackBar("خطأ في جلب الموقع الجغرافي", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF0D47A1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة عميل جديد', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("اسم العميل *"),
              _buildTextField(
                "أدخل اسم العميل",
                controller: _nameController,
                validator: (val) => val!.isEmpty ? "الاسم مطلوب" : null,
              ),

              _buildLabel("رقم الهاتف *"),
              _buildTextField(
                "ادخل رقم الهاتف",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                // التأكيد على أن الرقم 11 رقماً بالضبط
                validator: (val) {
                  if (val == null || val.isEmpty) return "رقم الهاتف مطلوب";
                  if (val.length != 11) return "يجب أن يتكون الرقم من 11 خانة";
                  if (!RegExp(r'^[0-9]+$').hasMatch(val)) return "يجب إدخال أرقام فقط";
                  return null;
                },
              ),

              _buildLabel("الموقع *"),
              ElevatedButton.icon(
                onPressed: _determinePosition,
                icon: const Icon(Icons.my_location),
                label: const Text("تحديد موقعي الحالي", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFC107),
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 2,
                ),
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: _buildSmallTextField("خط العرض", _latController)),
                  const SizedBox(width: 15),
                  Expanded(child: _buildSmallTextField("خط الطول", _lngController)),
                ],
              ),

              _buildLabel("نوع النشاط التجاري *"),
              _buildTextField("مثال : كافية - صيدلية - سوبر ماركت", controller: _activityController, validator: (val) => val!.isEmpty ? "نوع النشاط مطلوب" : null),

              _buildLabel("تصنيف العميل *"),
              _buildDropdown("اختر التصنيف", _classifications, _selectedClassification, (val) => setState(() => _selectedClassification = val)),

              _buildLabel("نوع العميل *"),
              _buildDropdown("اختر النوع", _clientTypes, _selectedType, (val) => setState(() => _selectedType = val)),

              const SizedBox(height: 25),
              _buildStaticDataSection(),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveClient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                ),
                child: const Text("إضافة العميل للنظام", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(padding: const EdgeInsets.only(bottom: 8.0, top: 16.0), child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0D47A1))));

  Widget _buildTextField(String hint, {required TextEditingController controller, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2)),
        errorStyle: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSmallTextField(String label, TextEditingController controller) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("  $label", style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      TextFormField(
        controller: controller,
        readOnly: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    ]);
  }

  Widget _buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      validator: (val) => val == null ? "يرجى الاختيار" : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
      hint: Text(hint, style: const TextStyle(fontSize: 14)),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildStaticDataSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(children: [
        Row(children: const [Icon(Icons.analytics_outlined, size: 20, color: Color(0xFF0D47A1)), SizedBox(width: 10), Text("بيانات ثابتة للنظام", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0D47A1)))]),
        const Divider(height: 25),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [Text("إجمالي عدد الزيارات:"), Text("0", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))]),
      ]),
    );
  }
}