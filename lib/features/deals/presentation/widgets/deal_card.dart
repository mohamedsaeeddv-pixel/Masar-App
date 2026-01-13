import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/deal_model.dart';

class DealCard extends StatelessWidget {
  final DealModel deal;
  final double fontFactor;
  final bool isDarkMode;

  const DealCard({super.key, required this.deal, required this.fontFactor, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    String statusKey;

    if (deal.status == "تمت") {
      statusColor = isDarkMode ? const Color(0xFF00E676) : const Color(0xFF2E7D32);
      statusIcon = Icons.check_circle_rounded;
      statusKey = "deals.tabs_done";
    } else if (deal.status == "فشل") {
      statusColor = isDarkMode ? const Color(0xFFFF5252) : const Color(0xFFD32F2F);
      statusIcon = Icons.error_outline_rounded;
      statusKey = "deals.tabs_failed";
    } else {
      statusColor = isDarkMode ? const Color(0xFFFFAB40) : const Color(0xFFF57C00);
      statusIcon = Icons.history_rounded;
      statusKey = "deals.tabs_pending";
    }

    bool isPending = deal.status == 'قيد الانتظار';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF151B26) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isDarkMode ? Border.all(color: const Color(0xFF2D3748), width: 1) : null,
        boxShadow: isDarkMode ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: statusColor.withOpacity(isDarkMode ? 0.12 : 0.08),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(deal.taskTitle, style: GoogleFonts.cairo(color: statusColor, fontSize: 15 * fontFactor, fontWeight: FontWeight.w800)),
                  _buildBadge(statusKey.tr(), statusColor, statusIcon),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(backgroundColor: statusColor.withOpacity(0.1), child: Icon(Icons.person, color: statusColor)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(deal.customerName, style: GoogleFonts.cairo(fontSize: 15 * fontFactor, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                          Text("${"deals.cust_id".tr()}: ${deal.customerId}", style: GoogleFonts.cairo(color: Colors.grey, fontSize: 11 * fontFactor)),
                        ],
                      )),
                      if (!isPending) Text(deal.amount, style: GoogleFonts.cairo(color: isDarkMode ? const Color(0xFF64B5F6) : const Color(0xFF1E63EE), fontWeight: FontWeight.w900, fontSize: 17 * fontFactor)),
                    ],
                  ),
                  const Divider(height: 24),
                  if (!isPending) ...[
                    _buildDetailRow(Icons.phone_android, "common.confirm".tr(), deal.phone), // تأكد من وجود مفتاح phone في الـ JSON
                    const SizedBox(height: 8),
                    _buildDetailRow(Icons.location_on_rounded, "deals.address".tr(), deal.location),
                  ] else Center(child: Text("deals.details_note".tr(), style: GoogleFonts.cairo(color: statusColor, fontSize: 12 * fontFactor, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text("$label: ", style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12 * fontFactor)),
        Expanded(child: Text(value, style: GoogleFonts.cairo(color: isDarkMode ? Colors.white70 : Colors.black, fontSize: 13 * fontFactor, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildBadge(String status, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: Row(children: [Icon(icon, color: Colors.white, size: 12), const SizedBox(width: 4), Text(status, style: GoogleFonts.cairo(color: Colors.white, fontSize: 10 * fontFactor, fontWeight: FontWeight.bold))]),
    );
  }
}