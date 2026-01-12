import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';
import 'package:masar_app/features/daily_tasks/data/models/representative_models/task_model.dart';
import 'package:masar_app/routes/app_routes.dart';

class CustomersMapService {
  // ================= MARKERS =================
  static Future<List<Marker>> getCustomerMarkers({
    required BuildContext context,
    required List<TaskModel> tasks,
  }) async {
    final List<Marker> markers = [];

    for (final task in tasks) {
      final customerPoint = LatLng(task.client.lat, task.client.lng);
    if (task.status == TaskStatus.assigned) {
      markers.add(
        Marker(
          width: 48,
          height: 48,
          point: customerPoint,
          child:  Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => _showCustomerDetails(
                  task: task,
                  clientId: task.client.id,
                context: context,
                name: task.client.name ,
                phone: task.client.phone, customerPoint: customerPoint ,
                tasks: tasks,
                
              ),
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
    }

    return markers;
  }

  // ================= POPUP =================
  static void _showCustomerDetails(
{required BuildContext context,
required String name,
required String clientId,
required TaskModel task,
required String phone,
required LatLng customerPoint,
required List<TaskModel> tasks,
}
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('📞 $phone'),
              const SizedBox(height: 12),
              
              // تحديث الموقع والمسافة
              StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(
                  locationSettings: const LocationSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 5,
                  ),
                ),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final myLocation =
                      LatLng(snapshot.data!.latitude, snapshot.data!.longitude);
                  final distance = const Distance().as(
                    LengthUnit.Meter,
                    myLocation,
                    customerPoint,
                  );
                  final isArrived = distance <= 500;

                  debugPrint('MY LOCATION: $myLocation');
                  debugPrint('CUSTOMER: $customerPoint');
                  debugPrint('DISTANCE: $distance');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                          onPressed: !isArrived
                              ? () => context.pushNamed(
                                AppRoutes.clientDetails,
                              extra: {'clientId': clientId, 'task': task, 'tasks': tasks},
                               )
                              : null,
                          child: const Text('لقد وصلت'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
