import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/deals_cubit.dart';
import '../widgets/deal_card.dart';

class DealsScreen extends StatelessWidget {
  const DealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("الصفقات", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A56BE),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (v) => context.read<DealsCubit>().searchDeals(v),
              decoration: InputDecoration(
                hintText: "ابحث عن صفقة...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          // 2. Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ["الكل", "تمت", "قيد الانتظار", "فشل"].map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(filter),
                    onPressed: () => context.read<DealsCubit>().filterDeals(filter),
                  ),
                );
              }).toList(),
            ),
          ),
          // 3. List
          Expanded(
            child: BlocBuilder<DealsCubit, DealsState>(
              builder: (context, state) {
                if (state is DealsLoading) return const Center(child: CircularProgressIndicator());
                if (state is DealsSuccess) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.deals.length,
                    itemBuilder: (context, index) => DealCard(deal: state.deals[index]),
                  );
                }
                return const Center(child: Text("لا توجد صفقات"));
              },
            ),
          ),
        ],
      ),
    );
  }
}