import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D47A1),
          title: const Text(
            'المهام اليومية',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProgressCard(),
                  const SizedBox(height: 16),
                  _buildNavigationCard(),
                  const SizedBox(height: 20),
                  const Text(
                    'المهام المعلقة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // --- الجزء المطور لسحب البيانات من Firebase ---
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return _buildEmptyStateCard(
                          "عذراً، حدث خطأ ما!",
                          "تأكد من اتصالك بالإنترنت وحاول مرة أخرى.",
                          Icons.wifi_off_rounded,
                        );
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      // التحقق مما إذا كانت المجموعة فارغة
                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildEmptyStateCard(
                          "لا توجد مهام حالياً",
                          "استمتع بوقتك، لا توجد مهام معلقة في قائمتك الآن.",
                          Icons.assignment_turned_in_outlined,
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

                          // استلام الـ ID في متغير لاستخدامه برمجياً فقط (مثل الاستلام أو الحذف)
                          // String taskId = doc.id;

                          return _buildTaskItem(
                            data['taskName'] ?? 'مهمة بدون اسم', // العنوان اللي هيظهر للمستخدم
                            data['name'] ?? 'بدون اسم',
                            data['location'] ?? 'غير محدد',
                            data['price'] ?? '0 جنيه',
                            data['time'] ?? '--:--',
                            data['type'] ?? 'تحصيل',
                          );
                        },
                      );
                    },
                  ),
                  // -------------------------------------------

                  const SizedBox(height: 80),
                ],
              ),
            ),
            _buildChatFAB(),
          ],
        ),
      ),
    );
  }

  // كارت الحالة الفارغة (Empty State)
  Widget _buildEmptyStateCard(String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String id, String name, String loc, String price, String time, String type) {
    Color statusColor = type == "تحصيل" ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  type,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
          const Divider(height: 30, thickness: 0.8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 22, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('العميل: $name', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(loc, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المبلغ: $price',
                style: const TextStyle(color: Color(0xFF0D47A1), fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(time, style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('تقدم اليوم', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('0%', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: 0.05, backgroundColor: Colors.grey[200], color: Colors.blue, minHeight: 6),
          const SizedBox(height: 8),
          const Align(alignment: Alignment.centerLeft, child: Text('0/4 طلبات مكتملة', style: TextStyle(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildNavigationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFF0D47A1), borderRadius: BorderRadius.circular(8)),
              child: const Text('جاهز للملاحة ●', style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ),
          const Icon(Icons.location_on_outlined, size: 70, color: Color(0xFFBBDEFB)),
          const Text('4 عملاء في انتظارك', style: TextStyle(color: Colors.grey)),
          const Text('ابدأ رحلة اليوم', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.near_me_outlined),
                  label: const Text('بدء الملاحة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.location_searching, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatFAB() {
    return Positioned(
      bottom: 20,
      left: 20,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFF0D47A1),
            child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
          ),
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}