import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:masar_app/features/home/map/customer_map_services.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الخريطة'),
      ),
      body: FutureBuilder<List<Marker>>(
        future: CustomersMapService.getCustomerMarkers(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text('حصل خطأ أثناء تحميل الخريطة'),
            );
          }

          // No data
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('لا يوجد نقاط لعرضها'),
            );
          }

          final markers = snapshot.data!;

          return FlutterMap(
            options: MapOptions(
              initialCenter: markers.first.point,
              initialZoom: 11,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.masar.app', // اسم الباكيج الحقيقي
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          );
        },
      ),
    );
  }
}