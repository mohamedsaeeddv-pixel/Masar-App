import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/client_constants.dart';
import '../manager/add_client_cubit.dart';
import '../manager/add_client_state.dart';
import '../../../settings/presentation/manager/settings_cubit.dart';
import '../../../settings/presentation/manager/settings_state.dart';

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

  // الـ Controllers
  final TextEditingController _latController = TextEditingController(text: "0");
  final TextEditingController _lngController = TextEditingController(text: "0");
  final TextEditingController _nameArController = TextEditingController();
  final TextEditingController _nameEnController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _activityController = TextEditingController();
  final TextEditingController _spentController = TextEditingController(text: "0");
  final TextEditingController _visitsController = TextEditingController(text: "1");

  // المتغيرات الخاصة بالـ Dropdowns
  String? _selectedClassification;
  String? _selectedType;
  String? _selectedArea;
  String? _selectedActivityType;

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _phoneController.dispose();
    _activityController.dispose();
    _spentController.dispose();
    _visitsController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. التغليف بـ BlocBuilder عشان الاستجابة اللحظية للخط والـ Dark Mode
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, settingsState) {

        // حساب الـ fontFactor بناءً على الـ State الحالية
        double fontFactor = 1.0;
        if (settingsState is SettingsLoaded) {
          if (settingsState.settings.fontSize == 'كبير') fontFactor = 1.2;
          if (settingsState.settings.fontSize == 'صغير') fontFactor = 0.8;
        }

        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          // الخلفية بتتحدث أوتوماتيك من الثيم اللي في الـ main
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text('add_client.title'.tr(),
                style: TextStyle(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * fontFactor,
                )),
            centerTitle: true,
            backgroundColor: AppColors.bluePrimaryDark,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: BlocListener<AddClientCubit, AddClientState>(
            listener: (context, state) {
              if (state is AddClientLoading) {
                CustomAlerts.showLoadingDialog(context);
              } else if (state is AddClientSuccess) {
                Navigator.pop(context); // إغلاق الـ Loading
                CustomAlerts.showSuccessDialog(context, "common.success_save".tr());
                _clearForm();
              } else if (state is AddClientFailure) {
                Navigator.pop(context); // إغلاق الـ Loading
                CustomAlerts.showSnackBar(context, state.errMessage, isError: true);
              }
            },
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClientNamesSection(
                      nameArController: _nameArController,
                      nameEnController: _nameEnController,
                      fontFactor: fontFactor,
                    ),
                    CustomClientTextField(
                      label: "add_client.phone".tr(),
                      hint: "add_client.phone_hint".tr(),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      fontFactor: fontFactor,
                      validator: (val) => (val == null || val.length != 11) ? "common.phone_error".tr() : null,
                    ),
                    LocationPickerSection(
                      onLocationPressed: _determinePosition,
                      latController: _latController,
                      lngController: _lngController,
                      fontFactor: fontFactor,
                    ),
                    AreaDropdownField(
                      selectedArea: _selectedArea,
                      onChanged: (val) => setState(() => _selectedArea = val),
                      fontFactor: fontFactor,
                    ),
                    CustomClientTextField(
                      label: "add_client.business_name".tr(),
                      hint: "add_client.business_hint".tr(),
                      controller: _activityController,
                      fontFactor: fontFactor,
                      validator: (val) => val!.isEmpty ? "common.required".tr() : null,
                    ),
                    FinancialInfoSection(
                      spentController: _spentController,
                      visitsController: _visitsController,
                      fontFactor: fontFactor,
                    ),
                    CustomDropdownField(
                      label: "client_details.business_type".tr(),
                      hint: "common.choose".tr(),
                      items: AddClientStaticData.activityTypes,
                      value: _selectedActivityType,
                      onChanged: (val) => setState(() => _selectedActivityType = val),
                      fontFactor: fontFactor,
                    ),
                    CustomDropdownField(
                      label: "client_details.classification".tr(),
                      hint: "common.choose".tr(),
                      items: AddClientStaticData.classifications,
                      value: _selectedClassification,
                      onChanged: (val) => setState(() => _selectedClassification = val),
                      fontFactor: fontFactor,
                    ),
                    CustomDropdownField(
                      label: "client_details.client_type".tr(),
                      hint: "common.choose".tr(),
                      items: AddClientStaticData.clientTypes,
                      value: _selectedType,
                      onChanged: (val) => setState(() => _selectedType = val),
                      fontFactor: fontFactor,
                    ),
                    const SizedBox(height: 25),
                    StaticDataSection(fontFactor: fontFactor),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _onSavePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.bluePrimaryDark,
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: Text("add_client.save_button".tr(),
                          style: TextStyle(
                              color: AppColors.textOnPrimary,
                              fontSize: 18 * fontFactor,
                              fontWeight: FontWeight.bold
                          )),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- الدوال الخاصة بالمنطق (Logic) كما هي بدون أي تغيير ---

  Future<void> _determinePosition() async {
    CustomAlerts.showLoadingDialog(context);
    Position? position = await LocationService.getCurrentLocation();

    if (position != null) {
      String lang = context.locale.languageCode;
      String? detectedArea = await LocationService.getAreaFromCoords(
          position.latitude,
          position.longitude,
          lang
      );

      setState(() {
        _latController.text = position.latitude.toString();
        _lngController.text = position.longitude.toString();
        if (detectedArea != null) _selectedArea = detectedArea;
      });

      if (mounted) Navigator.pop(context);
      CustomAlerts.showSnackBar(context, "add_client.location_success".tr());
    } else {
      if (mounted) Navigator.pop(context);
      CustomAlerts.showSnackBar(context, "common.gps_error".tr(), isError: true);
    }
  }

  void _onSavePressed() {
    if (_formKey.currentState!.validate()) {
      if (_latController.text == "0") {
        CustomAlerts.showSnackBar(context, "add_client.location_error".tr(), isError: true);
        return;
      }

      context.read<AddClientCubit>().saveClient(
        nameEn: _nameEnController.text,
        nameAr: _nameArController.text,
        phone: _phoneController.text,
        activity: _activityController.text,
        activityType: _selectedActivityType,
        area: _selectedArea,
        classification: _selectedClassification,
        type: _selectedType,
        lat: _latController.text,
        lng: _lngController.text,
        spent: _spentController.text,
        visits: _visitsController.text,
      );
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
      _latController.text = "0";
      _lngController.text = "0";
      _selectedClassification = null;
      _selectedType = null;
      _selectedArea = null;
      _selectedActivityType = null;
    });
  }
}