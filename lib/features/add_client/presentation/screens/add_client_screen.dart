import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../manager/add_client_cubit.dart';
import '../manager/add_client_state.dart';
import '../../../../core/shared_models/client_model.dart';

import '../widgets/custom_client_text_field.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/location_section.dart';
import '../widgets/static_data_section.dart';

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

  final List<String> _classifications = ['A', 'B', 'C'];
  final List<String> _clientTypes = ['عميل جديد', 'عميل دائم', 'عميل محتمل'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // استخدام لون الخلفية من ملفك
      appBar: AppBar(
        title: const Text('إضافة عميل جديد',
            style: TextStyle(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.bluePrimaryDark, // الربط بالأزرق الموحد
        elevation: 0,
      ),
      body: BlocListener<AddClientCubit, AddClientState>(
        listener: (context, state) {
          if (state is AddClientLoading) {
            _showLoadingDialog();
          } else if (state is AddClientSuccess) {
            Navigator.pop(context);
            _showSuccessDialog(state.message);
            _clearForm();
          } else if (state is AddClientFailure) {
            Navigator.pop(context);
            _showSnackBar(state.errMessage, isError: true);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomClientTextField(
                  label: "اسم العميل *",
                  hint: "أدخل اسم العميل",
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? "الاسم مطلوب" : null,
                ),

                CustomClientTextField(
                  label: "رقم الهاتف *",
                  hint: "ادخل رقم الهاتف",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) {
                    if (val == null || val.isEmpty) return "رقم الهاتف مطلوب";
                    if (val.length != 11) return "يجب أن يتكون الرقم من 11 خانة";
                    if (!RegExp(r'^[0-9]+$').hasMatch(val)) return "يجب إدخال أرقام فقط";
                    return null;
                  },
                ),

                LocationPickerSection(
                  onLocationPressed: _determinePosition,
                  latController: _latController,
                  lngController: _lngController,
                ),

                CustomClientTextField(
                  label: "نوع النشاط التجاري *",
                  hint: "مثال : كافية - صيدلية - سوبر ماركت",
                  controller: _activityController,
                  validator: (val) => val!.isEmpty ? "نوع النشاط مطلوب" : null,
                ),

                CustomDropdownField(
                  label: "تصنيف العميل *",
                  hint: "اختر التصنيف",
                  items: _classifications,
                  value: _selectedClassification,
                  onChanged: (val) => setState(() => _selectedClassification = val),
                ),

                CustomDropdownField(
                  label: "نوع العميل *",
                  hint: "اختر النوع",
                  items: _clientTypes,
                  value: _selectedType,
                  onChanged: (val) => setState(() => _selectedType = val),
                ),

                const SizedBox(height: 25),
                const StaticDataSection(),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimaryDark, // الربط بالأزرق الموحد
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                  ),
                  child: const Text("إضافة العميل للنظام",
                      style: TextStyle(color: AppColors.textOnPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Logic Methods ---

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      if (_latController.text == "0" || _lngController.text == "0") {
        _showSnackBar("الرجاء التقاط الموقع الجغرافي أولاً", isError: true);
        return;
      }

      final client = ClientModel(
        name: _nameController.text.trim(),
        nameAr: _nameController.text.trim(),
        address: GeoPoint(
          double.tryParse(_latController.text) ?? 0.0,
          double.tryParse(_lngController.text) ?? 0.0,
        ),
        phone: _phoneController.text.trim(),
        activity: _activityController.text.trim(),
        classification: _selectedClassification ?? 'غير محدد',
        type: _selectedType ?? 'غير محدد', 
        id: '', // سيتم تعيينه في المستودع عند الإضافة
      );

      context.read<AddClientCubit>().addClient(client);
    }
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
        if (permission == LocationPermission.denied) return;
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
      _showSnackBar("خطأ في جلب الموقع", isError: true);
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

  // --- UI Helpers (Alerts & SnackBars) ---

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.backgroundWhite, // استخدام اللون الأبيض من ملفك
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 60, width: 60,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.bluePrimaryDark),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "جاري المعالجة...",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bluePrimaryDark,
                ),
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
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.green, size: 50),
              ),
              const SizedBox(height: 20),
              const Text(
                "تمت العملية",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMutedGray),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bluePrimaryDark,
                  foregroundColor: AppColors.textOnPrimary,
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

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.redDestructive : AppColors.bluePrimaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}