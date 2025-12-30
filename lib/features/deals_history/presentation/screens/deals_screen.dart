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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. Filter Chips (Modified to show active state)
          BlocBuilder<DealsCubit, DealsState>(
            buildWhen: (previous, current) => current is DealsSuccess,
            builder: (context, state) {
              String activeFilter = "الكل";
              if (state is DealsSuccess) {
                activeFilter = state.activeFilter;
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ["الكل", "تمت", "قيد الانتظار", "فشل"].map((filterName) {
                    final isSelected = activeFilter == filterName;
                    return Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: ChoiceChip(
                        label: Text(filterName),
                        selected: isSelected,
                        selectedColor: const Color(0xFF1A56BE),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        onSelected: (bool selected) {
                          if (selected) {
                            context.read<DealsCubit>().filterDeals(filterName);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),

          // 3. List
          Expanded(
            child: BlocBuilder<DealsCubit, DealsState>(
              builder: (context, state) {
                if (state is DealsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DealsSuccess) {
                  if (state.deals.isEmpty) {
                    return const Center(child: Text("لا توجد صفقات حالياً"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.deals.length,
                    itemBuilder: (context, index) => DealCard(deal: state.deals[index]),
                  );
                }
                if (state is DealsError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}