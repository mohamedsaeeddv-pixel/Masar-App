import 'package:flutter/material.dart';
import 'package:masar_app/core/constants/custom_app_bar.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title:"تفاصيل العميل",leading: 
        Icon(Icons.edit_outlined),
      ),
      body: Center(
        child: Text("Customer Details Screen"),
      ),
    );
  }
}