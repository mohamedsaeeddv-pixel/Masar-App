import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CustomersMapService {
  static Future<List<Marker>> getCustomerMarkers() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('customers').get();

    final List<Marker> markers = [];

    debugPrint('Customers count: ${snapshot.docs.length}');

    for (final doc in snapshot.docs) {
      final data = doc.data();

      if (!data.containsKey('address')) continue;

      final GeoPoint geoPoint = data['address'];

      markers.add(
        Marker(
          width: 40,
          height: 40,
          point: LatLng(
            geoPoint.latitude,
            geoPoint.longitude,
          ),
          child: const Icon(
            Icons.location_pin,
            color: Colors.red,
            size: 40,
          ),
        ),
      );
    }

    return markers;
  }
}