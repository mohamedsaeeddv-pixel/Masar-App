import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:masar_app/routes/app_routes.dart';

class CustomersMapService {
  static Future<List<Marker>> getCustomerMarkers(
      BuildContext context,
      ) async {

    final snapshot =
    await FirebaseFirestore.instance.collection('customers').get();

    final List<Marker> markers = [];

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (!data.containsKey('address') || data['address'] is! GeoPoint) {
        continue;
      }

      final geoPoint = data['address'] as GeoPoint;
      final customerPoint =
      LatLng(geoPoint.latitude, geoPoint.longitude);

      markers.add(
        Marker(
          width: 48,
          height: 48,
          point: customerPoint,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                _showCustomerDetails(
                  context,
                  data,
                  customerPoint,
                );
              },
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 48,
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  // ================= POPUP =================
  static void _showCustomerDetails(
      BuildContext context,
      Map<String, dynamic> data,
      LatLng customerPoint,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return StreamBuilder<Position>(
          stream: Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            ),
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final position = snapshot.data!;
            final myLocation =
            LatLng(position.latitude, position.longitude);

            final distance = const Distance().as(
              LengthUnit.Meter,
              myLocation,
              customerPoint,
            );

            final bool isArrived = distance <= 500;

            // ✅ DEBUG الصح
            debugPrint('MY LOCATION: $myLocation');
            debugPrint('CUSTOMER: $customerPoint');
            debugPrint('DISTANCE: $distance');

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'بدون اسم',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('📞 ${data['phone'] ?? 'غير متوفر'}'),
                  const SizedBox(height: 8),
                  Text('📍 ${data['addressText'] ?? ''}'),
                  const SizedBox(height: 12),

                  Text(
                    'المسافة: ${distance.toStringAsFixed(0)} متر',
                    style: TextStyle(
                      color: isArrived ? Colors.green : Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isArrived
                          ? () {
                       
                         context.pushNamed(AppRoutes.clientDetails);
                      }
                          : null,
                      child: const Text('لقد وصلت'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
