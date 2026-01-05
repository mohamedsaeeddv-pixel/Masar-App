import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/client_constants.dart';
import '../manager/add_client_cubit.dart';
import '../manager/add_client_state.dart';
import '../../data/models/client_model.dart';

// الـ Widgets المستوردة
import '../widgets/custom_alerts.dart';
import '../widgets/custom_client_text_field.dart';
import '../widgets/custom_dropdown_field.dart';
import '../widgets/location_section.dart';
import '../widgets/location_service.dart';
import '../widgets/static_data_section.dart';
import '../widgets/area_dropdown_field.dart';
import '../widgets/client_names_section.dart';
import '../widgets/financial_info_section.dart';

class AddClientScreen extends StatefulWidget {
  const AddClientScreen({super.key});

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _latController = TextEditingController(text: "0");
  final TextEditingController _lngController = TextEditingController(text: "0");
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _spentController = TextEditingController(text: "0");
  final TextEditingController _visitsController = TextEditingController(text: "1");

  String? _selectedClassification;
  String? _selectedType;
  String? _selectedArea;
  String? _selectedActivityType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('إضافة عميل جديد',
            style: TextStyle(color: AppColors.textOnPrimary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.bluePrimaryDark,
        elevation: 0,
      ),
      body: BlocListener<AddClientCubit, AddClientState>(
        listener: (context, state) {
          if (state is AddClientLoading) {
            CustomAlerts.showLoadingDialog(context);
          } else if (state is AddClientSuccess) {
            Navigator.pop(context);
            CustomAlerts.showSuccessDialog(context, state.message);
            _clearForm();
          } else if (state is AddClientFailure) {
            Navigator.pop(context);
            CustomAlerts.showSnackBar(context, state.errMessage, isError: true);
          }
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClientNamesSection(
                  nameArController: _nameArController,
                  nameEnController: _nameEnController,
                ),
                CustomClientTextField(
                  label: "رقم الهاتف *",
                  hint: "ادخل رقم الهاتف",
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => (val == null || val.length != 11) ? "رقم الهاتف غير صحيح" : null,
                ),
                LocationPickerSection(
                  onLocationPressed: _determinePosition,
                  latController: _latController,
                  lngController: _lngController,
                ),
                AreaDropdownField(
                  selectedArea: _selectedArea,
                  onChanged: (val) => setState(() => _selectedArea = val),
                ),
                CustomClientTextField(
                  label: "اسم النشاط التجاري *",
                  hint: "مثال : صيدلية الأمل",
                  controller: _activityController,
                  validator: (val) => val!.isEmpty ? "النشاط مطلوب" : null,
                ),
                FinancialInfoSection(
                  spentController: _spentController,
                  visitsController: _visitsController,
                ),
                CustomDropdownField(
                  label: "نوع النشاط *",
                  hint: "اختر نوع النشاط",
                  items: AddClientStaticData.activityTypes,
                  value: _selectedActivityType,
                  onChanged: (val) => setState(() => _selectedActivityType = val),
                ),
                CustomDropdownField(
                  label: "تصنيف العميل *",
                  hint: "اختر التصنيف",
                  items: AddClientStaticData.classifications,
                  value: _selectedClassification,
                  onChanged: (val) => setState(() => _selectedClassification = val),
                ),
                CustomDropdownField(
                  label: "نوع العميل *",
                  hint: "اختر النوع",
                  items: AddClientStaticData.clientTypes,
                  value: _selectedType,
                  onChanged: (val) => setState(() => _selectedType = val),
                ),
                const SizedBox(height: 25),
                const StaticDataSection(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.bluePrimaryDark,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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

  Future<void> _determinePosition() async {
    CustomAlerts.showLoadingDialog(context);
    Position? position = await LocationService.getCurrentLocation();

    if (position != null) {
      String? detectedArea = await LocationService.getAreaFromCoords(position.latitude, position.longitude);
      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        if (detectedArea != null) _selectedArea = detectedArea;
      });
      if (mounted) Navigator.pop(context);
      CustomAlerts.showSnackBar(context, detectedArea != null ? "تم تحديد المنطقة: $detectedArea" : "تم تحديد الموقع");
    } else {
      if (mounted) Navigator.pop(context);
      CustomAlerts.showSnackBar(context, "تأكد من تفعيل الموقع GPS", isError: true);
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      if (_latController.text == "0") {
        CustomAlerts.showSnackBar(context, "الرجاء التقاط الموقع أولاً", isError: true);
        return;
      }
      final client = ClientModel(
        name: _nameEnController.text.trim(),
        nameAr: _nameArController.text.trim(),
        phone: _phoneController.text.trim(),
        activity: _activityController.text.trim(),
        activityType: _selectedActivityType ?? "غير محدد",
        area: _selectedArea ?? "غير محدد",
        classification: _selectedClassification ?? 'A',
        type: _selectedType ?? 'عميل جديد',
        lastVisit: DateTime.now().toString().split(' ')[0],
        totalSpent: int.tryParse(_spentController.text) ?? 0,
        visitsCount: int.tryParse(_visitsController.text) ?? 1,
        address: GeoPoint(double.parse(_latController.text), double.parse(_lngController.text)),
      );
      context.read<AddClientCubit>().addClient(client);
    }
  }

  void _clearForm() {
    _nameArController.clear();
    _nameEnController.clear();
    _phoneController.clear();
    _activityController.clear();
    _spentController.text = "0";
    _visitsController.text = "1";
    setState(() {
      _latController.text = "0"; _lngController.text = "0";
      _selectedClassification = null; _selectedType = null;
      _selectedArea = null; _selectedActivityType = null;
    });
  }
}